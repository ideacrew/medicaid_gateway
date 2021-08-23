# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Transfers
  # Validate the AccountTransferRequest against the applicable schemas.
  class ValidateTransferXml
    send(:include, Dry::Monads[:result, :do, :try])

    # @param [String] request the AccountTransferRequest document
    # @return [Dry::Result]
    def call(request)
      schema = yield read_schema
      document = yield parse_document(request)
      validate_document(schema, document)
    end

    protected

    def read_schema
      puts "reading schema!"
      result = Try do
        Nokogiri::XML::Schema(File.open(Rails.root.join("artifacts", "aces", "atp_service.xsd")))
      end
      puts result
      result.or(Failure(:xml_schema_not_found))
    end

    def parse_document(document_string)
      puts "parsing"
      puts document_string
      result = Try do
        Nokogiri::XML(document_string)
      end
      result.or(Failure(:xml_parse_failure))
    end

    def validate_document(schema, doc)
      validation_result = schema.validate(doc)
      return Success(:ok) if validation_result.empty?
      Failure(validation_result)
    end
  end
end