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
      string_payload = yield convert_to_document_string(body_node)
      serialize_response_body(validate_document(string_payload))
    end

    protected

    def parse_xml(body)
      parse_result = Try do
        Nokogiri::XML(body)
      end
      return Failure(:xml_parse_failed) if parse_result.success? && parse_result.value!.blank?
      parse_result.or(Failure(:xml_parse_failed))
    end

    def validate_soap_header(document)
      ::Soap::ValidateUsernametokenSecurityHeader.new.call(document)
    end

    def extract_top_body_node(document)
      result = Try do
        document.at_xpath("//soap:Envelope/soap:Body/atp:AccountTransferRequest", XML_NS)
      end
      return Failure(:missing_body_node) if result.success? && result.value!.blank?
      result.or(Failure(:missing_body_node))
    end

    def convert_to_document_string(body_node)
      Success(body_node.to_xml)
    end

    def validate_document(document)
      Aces::ValidateTransferXml.new.call(document)
    end

    def serialize_response_body(validation_result)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml[:soap].Envelope({ "xmlns:soap" => "http://www.w3.org/2003/05/soap-envelope" }) do |envelope|
          envelope[:soap].Body do |soap_body|
            encode_validation_result(soap_body, validation_result)
          end
        end
      end
      Success(builder.to_xml)
    end

    def encode_validation_result(soap_body, validation_result)
      soap_body[:exch].AccountTransferResponse({
                                                 "xmlns:exch" => "http://at.dsh.cms.gov/exchange/1.0",
                                                 "xmlns:ext" => "http://at.dsh.cms.gov/extension/1.0",
                                                 "xmlns:hix" => "http://hix.cms.gov/0.1/hix-core",
                                                 "ext:atVersion" => "2.4"
                                               }) do |atr|
        atr[:ext].ResponseMetaData do |rmd|
          encode_response_codes_and_description(rmd, validation_result)
        end
      end
    end

    def encode_response_codes_and_description(rmd, validation_result)
      if validation_result.success?
        rmd[:hix].ResponseCode "HS000000"
        rmd[:hix].ResponseDescriptionText "Success"
      else
        rmd[:hix].ResponseCode "HE001111"
        rmd[:hix].ResponseDescriptionText "One or More Rules Failed Validation"
        rmd[:hix].TDSResponseDescriptionText do |text_node|
          text_node.cdata encode_validation_failure(validation_result.failure)
        end
      end
    end

    def encode_validation_failure(validation_failure)
      error_messages = validation_failure.map(&:to_s)
      (["Payload Failed XML Schema Validation:"] + error_messages).join("\n")
    end
  end
end