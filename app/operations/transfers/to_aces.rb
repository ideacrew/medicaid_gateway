# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Transfers
  class ToAces
    send(:include, Dry::Monads[:result, :do])

    # @param [String] Take in the raw payload and serialize and transform it, validate it against the schema and schematron,
    # then tranfer the result to ACES.
    # @return [Dry::Result]
    def call(params, service)
      xml =      yield create_transfer_request(params)
      validated  = yield schema_validation(xml)
      validated  = yield business_validation(validated)
      payload    = yield initiate_transfer(validated, service)
      payload
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
      result = Transfers::ExecuteBusinessXmlValidations.new.call(xml.value!)
      result.success? ? Success(xml) : Failure(result)
    end

    def initiate_transfer(payload, service)
      if service == "aces"
        Aces::PublishRawPayload.new.call(payload)
      else
        Curam::PublishRawPayload.new.call(payload)
      end
    end
  end
end