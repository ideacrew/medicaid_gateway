# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Curam
  module MecCheck
    # Create a MEC check request, including security information.
    class BuildMecCheckRequest
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
                                          header: Curam::MecCheck::SoapAuthorizationHeader.new({
                                                                                        username: username,
                                                                                        password: password,
                                                                                        created: created
                                                                                      }),
                                          raw_body: payload
                                        })
      end

      def read_username_setting
        result = Try do
          MedicaidGatewayRegistry[:curam_connection].setting(:curam_atp_service_username).item
        end
        return Failure("Failed to find setting: :curam_connection, :curam_atp_service_username") if result.failure?
        result.nil? ? Failure(":curam_atp_service_username cannot be nil") : result
      end

      def read_password_setting
        result = Try do
          MedicaidGatewayRegistry[:curam_connection].setting(:curam_atp_service_password).item
        end
        return Failure("Failed to find setting: :curam_connection, :curam_atp_service_username") if result.failure?
        result.nil? ? Failure(":curam_atp_service_username cannot be nil") : result
      end

      def generate_created
        Success(Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.%L%Z"))
      end
    end
  end
end