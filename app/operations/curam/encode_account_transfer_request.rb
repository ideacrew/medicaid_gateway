# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Curam
  # Encodes an AccountTransferRequest into a wire payload that Curam will
  # accept.  Currently this is encoded as a soap literal with a SOAP
  # security header.
  class EncodeAccountTransferRequest
    send(:include, Dry::Monads[:result, :do])

    # @param [Aces::AccountTransferRequest] request
    # @return [Dry::Result<String>]
    def call(request)
      envelope = encode_soap_envelope(request)
      encode_soap_body(envelope, request)
    end

    protected

    def encode_soap_header(xml, request)
      request_header = request.header
      xml[:soap].Header do |header|
        header[:wsse].Security({
                                 "xmlns:wsse" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd",
                                 "xmlns:wsu" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
                               }) do |security|
          security[:wsse].UsernameToken({
                                          "wsu:Id" => "UsernameToken-E2D62235026636E65716286872744061"
                                        }) do |ut|
            ut[:wsse].Username request_header.username
            ut[:wsse].Password({
                                 "Type" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText"
                               }, encode_password(request_header.password, request_header.created))
            ut[:wsu].Created request_header.created
          end
        end
      end
    end

    def encode_soap_body(built, request)
      str = "<\/soap:Header>"
      payload = built.value!
      pos = payload.index(str)
      Success(payload.insert(pos + str.size, "<soap:Body>#{request.raw_body}<\/soap:Body>"))
    end

    def encode_soap_envelope(request)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml[:soap].Envelope({ "xmlns:soap" => "http://www.w3.org/2003/05/soap-envelope",
                              "xmlns:v1" => "http://xmlns.dhcf.dc.gov/dcas/Medicaid/Eligibility/xsd/v1",
                              "xmlns:v11" => "http://xmlns.dc.gov/dcas/common/CommonNative/xsd/V1" }) do |envelope|
          encode_soap_header(envelope, request)
        end
      end
      Success(builder.to_xml)
    end

    def encode_password(password, _created_at)
      # Digest::SHA1.base64digest(nonce + created_at + password)
      # Configure for password digest later.  Right now they use raw passwordtext.
      password
    end
  end
end