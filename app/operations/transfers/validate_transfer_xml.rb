# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'
require 'aca_entities/atp/xml'

module Transfers
  # Validate the AccountTransferRequest against the applicable schemas.
  class ValidateTransferXml
    send(:include, Dry::Monads[:result, :do, :try])

    # @param [String] request the AccountTransferRequest document
    # @return [Dry::Result]
    def call(request)
      document = yield parse_document(request)
      validate_document(document)
    end

    protected

    def parse_document(document_string)
      result = Try do
        Nokogiri::XML(document_string)
      end
      result.or(Failure(:xml_parse_failure))
    end

    def validate_document(doc)
      validator = AcaEntities::Atp::Xml::Validator.new
      validation_result = validator.validate(doc)
      return Success(:ok) if validation_result.empty?
      Failure(validation_result)
    end
  end
end