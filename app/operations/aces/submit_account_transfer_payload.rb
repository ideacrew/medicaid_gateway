# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Aces
  # Submits the pre-encoded account transfer payload, as a SOAP request,
  # to ACES.
  class SubmitAccountTransferPayload
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
        MedicaidGatewayRegistry[:aces_connection].setting(:aces_atp_service_uri).item
      end
      result.or(Failure("Failed to find setting: :aces_connection, :aces_atp_service_uri"))
    end

    def submit_request(service_uri, payload)
      result = Try do
        Faraday.post(
          service_uri,
          payload,
          "Content-Type" => "application/soap+xml"
        )
      end
      result.or(Failure(result.exception))
    end
  end
end