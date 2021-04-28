# frozen_string_literal: true

module Aces
  # Read and try to make sense of an ATP request issued by ACES to us.
  class ProcessAtpSoapRequest
    send(:include, Dry::Monads[:result, :do, :try])

    XML_NS = {
      "atp" => "http://at.dsh.cms.gov/exchange/1.0",
      "soap" => "http://www.w3.org/2003/05/soap-envelope"
    }.freeze

    # @param [IO] body the body of the request
    # @return [Dry::Result]
    def call(body)
      parsed_payload = yield parse_xml(body)
      _validation_result = yield validate_soap_header(parsed_payload)
      body_node = yield extract_top_body_node(parsed_payload)
      _string_payload = yield convert_to_document_string(body_node)
      Success(:ok)
    end

    protected

    def parse_xml(body)
      parse_result = Try do
        Nokogiri::XML(body)
      end
      parse_result.or(Failure(:xml_parse_failed))
    end

    def validate_soap_header(document)
      ::Soap::ValidateUsernametokenSecurityHeader.new.call(document)
    end

    def extract_top_body_node(document)
      result = Try do
        document.at_xpath("//soap:Envelope/soap:Body/atp:AccountTransferRequest", XML_NS)
      end
      result.or(Failure(:missing_body_node))
    end

    def convert_to_document_string(body_node)
      Success(body_node.to_xml)
    end
  end
end