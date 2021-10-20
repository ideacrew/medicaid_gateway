# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'
require 'aca_entities/medicaid/mec_check'

module Aces
  # Take an application payload and add mec check results as evidence to applicants
  class InitiateMecChecks
    send(:include, Dry::Monads[:result, :do])

    # @param [String] payload received from Enroll
    # @return [Dry::Result]
    def call(payload)
      return Failure({ error: "MEC Check feature not enabled." }) unless MedicaidGatewayRegistry[:mec_check].enabled?
      json = JSON.parse(payload)
      mec_check = yield create_mec_check(json)
      checks    = yield get_applicant_checks(mec_check, json)
      _results   = yield update_mec_check(mec_check, checks)

      publish_to_enroll(mec_check, checks)
    end

    protected

    def create_mec_check(json)
      application = json["hbx_id"] || "n/a"
      family = json["family_reference"]["hbx_id"] || "n/a"
      results = Aces::CreateMecCheck.new.call(
        {
          application_identifier: application,
          family_identifier: family,
          type: "application"
        }
      )

      return results if results.success?
      Failure({ error: "Failed to save MEC check: #{results.failure}" })
    end

    def get_applicant_checks(mec_check, json)
      people = json["applicants"]
      results = {}
      people.each do |person|
        mc_response = mec_check(person)
        if mc_response.failure?
          error_result = {
            mc_id: mec_check.id,
            error: "#{mc_response.failure} on Person}"
          }
          return Failure(error_result)
        end
        response = mc_response.value!
        p response
        hbx_id = person["person_hbx_id"]
        results[hbx_id] = response[:code_description]
        evidence = person["evidences"].detect { |evi| evi["key"] == "aces_mec" }
        evidence["eligibility_results"] = [response]
        evidence["eligibility_status"] = (response[:mec_verification_code] == "Y") ? :outstanding : :attested
      end
      Success([json, results])
    rescue StandardError => e
      Failure("Mec check failure => #{e}")
    end

    def mec_check(person)
      result = call_mec_check(person)
      return Failure(result.failure) if result.failure?
      response = JSON.parse(result.value!.to_json)
      s_response = serialize_response(response["body"])
      p s_response
    end

    def serialize_response(response)
      xml = Nokogiri::XML(response)
      body = xml.at_xpath("//xml_ns:VerifyNonESIMECResponse", "xml_ns" => "http://gov.hhs.cms.hix.dsh.ee.nonesi_mec.ext")
      Success(AcaEntities::Medicaid::MecCheck::Operations::GenerateResult.new.call(body.to_xml))
    rescue StandardError => e
      p e.backtrace
      Failure("Serializing response error => #{e}")
    end

    def call_mec_check(person)
      Aces::ApplicantMecCheckCall.new.call(person)
    end

    def update_mec_check(mec_check, checks)
      return Success(mec_check) if mec_check.update(applicant_responses: checks[1])

      error_result = {
        mc_id: mec_check.id,
        error: "Failed to save MEC check response: #{mec_check.errors.to_h}"
      }
      Failure(error_result)
    end

    def publish_to_enroll(mec_check, results)
      payload = results[0]
      transfer = Aces::InitiateMecCheckToEnroll.new.call(payload, "application")
      if transfer.success?
        Success("Transferred MEC Check to Enroll")
      else
        error_result = {
          mc_id: mec_check.id,
          error: "Failed to transfer MEC to enroll: #{transfer.failure}"
        }
        Failure(error_result)
      end
    end
  end
end