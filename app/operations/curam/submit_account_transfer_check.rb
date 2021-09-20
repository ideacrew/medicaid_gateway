# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Curam
  # Requests the status of a transfer from Curam.
  class SubmitAccountTransferCheck
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
        MedicaidGatewayRegistry[:curam_connection].setting(:curam_check_service_uri).item
      end
      result.or(Failure("Failed to find setting: :curam_connection, :curam_check_service_uri"))
    end

    def submit_request(service_uri, payload)
      conn = Faraday.new(ssl: { verify: false })
      clean_payload = payload.to_s.gsub("<?xml version=\"1.0\"?>", "").gsub("<?xml version=\"1.0\"??>", "")
      result = Try do
        conn.post(
          service_uri,
          clean_payload,
          "Content-Type" => "text/xml"
        )
      end
      result.or(Failure(result.exception))
    end
  end
end