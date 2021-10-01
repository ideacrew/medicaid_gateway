# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Aces
  # Submits the MecCheck Request
  class SubmitMecCheckPayload
    send(:include, Dry::Monads[:result, :do, :try])

    # @param [String] payload
    # @return [Dry::Result]
    def call(payload)
      endpoint_uri = yield read_endpoint_setting
      submit_request(endpoint_uri, payload)
    end

    protected

    def read_endpoint_setting
      result = Try do
        MedicaidGatewayRegistry[:aces_connection].setting(:aces_mec_check_uri).item
      end
      return Failure("Failed to find setting: :aces_connection, :aces_mec_check_uri") if result.failure?
      result.nil? ? Failure(":aces_mec_check_uri cannot be nil") : result
    end

    def submit_request(service_uri, payload)
      clean_payload = payload.to_s.gsub("<?xml version=\"1.0\"?>", "").gsub("<?xml version=\"1.0\"??>", "")
      result = Try do
        Faraday.post(
          service_uri,
          clean_payload,
          "Content-Type" => "application/soap+xml;charset=UTF-8"
        )
      end
      result.or(Failure("ACES transfer submit_request failed with: #{result.exception}"))
    end
  end
end