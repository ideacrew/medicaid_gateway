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
      result.or(Failure("Failed to find setting: :curam_connection, :curam_atp_service_uri"))
    end

    def submit_request(service_uri, payload)
      conn = Faraday.new(ssl: {verify: false})
      result = Try do
        conn.post(
          service_uri,
          payload.gsub("<?xml version=\"1.0\"?>", "").gsub("<?xml version=\"1.0\"??>", ""),
          "Content-Type" => "text/xml"
        )
      end
      result.or(Failure(result.exception))
    end
  end
end