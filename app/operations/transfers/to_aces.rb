# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'
require 'aca_entities/serializers/xml/medicaid/atp'
require 'aca_entities/medicaid/atp'
require 'aca_entities/atp/operations/aces/generate_xml'

module Transfers
  # Transfers and family and account from Enroll to a Medicaid service
  class ToAces
    send(:include, Dry::Monads[:result, :do])

    # @param [String] Take in the raw payload and serialize and transform it, validate it against the schema and schematron,
    # then tranfer the result to ACES.
    # @return [Dry::Result]
    def call(params, service)
      xml =      yield create_transfer_request(params)
      validated  = yield schema_validation(xml)
      validated  = yield business_validation(validated)
      initiate_transfer(validated, service)
    end

    private

    def create_transfer_request(params)
      puts "created transfer #{params}"
      transfer_request = AcaEntities::Atp::Operations::Aces::GenerateXml.new.call(params)
      puts "xml #{transfer_request.inspect}"
      Success(transfer_request)
    end

    def schema_validation(xml)
      puts "validated transfer #{xml}"
      result = Transfers::ValidateTransferXml.new.call(xml.value!)
      puts result
      result.success? ? Success(xml) : Failure(result)
    end

    def business_validation(xml)
      puts "validating against schematron"
      result = Transfers::ExecuteBusinessXmlValidations.new.call(xml.value!)
      puts result.inspect
      result.success? ? Success(xml) : Failure(result)
    end

    def initiate_transfer(payload, service)
      puts "initiate_transfer"
      if service == "aces"
        Aces::PublishRawPayload.new.call(payload)
      else
        Curam::PublishRawPayload.new.call(payload)
      end
    end
  end
end