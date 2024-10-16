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
    def call(params, transfer_id = "")
      transfer_id = yield record_transfer(params, transfer_id)
      _valid_applicants = yield validate_applicants(params, transfer_id)
      flagged_params = yield add_param_flags(params, transfer_id)
      xml = yield generate_xml(flagged_params, transfer_id)
      validated = yield schema_validation(xml, transfer_id)
      business_rule_validated = yield business_validation(validated)
      transfer_response = yield initiate_transfer(business_rule_validated, transfer_id)
      update_transfer(transfer_response)
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
      application = payload.dig("family", "magi_medicaid_applications")
      error_result = { transfer_id: transfer_id }
      error_result[:failure] = "No application found in payload." if application.blank?
      return Failure(error_result) if error_result[:failure].present?

      failure_messages = []
      applicants = application["applicants"] if application
      failure_messages << check_applicants_applying_for_coverage(applicants)
      failure_messages << check_applicants_deductions(applicants)
      failure_messages.compact!.flatten!
      error_result[:failure] = failure_messages.join("\n")
      return Failure(error_result) if error_result[:failure].present?

      Success("Valid applicants.")
    end

    def check_applicants_applying_for_coverage(applicants)
      failure_message = "Application does not contain any applicants applying for coverage."
      applicant_checks = applicants&.map {|applicant| applicant["is_applying_coverage"]}
      return failure_message if applicant_checks.nil? || applicant_checks&.all?(false)
    end

    def check_applicants_deductions(applicants)
      return unless MedicaidGatewayRegistry.feature_enabled?(:block_atp_deductions)

      failure_messages = applicants&.each_with_object([]) do |applicant, collect|
        deductions = applicant['deductions']
        person_hbx_id = applicant['person_hbx_id']
        deduction_kinds = deductions.map {|deduction| deduction['kind']}
        failure_message = "Applicant #{person_hbx_id} has unaccepted deductions: #{deduction_kinds}."

        collect << failure_message.gsub(/[\["\]]/, '') if deduction_kinds.present?
      end
      return failure_messages unless failure_messages&.empty?
    end

    def add_param_flags(params, transfer_id)
      payload = JSON.parse(params)
      family_flags = {}
      drop_param_flags = []

      # flags stored on Family level for use in ATP transforms
      family_flags[:invert_person_association] = true if MedicaidGatewayRegistry.feature_enabled?(:invert_person_association)
      payload['family'].merge!({ family_flags: family_flags }) if family_flags.present?

      # flags for dropping parameters before sending payload to ATP transforms
      drop_param_flags << :drop_non_ssn_apply_reason if MedicaidGatewayRegistry.feature_enabled?(:drop_non_ssn_apply_reason)
      drop_param_flags << :drop_income_start_on if MedicaidGatewayRegistry.feature_enabled?(:drop_income_start_on)
      drop_param_flags << :drop_income_end_on if MedicaidGatewayRegistry.feature_enabled?(:drop_income_end_on)
      drop_param_flags << :drop_vlp_document if MedicaidGatewayRegistry.feature_enabled?(:drop_vlp_document)
      drop_param_flags << :drop_temp_out_of_state if MedicaidGatewayRegistry.feature_enabled?(:drop_temp_out_of_state)

      Success(payload.merge(:drop_param_flags => drop_param_flags).to_json)
    rescue ResourceRegistry::Error::FeatureNotFoundError => e
      error_result = {
        transfer_id: transfer_id,
        failure: "Transfers::ToService#add_param_flags - #{e}"
      }
      Failure(error_result)
    end

    def generate_xml(params, transfer_id)
      transfer_request = AcaEntities::Atp::Operations::Aces::GenerateXml.new.call(params)
      @transfer = Aces::Transfer.find(transfer_id)
      if transfer_request.success?
        xml = transfer_request.value!
        @transfer.update!(xml_payload: xml)
        Success(xml)
      else
        error_result = {
          transfer_id: transfer_id,
          failure: "Generate XML failure: #{transfer_request.failure}"
        }
        Failure(error_result)
      end
    end

    def schema_validation(xml, transfer_id)
      result = Transfers::ValidateTransferXml.new.call(xml)
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
      return Success(xml) unless MedicaidGatewayRegistry.feature_enabled?(:execute_outbound_atp_business_rules)
      result = Transfers::ExecuteBusinessXmlValidations.new.call(xml)
      result.success? ? Success(xml) : result
    end

    def initiate_transfer(payload, transfer_id)
      result = if @service == "aces"
                 Aces::PublishRawPayload.new.call(payload)
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

    def update_transfer(response)
      response_json = response.to_json
      response_hash = response.to_hash
      response_failure = response_hash[:status] == 200 ? nil : "Response has a failure with status #{response_hash[:status]}"
      if @service == "aces"
        xml = Nokogiri::XML(response_hash[:body])
        status = xml.xpath('//tns:ResponseDescriptionText', 'tns' => 'http://hix.cms.gov/0.1/hix-core')
        status_text = status.any? ? status.last.text : "N/A"
        payload = status_text == "Success" ? "" : @transfer.outbound_payload
        @transfer.update!(response_payload: response_json, callback_status: status_text, outbound_payload: payload, failure: response_failure)
      else
        @transfer.update!(response_payload: response_json, callback_status: status_text, failure: response_failure)
      end
      Success("Successfully transferred in account")
    end
  end
end