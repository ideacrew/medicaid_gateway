# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Aces
  # Take a payload and find people. For each person, initiate a MecCheck
  class InitiateMecCheck
    send(:include, Dry::Monads[:result, :do])

    # @param [String] hbxid of application
    # @return [Dry::Result]
    def call(application_payload)
      people = get_people(application_payload)
      checks = mec_check(people)
      results = save_check(checks, application_payload)
      publish_to_enroll(checks)
    end

    protected

    def get_people(payload)
      json = JSON.parse(payload)
      json["family"]["family_members"].map{|fm| fm["person"]}
    end

    def mec_check(people)
      results = {}
      people.each do |person|
        person_hash = {}
        person_hash["person"] = {"person": person} 
        result = Aces::MecCheckCall.new.call(person_hash)
        results[person["hbx_id"]] = result.value!.to_json
      end
      results
    end

    def save_check(check_results, application_payload)
      # TO DO save the data - need to decide if per person or per applications
      payload_json = JSON.parse(application_payload)
      application = payload_json["family"]["magi_medicaid_applications"][0]["hbx_id"]
      family = payload_json["family"]["magi_medicaid_applications"][0]["family_reference"]["hbx_id"]
      responses = check_results
      puts "application identifier: #{application}"
      puts "family_identifier: #{family}"
      puts "applicant_responses: #{responses}"
      Aces::CreateMecCheck.new.call(
        {
          application_identifier: application,
          family_identifier: family,
          applicant_responses: responses
        }
      )
    end

    def publish_to_enroll
      # To DO trigger the event source event to publish the results to Enroll
    end

  end
end