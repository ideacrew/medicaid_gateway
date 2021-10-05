# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Aces
  # Create an account transfer request, including security information,
  # from an ACES payload.  Right now the payload is a string, it will
  # become a 'proper' aca_entities object once that is implemented.
  class BuildAccountTransferRequest
    send(:include, Dry::Monads[:result, :do, :try])

    # @param [String] payload
    # @return [Dry::Result<Aces::AccountTransferRequest>]
    def call(payload)
      username = yield read_username_setting
      password = yield read_password_setting
      nonce = yield generate_nonce
      created = yield generate_created
      Success(build_request(username, password, nonce, created, payload))
    end

    protected

    def build_request(
      username,
      password,
      nonce,
      created,
      payload
    )
      Aces::AccountTransferRequest.new({
                                         header: Aces::SoapAuthorizationHeader.new({
                                                                                     username: username,
                                                                                     password: password,
                                                                                     nonce: nonce,
                                                                                     created: created
                                                                                   }),
                                         raw_body: payload
                                       })
    end

    def read_username_setting
      result = Try do
        MedicaidGatewayRegistry[:aces_connection].setting(:aces_atp_service_username).item
      end
      return Failure("Failed to find setting: :aces_connection, :aces_atp_service_username") if result.failure?
      result.nil? ? Failure(":aces_atp_service_username cannot be nil") : result
    end

    def read_password_setting
      result = Try do
        MedicaidGatewayRegistry[:aces_connection].setting(:aces_atp_service_password).item
      end
      return Failure("Failed to find setting: :aces_connection, :aces_atp_service_password") if result.failure?
      result.nil? ? Failure(":aces_atp_service_password cannot be nil") : result
    end

    def generate_nonce
      Success(SecureRandom.random_bytes(16))
    end

    def generate_created
      Success(Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.%L%Z"))
    end
  end
end