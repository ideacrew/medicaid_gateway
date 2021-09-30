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
      checks = yield get_person_check(json) if json["person"]
      checks = yield get_people_checks(json) if json["people"]
      results = yield save_check(checks, json)
      publish_to_enroll(results)
    end

    protected

    def get_person_check(json)
      results = {}
      person_hash = {}
      person_hash["person"] = { person: json["person"] }
      mc_response = mec_check(person_hash)
      return Failure(mc_response.failure) if mc_response.failure?

      results[json["person"]["hbx_id"]] = mc_response.value!
      Success(results)
    end

    def get_people_checks(json)
      results = {}
      people = json["people"]
      people.each do |person|
        person_hash = { "person" => {} }
        person_hash["person"]["person"] = person
        mc_response = mec_check(person_hash)
        return Failure(mc_response.failure) if mc_response.failure?

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

    def save_check(check_results, json)
      application = json["application"] || "n/a"
      family = json["family_id"]
      results = Aces::CreateMecCheck.new.call(
        {
          application_identifier: application,
          family_identifier: family,
          applicant_responses: check_results,
          type: json["type"]
        }
      )
      results.success? ? results : Failure("Failed to save MEC check: #{results.failure.errors.to_h}")
    end

    def publish_to_enroll(payload)
      transfer = Aces::InitiateMecCheckToEnroll.new.call(payload.attributes)
      transfer.success? ? Success("Transferred MEC Check to Enroll") : Failure(transfer)
    end
  end
end