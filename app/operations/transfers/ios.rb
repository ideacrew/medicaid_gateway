# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'
require 'aca_entities/medicaid/ios'

module Transfers
  # Transfers and family and account from Enroll to a Medicaid service using the IOS format
  class Ios
    send(:include, Dry::Monads[:result, :do, :try])

    def call(params, transfer_id, service)
      _transfer = yield find_transfer(transfer_id)
      ios_payload = yield generate_payload(params, transfer_id)
      _validated = yield validate_ios(ios_payload)
      transfer_response = yield initiate_transfer(ios_payload, transfer_id, service)
      update_transfer(transfer_response, service, transfer)
    end

    private

    def find_transfer(transfer_id)
      @transfer = Aces::Transfer.where(id: transfer_id)&.first
      @transfer ? Success(@transfer) : Failure("failed to find transfer with id #{transfer_id}")
    end

    def generate_payload(_params, _transfer_id)
      # transfer_request = AcaEntities::Medicaid::Ios::Operations::GenerateIos.new.call(params)
      # if transfer_request.success?
      #   payload = transfer_request.value!
      #   @transfer.update!(xml_payload: payload)
      #   Success(transfer_request)
      # else
      #   error_result = {
      #     transfer_id: transfer_id,
      #     failure: "Generate XML failure: #{transfer_request.failure}"
      #   }
      #   Failure(error_result)
      # end
      Success("Everything (fake) worked!")
    end

    def validate_ios(_ios_payload)
      # result = Try do
      #  AcaEntities::Medicaid::Ios::Contracts::SSPDCRequestContract.new.call(ios_payload)
      # end.to_result

      # if result.success?
      #   result
      # else
      #  Failure("Invalid payload: #{result.failure.errors.to_h}")
      # end
      Success("Everything (fake) worked!")
    end

    def initiate_transfer(_ios_payload, _transfer_id, _service)
      # encoding/headers/sending will happen in here. not enough details to model this out yet
      # likely will break into separate operations depending on complexity
      Success("Everything (fake) worked!")
    end

    def update_transfer(_transfer_response, _service)
      # response_failure = transfer_response[:status] == 200 ? nil : "Response has a failure with status #{transfer_response[:status]}"
      # status_text = ?? need to see a response first
      # @transfer.update!(response_payload: transfer_response, callback_status: status_text, failure: response_failure)
      Success("Successfully transferred account from Enroll")
    rescue StandardError => e
      Failure("Failed to update transfer #{e}")
    end

  end
end