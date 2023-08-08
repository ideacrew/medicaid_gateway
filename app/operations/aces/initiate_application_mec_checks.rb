# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'
require 'aca_entities/medicaid/mec_check'

module Aces
  # Take an application payload and add mec check results as evidence to applicants
  class InitiateApplicationMecChecks
    send(:include, Dry::Monads[:result, :do])

    # @param [String] payload received from Enroll
    # @return [Dry::Result]
    def call(params)
      # return Failure({ error: "MEC Check feature not enabled." }) unless MedicaidGatewayRegistry[:mec_check].enabled?
      json = JSON.parse(params[:payload])
      job = yield find_or_create_job(params[:message_id])
      _checks = yield get_applicant_checks(json, job)
      # _results  = yield update_mec_check(mec_check, checks)

      # publish_to_enroll(mec_check, checks)
    end

    protected

    def find_or_create_job(message_id)
      result = Jobs::FindOrCreateJob.new.call(message_id: message_id,
                                              key: :application_mec_check_request,
                                              started_at: DateTime.now,
                                              publish_on: DateTime.now)

      if result.success?
        @job = result.value!
        Success(@job)
      else
        result
      end
    end

    def get_applicant_checks(json, job)
      people = json["applicants"]
      people.each do |person|
        _person_mec_check = get_person_mec_check(person, job, json["hbx_id"])
        evidence = person["local_mec_evidence"]
        if evidence
          mc_response = mec_check(person)
          response = mc_response.value!
          evidence["request_results"] = [response]
          evidence["aasm_state"] = generate_aasm_state(response)
        else
          results[hbx_id] = "not MEC checked"
        end
      end
      Success([json, results])
    rescue StandardError => e
      Failure({ mc_id: mec_check.id, error: "Mec check failure => #{e}" })
    end

    def get_person_mec_check(person, job, application_id)
      Aces::GetMecCheck.new.call({ person: person, job: job,
                                   correlation_id: application_id })
    end

    def generate_aasm_state(response)
      case MedicaidGatewayRegistry[:transfer_service].item
      when 'aces'
        transform_to_aasm_state(response[:mec_verification_code])
      when 'curam'
        transform_to_aasm_state(response[:code_description])
      end
    end

    def transform_to_aasm_state(code)
      code == 'Y' ? :outstanding : :attested
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