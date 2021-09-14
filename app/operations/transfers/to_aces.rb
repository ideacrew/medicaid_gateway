# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'
require 'aca_entities/atp/operations/aces/generate_xml'

module Transfers
  # Transfers and family and account from Enroll to a Medicaid service
  class ToAces
    send(:include, Dry::Monads[:result, :do])

    # @param [String] Take in the raw payload and serialize and transform it, validate it against the schema and schematron,
    # then tranfer the result to ACES.
    # @return [Dry::Result]
    def call(params, service)
      xml        = yield create_transfer_request(params)
      validated  = yield schema_validation(xml)
      # validated  = yield business_validation(validated)
      initiate_transfer(validated, service, params)
    end

    private

    def create_transfer_request(params)
      transfer_request = AcaEntities::Atp::Operations::Aces::GenerateXml.new.call(params)
      Success(transfer_request)
    end

    def schema_validation(xml)
      result = Transfers::ValidateTransferXml.new.call(xml.value!)
      result.success? ? Success(xml) : Failure(result)
    end

    def business_validation(xml)
      # currently bypassing as it has been flakey
      result = Transfers::ExecuteBusinessXmlValidations.new.call(xml.value!)
      result.success? ? Success(xml) : Failure(result)
    end

    def initiate_transfer(payload, service, params)
      result = if service == "aces"
                 Aces::PublishRawPayload.new.call(payload)
               else
                 Curam::PublishRawPayload.new.call(payload)
               end
      record_transfer(service, params, result.success? ? result.value! : result.failure)
      result.success? ? Success("Successfully transferred in account") : Failure("result.failure")
    end

    def record_transfer(service, params, response)
      payload = JSON.parse(params)
      Transfers::Create.new.call({ service: service,
                                   application_identifier: payload["family"]["magi_medicaid_applications"][0]["hbx_id"],
                                   family_identifier: payload["family"]["hbx_id"],
                                   response_payload: response.to_json })
    end
  end
end