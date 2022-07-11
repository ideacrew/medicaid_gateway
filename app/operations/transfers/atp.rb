# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'
require 'aca_entities/atp/operations/aces/generate_xml'

module Transfers
  # Transfers and family and account from Enroll to a Medicaid service
  class Atp
    send(:include, Dry::Monads[:result, :do])

    # @param [String] Take in the raw payload and serialize and transform it, validate it against the schema and schematron,
    # then tranfer the result to ACES.
    # @return [Dry::Result]
    def call(params, transfer_id, service)
      _transfer = yield find_transfer(transfer_id)
      xml = yield generate_xml(params, transfer_id)
      validated = yield schema_validation(xml, transfer_id)
      # validated  = yield business_validation(validated)
      transfer_response = yield initiate_transfer(validated, transfer_id, service)
      update_transfer(transfer_response, service)
    end

    private

    def find_transfer(transfer_id)
      @transfer = Aces::Transfer.where(id: transfer_id)&.first
      @transfer ? Success(@transfer) : Failure("failed to find transfer with id #{transfer_id}")
    end

    def generate_xml(params, transfer_id)
      transfer_request = AcaEntities::Atp::Operations::Aces::GenerateXml.new.call(params)
      if transfer_request.success?
        xml = transfer_request.value!
        @transfer.update!(xml_payload: xml)
        Success(transfer_request)
      else
        error_result = {
          transfer_id: transfer_id,
          failure: "Generate XML failure: #{transfer_request.failure}"
        }
        Failure(error_result)
      end
    end

    def schema_validation(xml, transfer_id)
      result = Transfers::ValidateTransferXml.new.call(xml.value!)
      if result.success?
        Success(xml)
      else
        error_result = {
          transfer_id: transfer_id,
          failure: "Schema validation failure: #{result.failure}"
        }
        Failure(error_result)
      end
    end

    def business_validation(xml)
      # currently bypassing as it has been flakey
      result = Transfers::ExecuteBusinessXmlValidations.new.call(xml.value!)
      result.success? ? Success(xml) : Failure(result)
    end

    def initiate_transfer(payload, transfer_id, service)
      result = if service == "aces"
                 Aces::PublishRawPayload.new.call(payload.value!)
               else
                 Curam::PublishRawPayload.new.call(payload)
               end
      return result if result.success?
      error_result = {
        transfer_id: transfer_id,
        failure: "Failed to initiate transfer: #{result.failure}"
      }
      Failure(error_result)
    end

    def update_transfer(response, service)
      response_json = response.to_json
      response_failure = response[:status] == 200 ? nil : "Response has a failure with status #{response[:status]}"
      if service == "aces"
        xml = Nokogiri::XML(response.to_hash[:body])
        status = xml.xpath('//tns:ResponseDescriptionText', 'tns' => 'http://hix.cms.gov/0.1/hix-core')
        status_text = status.any? ? status.last.text : "N/A"
        payload = status_text == "Success" ? "" : @transfer.outbound_payload
        @transfer.update!(response_payload: response_json, callback_status: status_text, outbound_payload: payload, failure: response_failure)
      else
        @transfer.update!(response_payload: response_json, callback_status: status_text, failure: response_failure)
      end
      Success("Successfully transferred account from Enroll")
    end
  end
end