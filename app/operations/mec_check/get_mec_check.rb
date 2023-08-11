# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'
require 'aca_entities/medicaid/mec_check/operations/generate_xml'
require 'aca_entities/operations/encryption/decrypt'

module MecCheck
  # Check for the existance of an applicant in the Medicare system already, and if so did they have coverage.
  class GetMecCheck
    send(:include, Dry::Monads[:result, :do])

    # @param [Hash] params hash
    # @return [Dry::Result]
    def call(params)
      validated_params = yield validate_params(params)
      @request_transmission = yield create_request_transmission(validated_params)
      @subject = yield create_person_subject(validated_params[:person])
      @request_transaction = yield create_request_transaction(validated_params[:person])
      @response_payload = yield run_mec_check(validated_params[:person])
      @response_transmission = yield create_response_transmission(validated_params)
      @response_transaction = yield create_response_transaction(validated_params[:person])
      transform_response_payload
    end

    protected

    def validate_params(params)
      return Failure('Cannot get mec check with job') unless params[:job].is_a?(Transmittable::Job)
      @job = params[:job]
      return Failure('Cannot get mec check without person') unless params[:person]
      return Failure('Cannot get mec check without correlation_id') unless params[:correlation_id]

      Success(params)
    end

    def create_request_transmission(values)
      result = Transmittable::CreateTransmission.new.call({ job: @job,
                                                            key: :application_mec_check_request,
                                                            started_at: DateTime.now,
                                                            correlation_id: values[:correlation_id],
                                                            event: 'initial',
                                                            state_key: :initial })

      return result if result.success?
      add_errors({ job: @job }, "Failed to create transmission due to #{result.failure}", :create_request_transmission)
      status_result = update_status({ job: @job }, :failed, result.failure)
      return status_result if status_result.failure?
      Failure("Unable to create request Transmission")
    end

    def create_person_subject(person)
      existing_person = ::Transmittable::Person.where(hbx_id: person["person_hbx_id"]).first

      if existing_person
        Success(existing_person)
      else
        result = Transmittable::CreatePerson.new.call(person)
        return result if result.success?
        add_errors({ transmission: @request_transmission },
                   "Failed to create person subject with HBX ID #{person['person_hbx_id']} due to #{result.failure}", :create_person_subject)
        status_result = update_status({ transmission: @request_transmission }, :failed, result.failure)
        return status_result if status_result.failure?
        Failure("Unable to create person subject")
      end
    end

    def create_request_transaction(person)
      result = Transmittable::CreateTransaction.new.call({ transmission: @request_transmission,
                                                           subject: @subject,
                                                           key: :application_mec_check_request,
                                                           started_at: DateTime.now,
                                                           correlation_id: person["person_hbx_id"],
                                                           event: 'initial',
                                                           state_key: :initial })

      return result if result.success?
      add_errors({ transmission: @request_transmission }, "Failed to create transaction due to #{result.failure}", :create_request_transaction)
      status_result = update_status({ transmission: @request_transmission }, :failed, result.failure)
      return status_result if status_result.failure?
      Failure("Unable to create request Transaction")
    end

    def run_mec_check(person)
      if person["local_mec_evidence"]
        result = call_mec_check(person)
        if result.success?
          status_result = update_status({ transmission: @request_transmission, transaction: @request_transaction }, :succeeded, "Mec check completed")
        else
          add_errors({ transmission: @request_transmission, transaction: @request_transaction }, "Mec check call failed", :run_mec_check)
          status_result = update_status({ transmission: @request_transmission, transaction: @request_transaction }, :failed, result.failure)
        end
        return status_result if status_result.failure?
        result
      else
        add_errors({ transmission: @request_transmission, transaction: @request_transaction }, "No evidence present", :run_mec_check)
        status_result = update_status({ transmission: @request_transmission, transaction: @request_transaction }, :failed, "Person has no evidence")
        return status_result if status_result.failure?
        Failure("No evidence present")
      end
    end

    def call_mec_check(person)
      # In future when mec check per person is made we have to add condition here for person instead of applicant
      Aces::ApplicantMecCheckCall.new.call(person, @request_transaction)
    end

    def create_response_transmission(values)
      result = Transmittable::CreateTransmission.new.call({ job: @job,
                                                            key: :application_mec_check_response,
                                                            started_at: DateTime.now,
                                                            correlation_id: values[:correlation_id],
                                                            event: 'received',
                                                            state_key: :received })

      return result if result.success?
      add_errors({ job: @job }, "Failed to create response transmission due to #{result.failure}", :create_response_transmission)
      status_result = update_status({ job: @job }, :failed, result.failure)
      status_result if status_result.failure?
      Failure("Unable to create response Transmission")
    end

    def create_response_transaction(person)
      result = Transmittable::CreateTransaction.new.call({ transmission: @response_transmission,
                                                           subject: @subject,
                                                           key: :application_mec_check_response,
                                                           started_at: DateTime.now,
                                                           correlation_id: person["person_hbx_id"],
                                                           event: 'received',
                                                           state_key: :received })

      return result if result.success?
      add_errors({ transmission: @response_transmission }, "Failed to create response transaction due to #{result.failure}",
                 :create_response_transaction)
      status_result = update_status({ transmission: @response_transmission }, :failed, result.failure)
      return status_result if status_result.failure?
      Failure("Unable to create response Transaction")
    end

    def transform_response_payload
      response_json = JSON.parse(@response_payload.to_json)
      result = serialize_response(response_json["body"])
      if result.success?
        @response_transaction.xml_payload = @response_payload[:body] # xml response received from mec service
        @response_transaction.json_payload = result.value! # payload that will be sent to enroll, good to store but do we need this?
        @response_transaction.save
        status_result = update_status({ transmission: @response_transmission, transaction: @response_transaction }, :succeeded,
                                      "Mec check completed saved payload on transaction")
      else
        add_errors({ transmission: @response_transmission, transaction: @response_transaction },
                   "Failed to create response transaction due to #{result.failure}", :transform_response_payload)
        status_result = update_status({ transmission: @response_transmission, transaction: @response_transaction }, :failed, result.failure)
      end
      return status_result if status_result.failure?
      result
    end

    def serialize_response(response)
      xml = Nokogiri::XML(response)
      body = if MedicaidGatewayRegistry[:transfer_service].item == "aces"
               xml.at_xpath("//xml_ns:VerifyNonESIMECResponse", "xml_ns" => "http://gov.hhs.cms.hix.dsh.ee.nonesi_mec.ext")
             else
               xml.at_xpath("//xmlns:GetEligibilityResponse", "xmlns" => "http://xmlns.dhcf.dc.gov/dcas/Medicaid/Eligibility/xsd/v1")
             end
      Success(AcaEntities::Medicaid::MecCheck::Operations::GenerateResult.new.call(body.to_xml))
    rescue StandardError => e
      Failure("Serializing response error => #{e}")
    end

    def add_errors(transmittable_objects, message, error_key)
      Transmittable::AddError.new.call({ transmittable_objects: transmittable_objects, key: error_key, message: message })
    end

    def update_status(transmittable_objects, state, message)
      Transmittable::UpdateProcessStatus.new.call({ transmittable_objects: transmittable_objects, state: state, message: message })
    end
  end
end
