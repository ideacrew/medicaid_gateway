# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Aces
  # Take a payload and find people. For each person, initiate a MecCheck
  class InitiateMecCheck
    send(:include, Dry::Monads[:result, :do])

    # @param [String] payload received from Enroll
    # @return [Dry::Result]
    def call(payload)
      return Failure({ error: "MEC Check feature not enabled." }) unless MedicaidGatewayRegistry[:mec_check].enabled?

      json = JSON.parse(payload)
      mec_check = yield create_mec_check(json)
      checks    = yield get_person_check(mec_check, json) if json["person"]
      checks    = yield get_people_checks(mec_check, json) if json["people"]
      results   = yield update_mec_check(mec_check, checks)

      publish_to_enroll(mec_check, results)
    end

    protected

    def create_mec_check(json)
      application = json["application"] || "n/a"
      family = json["family_id"]
      results = Aces::CreateMecCheck.new.call(
        {
          application_identifier: application,
          family_identifier: family,
          type: json["type"]
        }
      )

      return results if results.success?
      Failure({ error: "Failed to save MEC check: #{results.failure}" })
    end

    def get_person_check(mec_check, json)
      results = {}
      person_hash = {}
      person_hash["person"] = { person: json["person"] }
      mc_response = mec_check(person_hash)

      if mc_response.failure?
        error_result = {
          mc_id: mec_check.id,
          error: "#{mc_response.failure} in get_person_check}"
        }
        return Failure(error_result)
      end
      results[json["person"]["hbx_id"]] = mc_response.value!
      Success(results)
    end

    def get_people_checks(mec_check, json)
      results = {}
      people = json["people"]
      people.each do |person|
        person_hash = { "person" => {} }
        person_hash["person"]["person"] = person
        mc_response = mec_check(person_hash)

        if mc_response.failure?
          error_result = {
            mc_id: mec_check.id,
            error: "#{mc_response.failure} on Person: #{person['hbx_id']}"
          }
          return Failure(error_result)
        end

        results[person["hbx_id"]] = mc_response.value!
      end
      Success(results)
    end

    def mec_check(person)
      result = call_mec_check(person)
      return Failure(result.failure) if result.failure?

      response = JSON.parse(result.value!.to_json)
      xml = Nokogiri::XML(response["body"])
      response_description = xml.xpath("//xmlns:ResponseDescription", "xmlns" => "http://gov.hhs.cms.hix.dsh.ee.nonesi_mec.ext")

      response_description.empty? ? Failure("XML error: ResponseDescription tag missing.") : Success(response_description.text)
    end

    def call_mec_check(person)
      Aces::MecCheckCall.new.call(person)
    end

    def update_mec_check(mec_check, checks)
      return Success(mec_check) if mec_check.update(applicant_responses: checks)

      error_result = {
        mc_id: mec_check.id,
        error: "Failed to save MEC check response: #{mec_check.errors.to_h}"
      }
      Failure(error_result)
    end

    def publish_to_enroll(mec_check, payload)
      transfer = Aces::InitiateMecCheckToEnroll.new.call(payload.attributes)
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