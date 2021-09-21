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
      json = JSON.parse(payload)
      application = get_application(json)
      family = get_family(json)
      checks = get_checks(json)
      results = save_check(checks, application, family)
      publish_to_enroll(results)
    end

    protected

    def get_checks(json)
      results = {}
      if json["person"]
        person_hash = {}
        person_hash["person"] = { person: json["person"] }
        results[json["person"]["hbx_id"]] = mec_check(person_hash)
      else
        people = json["family"]["family_members"].map { |fm| fm["person"] }
        people.each do |person|
          person_hash = { "person" => {} }
          person_hash["person"]["person"] = person
          results[person["hbx_id"]] = mec_check(person_hash)
        end
      end
      results
    end

    def get_application(json)
      json["application"] || json["family"]["magi_medicaid_applications"][0]["hbx_id"]
    end

    def get_family(json)
      json["fam"] || json["family"]["magi_medicaid_applications"][0]["family_reference"]["hbx_id"]
    end

    def mec_check(person)
      result = call_mec_check(person)
      response = JSON.parse(result.value!.to_json)
      xml = Nokogiri::XML(response["body"])
      response_description = xml.xpath("//xmlns:ResponseDescription", "xmlns" => "http://gov.hhs.cms.hix.dsh.ee.nonesi_mec.ext")
      response_description.text
    end

    def call_mec_check(person)
      Aces::MecCheckCall.new.call(person)
    end

    def save_check(check_results, application, family)
      results = Aces::CreateMecCheck.new.call(
        {
          application_identifier: application,
          family_identifier: family,
          applicant_responses: check_results
        }
      )
      results.success? ? results : Failure("Failed to save MEC check")
    end

    def publish_to_enroll(payload)
      transfer = Aces::InitiateMecCheckToEnroll.new.call(payload.value!.attributes)
      transfer.success? ? Success("Transferred MEC Check to Enroll") : Failure(transfer)
    end

  end
end