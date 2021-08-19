# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Transfers
  # Run an ACES payload against the schematron business validations.
  class ExecuteBusinessXmlValidations
    send(:include, Dry::Monads[:result, :do, :try])

    XML_NS = {
      svrl: "http://purl.oclc.org/dsdl/svrl"
    }.freeze

    # @param [String] payload
    # @return [Dry::Result]
    def call(payload)
      validator_result = yield execute_validator(payload)
      result_doc = yield parse_result(validator_result)
      check_for_failures(result_doc)
    end

    protected

    def execute_validator(payload)
      attempt = Try do
        AtpBusinessRulesValidationProxy.run_validation(payload)
      end
      attempt.or do |e|
        Rails.logger.error { "Error During Validator Run:\n#{e.inspect}\n" + e.backtrace.join("\n") }
        puts "Error During Validator Run:\n#{e.inspect}\n"
        Failure(:validator_crashed)
      end
    end

    def parse_result(result_string)
      document = Try do
        Nokogiri::XML(result_string)
      end.or(Failure(:result_string_parse_failed))
      return document unless document.success?
      return Failure(:result_string_parse_failed) if document.value!.nil?
      document
    end

    def check_for_failures(parsed_document)
      found_errors = parsed_document.xpath("//svrl:failed-assert", XML_NS).any?
      return Success(:ok) unless found_errors
      error_objects = parsed_document.xpath("//svrl:failed-assert", XML_NS).map do |node|
        location = node.at_xpath("@location").content
        message = node.at_xpath("svrl:text").content
        Aces::AtpFailedBusinessAssertion.new({
                                               location: location,
                                               text: message
                                             })
      end
      error_objects.each do |eo|
        puts eo.inspect
      end
      Failure(Aces::AtpBusinessRuleFailure.new({ failed_assertions: error_objects }))
    end
  end
end