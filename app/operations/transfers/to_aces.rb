# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Transfers
  class ToAces
    send(:include, Dry::Monads[:result, :do])

    # @param [String] Take in the raw payload and serialize and transform it, validate it against the schema and schematron,
    # then tranfer the result to ACES.
    # @return [Dry::Result]
    def call(params)
      xml = yield create_transfer_request(params)
      #xml      = yield serialize_to_xml(transfer)
      validated      = yield schema_validation(xml)
      validated      = yield business_validation(validated)
      payload  = yield initiate_transfer(validated)
      payload
    end

    private

    def create_transfer_request(params)
      puts "params: #{params}"
      transfer_request = AcaEntities::Atp::Operations::Aces::GenerateXml.new.call(params)
      puts transfer_request.value!
      Success(transfer_request)
    end

    def serialize_to_xml(transfer_request)
      xml = AcaEntities::Serializers::Xml::Medicaid::Atp::AccountTransferRequest.domain_to_mapper(transfer_request).to_xml
      Success(xml)
    end

    def schema_validation(xml)
      result = Aces::ValidateTransferXml.new.call(xml)
      result.success? ? Success(xml) : Failure(result)
    end

    def business_validation(xml)
      result = Aces::ExecuteBusinessXmlValidations.new.call(xml)
      result.success? ? Success(xml) : Failure(result)
    end

    def initiate_transfer(payload)
      puts "transferring"
      transfer = Aces::PublishRawPayload.new.call(payload)
      transfer.success? ? Success("Transferred account to ACES") : Failure(transfer)
    end
  end
end