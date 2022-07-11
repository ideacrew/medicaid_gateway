# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'
require 'aca_entities/atp/operations/aces/generate_xml'

module Transfers
  # Record the transfers and kicks off operations to generate and send the payloads
  class ToService
    send(:include, Dry::Monads[:result, :do])

    # Take in the raw payload and serialize and transform it, validate it against the schema and schematron,
    # then tranfer the result to the service.
    def call(params, transfer_id = "")
      transfer_id = yield record_transfer(params, transfer_id)
      _valid_applicants = yield validate_applicants(params, transfer_id)
      generate_and_send_payload(params, transfer_id)
    end

    private

    def record_transfer(params, transfer_id)
      payload = JSON.parse(params)
      @service = MedicaidGatewayRegistry[:transfer_service].item
      if transfer_id.blank?
        primary = payload["family"]["family_members"].detect { |fm| fm["is_primary_applicant"] == true }
        primary_id = primary["hbx_id"] if primary
        transfer = Transfers::Create.new.call({
                                                service: @service,
                                                application_identifier: payload["family"]["magi_medicaid_applications"]["hbx_id"] || "not found",
                                                family_identifier: primary_id || "family_id not found",
                                                outbound_payload: params
                                              })
        transfer.success? ? Success(transfer.value!.id) : Failure("Failed to record transfer: #{transfer.failure}")
      else
        Success(transfer_id)
      end
    end

    def validate_applicants(params, transfer_id)
      payload = JSON.parse(params)
      applicants = payload.dig("family", "magi_medicaid_applications", "applicants")
      result = applicants&.each_with_object([]) do |applicant, collect|
        collect << applicant["is_applying_coverage"]
      end
      return Success("Valid applicants.") if result&.include?(true)

      error_result = {
        transfer_id: transfer_id,
        failure: "Application does not contain any applicants applying for coverage."
      }
      Failure(error_result)
    end

    def generate_and_send_payload(params, transfer_id)
      return ::Transfers::Atp.new.call(params, transfer_id, @service) if MedicaidGatewayRegistry[:transfer_payload_type_atp].enabled?
      # AcaEntities::Medicaid::Ios::Operations::GenerateIos
      ::Transfers::Ios.new.call(params, transfer_id, @service) if MedicaidGatewayRegistry[:transfer_payload_type_ios].enabled?
    end

  end
end