# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'
require 'faraday'
require 'faraday_middleware'

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
        if MedicaidGatewayRegistry[:transfer_service].item == "aces"
          MedicaidGatewayRegistry[:aces_connection].setting(:aces_mec_check_uri).item
        else
          MedicaidGatewayRegistry[:curam_connection].setting(:curam_mec_check_uri).item
        end
      end
      return Failure("Failed to find setting: :aces_connection, :aces_mec_check_uri") if result.failure?
      result.value!.nil? ? Failure(":aces_mec_check_uri cannot be nil") : result
    end

    def submit_request(service_uri, payload)
      # Validate the service_uri
      return Failure("MEC Check - Invalid URI: #{service_uri}") unless valid_uri?(service_uri)

      clean_payload = payload.to_s.gsub("<?xml version=\"1.0\"?>", "").gsub("<?xml version=\"1.0\"??>", "")
      connection = get_faraday_connection(service_uri)
      # Send the POST request with retries
      result = Try do
        connection.post service_uri do |req|
          req.headers['Content-Type'] = 'application/soap+xml;charset=UTF-8'
          req.body = clean_payload
        end
      end
      result.or(Failure("MEC check submit request failed with: #{result.exception}"))
    end

    def valid_uri?(uri)
      URI.parse(uri).is_a?(URI::HTTP)
    rescue StandardError
      false
    end

    def get_faraday_connection(service_uri)
      # Define the number of retries and interval between retries
      max_retries = 3
      retry_interval = 2 # in seconds

      Faraday.new(url: service_uri) do |faraday|
        faraday.request :retry, max: max_retries, interval: retry_interval do |_, response|
          # Retry only if the response status code is not in the 2xx range
          response.status >= 300 || response.status < 200
        end
        faraday.headers["Content-Type"] = "application/soap+xml;charset=UTF-8"
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
