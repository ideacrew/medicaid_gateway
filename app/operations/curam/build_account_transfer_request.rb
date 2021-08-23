# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Curam
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
      created = yield generate_created
      Success(build_request(username, password, created, payload))
    end

    protected

    def build_request(
      username,
      password,
      created,
      payload
    )
      Aces::AccountTransferRequest.new({
                                         header: Curam::SoapAuthorizationHeader.new({
                                                                                     username: username,
                                                                                     password: password,
                                                                                     created: created
                                                                                   }),
                                         raw_body: payload.value!
                                       })
    end

    def read_username_setting
      result = Try do
        MedicaidGatewayRegistry[:curam_connection].setting(:curam_atp_service_username).item
      end
      result.or(Failure("Failed to find setting: :curam_connection, :curam_atp_service_username"))
    end

    def read_password_setting
      result = Try do
        MedicaidGatewayRegistry[:curam_connection].setting(:curam_atp_service_password).item
      end
      result.or(Failure("Failed to find setting: :curam_connection, :curam_atp_service_password"))
    end

    def generate_created
      Success(Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.%L%Z"))
    end
  end
end