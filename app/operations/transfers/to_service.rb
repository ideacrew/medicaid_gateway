# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'
require 'aca_entities/atp/operations/aces/generate_xml'

module Transfers
  # Transfers and family and account from Enroll to a Medicaid service
  class ToService
    send(:include, Dry::Monads[:result, :do])

    # @param [String] Take in the raw payload and serialize and transform it, validate it against the schema and schematron,
    # then tranfer the result to ACES.
    # @return [Dry::Result]
    def call(params)
      transfer_id = yield record_transfer(params)
      xml = yield generate_xml(params, transfer_id)
      validated = yield schema_validation(xml, transfer_id)
      # validated  = yield business_validation(validated)
      initiate_transfer(validated, transfer_id)
    end

    private

    def record_transfer(params)
      payload = JSON.parse(params)
      @service = MedicaidGatewayRegistry[:transfer_service]
      transfer = Transfers::Create.new.call({
                                              service: @service,
                                              application_identifier: payload["family"]["magi_medicaid_applications"]["hbx_id"] || "not found",
                                              family_identifier: payload["family"]["hbx_id"] || "family_id not found"
                                            })
      transfer.success? ? Success(transfer.value!.id) : Failure("Failed to record transfer: #{transfer.failure}")
    end

    def generate_xml(params, transfer_id)
      transfer_request = AcaEntities::Atp::Operations::Aces::GenerateXml.new.call(params)
      if transfer_request.success?
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

    def initiate_transfer(payload, transfer_id)
      result = if @service == "aces"
                 Aces::PublishRawPayload.new.call(payload)
               else
                 Curam::PublishRawPayload.new.call(payload)
               end

      if result.success?
        update_transfer(transfer_id, result.value!)
        Success("Successfully transferred in account")
      else
        error_result = {
          transfer_id: transfer_id,
          failure: "Failed to initiate transfer: #{result.failure}"
        }
        Failure(error_result)
      end
    end

    def update_transfer(transfer_id, response)
      transfer = Aces::Transfer.find(transfer_id)
      response_json = response.to_json
      if @service == "aces"
        xml = Nokogiri::XML(response.to_hash[:body])
        status = xml.xpath('//tns:ResponseDescriptionText', 'tns' => 'http://hix.cms.gov/0.1/hix-core')
        status_text = status.any? ? status.last.text : "N/A"
        transfer.update!(response_payload: response_json, callback_status: status_text)
      else
        transfer.update!(response_payload: response_json)
      end
    end

  end
end