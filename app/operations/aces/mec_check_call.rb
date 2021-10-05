# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'
require 'aca_entities/medicaid/mec_check/operations/generate_xml'

module Aces
  # Check for the existance of a person in the Medicare system already, and if so did they have coverage.
  class MecCheckCall
    send(:include, Dry::Monads[:result, :do])

    # @param [String] hbxid of application
    # @return [Dry::Result]
    def call(person_payload)
      xml = yield generate_xml(person_payload)
      _validate_xml = yield validate_xml(xml)
      built_check = yield build_check_request(xml)
      encoded_check = yield encode_check(built_check)
      submit_check(encoded_check)
    end

    protected

    def generate_xml(payload)
      transfer_request = ::AcaEntities::Medicaid::MecCheck::Operations::GenerateXml.new.call(payload.to_json)
      transfer_request.success? ? Success(transfer_request) : Failure("Transform failure")
    end

    def validate_xml(seralized_xml)
      document = Nokogiri::XML(seralized_xml.value!)
      xsd_path = File.open(Pathname.pwd.join("spec/test_data/nonesi_mec.xsd"))
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
      Aces::BuildAccountTransferRequest.new.call(transfer.value!)
    end

    def encode_check(payload)
      Aces::EncodeAccountTransferRequest.new.call(payload)
    end

    def submit_check(encoded_check)
      Aces::SubmitMecCheckPayload.new.call(encoded_check)
    end
  end
end