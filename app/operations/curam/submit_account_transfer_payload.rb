# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Curam
  # Submits the pre-encoded account transfer payload, as a SOAP request,
  # to Curam.
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
        MedicaidGatewayRegistry[:curam_connection].setting(:curam_atp_service_uri).item
      end
      return Failure("Failed to find setting: :curam_connection, :curam_atp_service_uri") if result.failure?
      result.nil? ? Failure(":curam_atp_service_uri cannot be nil") : result
    end

    def submit_request(service_uri, payload)
      conn = Faraday.new(ssl: { verify: false })
      clean_payload = payload.to_s.gsub("<?xml version=\"1.0\"?>", "").gsub("<?xml version=\"1.0\"??>", "")
      result = Try do
        conn.post(
          service_uri,
          clean_payload,
          "Content-Type" => "application/soap+xml"
        )
      end
      result.or(Failure("Curam SubmitAccountTransferPayload submit_request failed with: #{result.exception}"))
    end
  end
end