# frozen_string_literal: true

module Soap
  # Validates a soap security header given as a UsernameToken element.
  class ValidateUsernametokenSecurityHeader
    send(:include, Dry::Monads[:result, :do, :try])

    XML_NS = {
      "wsse" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd",
      "wsu" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd",
      "soap" => "http://www.w3.org/2003/05/soap-envelope"
    }.freeze

    # @param [Nokogiri::Document] document the SOAP envelope
    # @return [Dry::Result]
    def call(document)
      security_parameters = yield extract_security_parameters(document)
      username = yield read_username_configuration
      password = yield read_password_configuration
      validate_security_parameters(security_parameters, username, password)
    end

    protected

    def extract_security_parameters(document)
      read_values = Try do
        username_token_element = document.at_xpath(
          "//soap:Header/wsse:Security/wsse:UsernameToken",
          XML_NS
        )
        username = username_token_element.at_xpath("./wsse:Username", XML_NS).text
        digested_password = username_token_element.at_xpath("./wsse:Password", XML_NS).text
        b64_nonce = username_token_element.at_xpath("./wsse:Nonce", XML_NS).text
        created = username_token_element.at_xpath("./wsu:Created", XML_NS).text
        binary_nonce = Base64.decode64(b64_nonce)
        {
          username: username,
          created: created,
          binary_nonce: binary_nonce,
          digested_password: digested_password
        }
      end
      read_values.or(Failure(:security_header_unreadable))
    end

    def read_username_configuration
      result = Try do
        MedicaidGatewayRegistry[:aces_connection].setting(:aces_atp_caller_username).item
      end
      result.or(Failure("Failed to find setting: :aces_connection, :aces_atp_caller_username"))
    end

    def read_password_configuration
      result = Try do
        MedicaidGatewayRegistry[:aces_connection].setting(:aces_atp_caller_password).item
      end
      result.or(Failure("Failed to find setting: :aces_connection, :aces_atp_caller_password"))
    end

    def validate_security_parameters(
      security_parameters,
      username,
      password
    )
      return Failure(:unknown_user) if username != security_parameters[:username].strip
      sha_value = Digest::SHA1.base64digest(
        security_parameters[:binary_nonce] +
        security_parameters[:created] +
        password
      )
      (sha_value == security_parameters[:digested_password]) ? Success(:ok) : Failure(:invalid_password)
    end
  end
end