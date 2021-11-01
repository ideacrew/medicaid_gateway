# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'
require 'aca_entities/atp/operations/aces/generate_xml'

module Transfers
  # Transfers and family and account from CMS to a Medicaid service
  class FromCms
    send(:include, Dry::Monads[:result, :do])

    # @param [String] Take in the raw payload and serialize and transform it, validate it against the schema and schematron,
    # then tranfer the result to ACES.
    # @return [Dry::Result]
    def call(params)
      transfer_id = yield record_transfer(params)
      transfer_response = yield initiate_transfer(params, transfer_id)
      update_transfer(transfer_id, transfer_response)
    end

    private

    def record_transfer(params)
      @service = MedicaidGatewayRegistry[:transfer_service].item
      transfer = Transfers::Create.new.call({
                                              service: "CMS to #{@service}",
                                              application_identifier: "N/A",
                                              family_identifier: "N/A",
                                              xml_payload: params,
                                              from_cms: true
                                            })
      transfer.success? ? Success(transfer.value!.id) : Failure("Failed to record transfer: #{transfer.failure}")
    end

    def initiate_transfer(payload, transfer_id)
      return unless @service == "aces"
      result = Aces::PublishRawPayload.new.call(payload.squish)
      return result if result.success?
      error_result = {
        transfer_id: transfer_id,
        failure: "Failed to initiate transfer: #{result.failure}"
      }
      Failure(error_result)
    end

    def update_transfer(transfer_id, response)
      transfer = Aces::Transfer.find(transfer_id)
      response_json = response.to_json
      if @service == "aces"
        xml = Nokogiri::XML(response.to_hash[:body])
        status = xml.xpath('//tns:ResponseDescriptionText', 'tns' => 'http://hix.cms.gov/0.1/hix-core')
        status_text = status.any? ? status.last.text : "N/A"
        payload = status_text == "Success" ? "" : transfer.xml_payload
        transfer.update!(response_payload: response_json, callback_status: status_text, xml_payload: payload)
      else
        transfer.update!(response_payload: response_json)
      end
      Success("Successfully transferred account from CMS")
    end
  end
end