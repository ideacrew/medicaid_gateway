# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'
require 'aca_entities/medicaid/mec_check/operations/generate_xml'
require 'aca_entities/operations/encryption/decrypt'

module Aces
  # Check for the existance of an applicant in the Medicare system already, and if so did they have coverage.
  class ApplicantMecCheckCall
    send(:include, Dry::Monads[:result, :do])

    # @param [String] hbxid of application
    # @return [Dry::Result]
    def call(person_payload)
      ssn = yield decrypt_ssn(person_payload)
      person_hash = yield map_to_person(person_payload, ssn)
      xml = yield generate_xml(person_hash)
      _validate_xml = yield validate_xml(xml)
      built_check = yield build_check_request(xml)
      encoded_check = yield encode_check(built_check)
      submit_check(encoded_check)
    end

    protected

    def decrypt_ssn(payload)
      ssn = payload["identifying_information"]["encrypted_ssn"]
      if ssn.blank?
        Failure("No SSN")
      else
        AcaEntities::Operations::Encryption::Decrypt.new.call({ value: ssn })
      end
    rescue StandardError => e
      Failure("Failed to Decrypt SSN #{e}")
    end

    def map_to_person(payload, ssn)
      payload["person"] = {}
      payload["person"]["person"] = {}
      payload["person"]["person"]["person_demographics"] = {}
      payload["person"]["person"]["person_name"] = payload["name"]
      payload["person"]["person"]["person_demographics"]["ssn"] = ssn
      payload["person"]["person"]["person_demographics"]["dob"] = payload["demographic"]["dob"]
      payload["person"]["person"]["person_demographics"]["gender"] = payload["demographic"]["gender"]
      Success(payload)
    end

    def generate_xml(payload)
      transfer_request = ::AcaEntities::Medicaid::MecCheck::Operations::GenerateXml.new.call(payload.to_json)
      transfer_request.success? ? transfer_request : Failure("Generate XML failure: #{transfer_request.failure}")
    end

    def validate_xml(seralized_xml)
      document = Nokogiri::XML(seralized_xml)
      xsd_path = File.open(Rails.root.join("artifacts", "aces", "nonesi_mec.xsd"))
      schema_location = File.expand_path(xsd_path)
      schema = Nokogiri::XML::Schema(File.open(schema_location))
      result = schema.validate(document).each_with_object([]) do |error, collect|
        collect << error.message
      end

      if result.empty?
        Success(true)
      else
        Failure("validate_xml -> #{result}")
      end
    end

    def build_check_request(transfer)
      Aces::BuildAccountTransferRequest.new.call(transfer)
    end

    def encode_check(payload)
      Aces::EncodeAccountTransferRequest.new.call(payload)
    end

    def submit_check(encoded_check)
      Aces::SubmitMecCheckPayload.new.call(encoded_check)
    end
  end
end