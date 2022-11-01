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
        timestamp = yield generate_timestamp
        nonce = yield generate_nonce
        Success(build_request(username, password, timestamp, nonce, payload))
      end

      protected

      def build_request(
        username,
        password,
        timestamp,
        nonce,
        payload
      )
        Curam::MecCheck::MecCheckRequest.new({
                                               header: Curam::MecCheck::SoapAuthorizationHeader.new({
                                                                                                      username: username,
                                                                                                      password: password,
                                                                                                      timestamp: timestamp,
                                                                                                      nonce: nonce
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

      def generate_timestamp
        curr_time = Time.now.utc
        created = curr_time.strftime("%Y-%m-%dT%H:%M:%S.%L%Z")
        expires = (curr_time + 5.minutes).strftime("%Y-%m-%dT%H:%M:%S.%L%Z")
        Success({ created: created, expires: expires })
      end

      def generate_nonce
        Success(SecureRandom.random_bytes(16))
      end
    end
  end
end