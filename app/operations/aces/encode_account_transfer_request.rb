# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Aces
  # Encodes an AccountTransferRequest into a wire payload that ACES will
  # accept.  Currently this is encoded as a soap literal with a SOAP
  # security header.
  class EncodeAccountTransferRequest
    send(:include, Dry::Monads[:result, :do])

    # @param [Aces::AccountTransferRequest] request
    # @return [Dry::Result<String>]
    def call(request)
      encode_soap_envelope(request)
    end

    protected

    def encode_soap_header(xml, request)
      request_header = request.header
      xml[:soap].Header do |header|
        header[:wsse].Security({
                                 "xmlns:wsse" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd",
                                 "xmlns:wsu" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
                               }) do |security|
          # wsse:UsernameToken wsu:Id="UsernameToken-73590BD4745C9F3F7814189343300461"
          security[:wsse].UsernameToken({
                                          "wsu:Id" => "UsernameToken-73590BD4745C9F3F7814189343300461"
                                        }) do |ut|
            ut[:wsse].Username request_header.username
            ut[:wsse].Password({
                                 "Type" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText"
                               }, encode_password(request_header.password, request_header.nonce, request_header.created))
            ut[:wsse].Nonce({
                              "EncodingType" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary"
                            }, encode_nonce(request_header.nonce))
            ut[:wsu].Created request_header.created
          end
        end
      end
    end

    def encode_soap_body(xml, request)
      xml[:soap].Body do |header|
        header << request.raw_body
      end
    end

    def encode_soap_envelope(request)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml[:soap].Envelope({ "xmlns:soap" => "http://www.w3.org/2003/05/soap-envelope" }) do |envelope|
          encode_soap_header(envelope, request)
          encode_soap_body(envelope, request)
        end
      end
      Success(builder.to_xml)
    end

    def encode_nonce(nonce)
      Base64.strict_encode64(nonce)
    end

    def encode_password(password, nonce, created_at)
      Digest::SHA1.base64digest(nonce + created_at + password)
    end
  end
end