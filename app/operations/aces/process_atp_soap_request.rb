# frozen_string_literal: true

module Aces
  # Read and try to make sense of an ATP request issued by ACES to us.
  class ProcessAtpSoapRequest
    send(:include, Dry::Monads[:result, :do, :try])

    XML_NS = {
      "atp" => "http://at.dsh.cms.gov/exchange/1.0",
      "soap" => "http://www.w3.org/2003/05/soap-envelope",
      "ns3" => "http://niem.gov/niem/niem-core/2.0",
      "ns2" => "http://hix.cms.gov/0.1/hix-ee",
      "hix-core" => "http://hix.cms.gov/0.1/hix-core",
      "xmlns" => "http://at.dsh.cms.gov/extension/1.0"
    }.freeze

    CMS_RESPONSES = {
      failure: "1111",
      success: "0000"
    }.freeze

    SERVICE_RESPONSES = {
      failure: "HE001111",
      success: "HS000000"
    }.freeze

    # @param [IO] body the body of the request
    # @return [Dry::Result]
    def call(body, transfer_id)
      parsed_payload = yield parse_xml(body)
      _identifier = yield get_id(parsed_payload, transfer_id)
      _validation_result = yield validate_soap_header(parsed_payload)
      body_node = yield extract_top_body_node(parsed_payload)
      string_payload = yield convert_to_document_string(body_node)
      serialized = yield run_validations_and_serialize(string_payload)
      _transfer = yield transfer_account(string_payload, transfer_id)
      Success(serialized)
    end

    protected

    def run_validations_and_serialize(string_payload)
      if @to_enroll
        schema_result = validate_document(string_payload)
        return serialize_response_body(schema_result) unless schema_result.success?

        serialize_response_body(run_business_validations(string_payload))
      else
        payload = serialize_response_body(Success("not validated"))
        @transfer.update!(payload: payload)
        payload
      end
    end

    def run_business_validations(string_payload)
      validation = Transfers::ExecuteBusinessXmlValidations.new.call(string_payload)
      validation.success? ? Success(string_payload) : validation
    end

    def parse_xml(body)
      parse_result = Try do
        Nokogiri::XML(body)
      end
      return Failure(:xml_parse_failed) if parse_result.success? && parse_result.value!.blank?
      parse_result.or(Failure(:xml_parse_failed))
    end

    def get_id(payload, transfer_id)
      identity_tag = payload.xpath("//ns2:InsuranceApplication/hix-core:ApplicationIdentification/ns3:IdentificationID", XML_NS)
      recipient_node = payload.xpath("//xmlns:RecipientTransferActivityCode", XML_NS)

      return Failure("XML error: ID tag missing.") if identity_tag.empty?
      return Failure("XML error: RecipientTransferActivityCode missing.") if recipient_node.empty?

      @transfer = Aces::InboundTransfer.find(transfer_id)
      @to_enroll = recipient_node.text == "Exchange"
      @transfer.update!(external_id: identity_tag.text, payload: payload, result: "Parsed", to_enroll: @to_enroll)
      Success(identity_tag.text)
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
      Success(body_node.canonicalize)
    end

    def validate_document(document)
      Transfers::ValidateTransferXml.new.call(document)
    end

    def serialize_response_body(validation_result)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml[:soap].Envelope({ "xmlns:soap" => "http://www.w3.org/2003/05/soap-envelope" }) do |envelope|
          envelope[:soap].Body do |soap_body|
            encode_validation_result(soap_body, validation_result)
          end
        end
      end
      validation_result.success? ? Success(builder.to_xml) : Failure(builder.to_xml)
    end

    def encode_validation_result(soap_body, validation_result)
      soap_body[:exch].AccountTransferResponse({
                                                 "xmlns:exch" => "http://at.dsh.cms.gov/exchange/1.0",
                                                 "xmlns:ext" => "http://at.dsh.cms.gov/extension/1.0",
                                                 "xmlns:hix" => "http://hix.cms.gov/0.1/hix-core",
                                                 "ext:atVersionText" => "2.4"
                                               }) do |atr|
        atr[:ext].ResponseMetadata do |rmd|
          encode_response_codes_and_description(rmd, validation_result)
        end
      end
    end

    def encode_response_codes_and_description(rmd, validation_result)
      responses = @to_enroll ? SERVICE_RESPONSES : CMS_RESPONSES
      if validation_result.success?
        rmd[:hix].ResponseCode responses[:success]
        rmd[:hix].ResponseDescriptionText "Success"
      elsif validation_result.failure.to_s == "validator_crashed"
        rmd[:hix].ResponseCode responses[:failure]
        rmd[:hix].ResponseDescriptionText "Validator Crashed"
      else
        rmd[:hix].ResponseCode responses[:failure]
        rmd[:hix].ResponseDescriptionText "One or More Rules Failed Validation"
        rmd[:hix].TDSResponseDescriptionText do |text_node|
          text_node.cdata encode_validation_failure(validation_result.failure)
        end
      end
    end

    def encode_validation_failure(validation_failure)
      case validation_failure
      when AtpBusinessRuleFailure
        error_messages = validation_failure.failed_assertions.map do |fa|
          ["Location:\n", fa.location, "\n\nText:\n", fa.text, "\n\n"].join
        end
        (["Message Failed Business Validation:"] + error_messages).join("\n")
      else
        error_messages = validation_failure.map(&:to_s)
        (["Payload Failed XML Schema Validation:"] + error_messages).join("\n")
      end
    end

    def transfer_account(payload, transfer_id)
      if @to_enroll
        return Success(payload) if MedicaidGatewayRegistry.feature_enabled?(:bulk_transfer_to_enroll)
        return Success(payload) unless MedicaidGatewayRegistry.feature_enabled?(:transfer_to_enroll)
        Transfers::ToEnroll.new.call(payload, transfer_id)
      else
        Success(@transfer)
      end
    end

  end
end