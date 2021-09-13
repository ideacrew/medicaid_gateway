# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Curam
  # Encodes an AccountTransferRequest into a wire payload that Curam will
  # accept.  Currently this is encoded as a soap literal with a SOAP
  # security header.
  class EncodeAccountTransferCheckRequest
    send(:include, Dry::Monads[:result, :do])

    # @param [Aces::AccountTransferRequest] request
    # @return [Dry::Result<String>]
    def call(request)
      encode_soap_envelope(request)
    end

    protected

    def encode_soap_header(xml, request)
      request_header = request.header
      xml[:soapenv].Header({ "xmlns:soap" => "http://schemas.xmlsoap.org/soap/envelope/" }) do |header|
        header[:wsse].Security({
                                 "xmlns:wsse" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd",
                                 "soap:mustUnderstand" => "1"
                               }) do |security|
          security[:wsse].UsernameToken({
                                          "wsu:Id" => "UsernameToken-OPhPSeaF0paWJXf56Z6tpQ22",
                                          "xmlns:wsu" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd"
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

    def encode_soap_envelope(request)
      builder = Nokogiri::XML::Builder.new do |xml|
        xml[:soapenv].Envelope({
                                 "xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/",
                                 "xmlns:v1" => "http://xmlns.dhs.dc.gov/dcas/esb/acctransappstatuccheck/V1"
                               }) do |envelope|
          encode_soap_header(envelope, request)
          xml[:soapenv].Body do |body|
            xml[:v1].AccTransStatusByIdReq do |req|
              xml[:v1].GLOBALAPPLICATIONID request.global_application_id
              xml[:v1].LASTWRITTEN request.last_written
            end
          end
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