# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'
require 'aca_entities/medicaid/mec_check'

module MecCheck
  # Take an application payload and add mec check results as evidence to applicants
  class InitiateApplicationMecChecks
    send(:include, Dry::Monads[:result, :do])

    # @param [Hash] params
    # @return [Dry::Result]
    def call(params)
      validated_params = yield validate_params(params)
      application_payload = JSON.parse(validated_params[:payload])
      job = yield find_or_create_job(validated_params[:message_id])
      application_response = yield get_applicant_checks(application_payload, job)
      publish_to_enroll(application_response)
    end

    protected

    def validate_params(params)
      return Failure({ error: "MEC Check feature not enabled." }) unless MedicaidGatewayRegistry[:mec_check].enabled?
      return Failure({ error: "Payload cannot be empty" }) if params[:payload].blank?

      Success(params)
    end

    def find_or_create_job(message_id)
      result = Transmittable::FindOrCreateJob.new.call(message_id: message_id,
                                                       key: :application_mec_check_request,
                                                       started_at: DateTime.now,
                                                       publish_on: DateTime.now)

      if result.success?
        @job = result.value!
        Success(@job)
      else
        Failure('Unable to create job')
      end
    end

    def get_applicant_checks(application_payload, job)
      people = application_payload["applicants"]
      people.each do |person|
        person_mec_check = get_person_mec_check(person, job, application_payload["hbx_id"])
        next unless person_mec_check.success?
        evidence = person["local_mec_evidence"]
        evidence["request_results"] = [person_mec_check.value!]
        evidence["aasm_state"] = generate_aasm_state(person_mec_check.value!)
      end
      Success(application_payload)
    rescue StandardError => e
      Failure({ job_id: job.id, hbx_id: application_payload["hbx_id"], error: "Mec check failure => #{e}" })
    end

    def get_person_mec_check(person, job, application_hbx_id)
      MecCheck::GetMecCheck.new.call({ person: person, job: job,
                                       correlation_id: application_hbx_id })
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

    def publish_to_enroll(payload)
      transfer = Aces::InitiateMecCheckToEnroll.new.call(payload, "application")
      if transfer.success?
        Success("Transferred MEC Check to Enroll")
      else
        Failure({})
      end
    end
  end
end
