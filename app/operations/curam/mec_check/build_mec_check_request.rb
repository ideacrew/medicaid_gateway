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
        created = yield generate_created
        request = yield build_request(username, password, timestamp, nonce, created, payload)
        Success(request)
      end

      protected

      # rubocop:disable Metrics/ParameterLists
      def build_request(
        username,
        password,
        timestamp,
        nonce,
        created,
        payload
      )
        request = Curam::MecCheck::MecCheckRequest.new({
                                                         header: Curam::MecCheck::SoapAuthorizationHeader.new({
                                                                                                                username: username,
                                                                                                                password: password,
                                                                                                                timestamp: timestamp,
                                                                                                                nonce: nonce,
                                                                                                                created: created
                                                                                                              }),
                                                         raw_body: payload
                                                       })
        Success(request)
      rescue Dry::Struct::Error => e
        Failure({ error: "Failed to create MecCheckRequest: #{e}" })
      end
      # rubocop:enable Metrics/ParameterLists

      def read_username_setting
        result = Try do
          MedicaidGatewayRegistry[:curam_connection].setting(:curam_mec_check_username).item
        end
        return Failure("Failed to find setting: :curam_connection, :curam_mec_check_username") if result.failure?
        result.nil? ? Failure(":curam_mec_check_username cannot be nil") : result
      end

      def read_password_setting
        result = Try do
          MedicaidGatewayRegistry[:curam_connection].setting(:curam_mec_check_password).item
        end
        return Failure("Failed to find setting: :curam_connection, :curam_mec_check_password") if result.failure?
        result.nil? ? Failure(":curam_mec_check_password cannot be nil") : result
      end

      def generate_timestamp
        curr_time = Time.now.utc
        created = curr_time.strftime("%Y-%m-%dT%H:%M:%S.%L%Z")
        expires = (curr_time + 1.minute).strftime("%Y-%m-%dT%H:%M:%S.%L%Z")
        Success({ created: created, expires: expires })
      end

      def generate_nonce
        Success(SecureRandom.random_bytes(16))
      end

      def generate_created
        Success(Time.now.utc.strftime("%Y-%m-%dT%H:%M:%S.%L%Z"))
      end
    end
  end
end