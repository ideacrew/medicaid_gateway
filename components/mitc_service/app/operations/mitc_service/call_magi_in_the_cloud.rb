# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module MitcService
  # This class takes MitcRequestPayload as input and returns MitcResponsePayload
  # This class is PRIVATE and cannot be called from outside except from operation:
  # ::MitcService::DetermineMitcEligibility
  # This class includes Networking
  class CallMagiInTheCloud
    include Dry::Monads[:result, :do]

    # @param [Hash] opts
    # @option opts [Hash] :mitc_request_payload
    # @return [Dry::Monads::Result]
    def call(mitc_request_payload)
      response_payload = yield call_magi_in_the_cloud(mitc_request_payload)

      Success(response_payload)
    end

    private

    def call_magi_in_the_cloud(mitc_request_payload)
      publish(mitc_request_payload)

      Success("Successfully sent request payload to mitc")
    rescue StandardError => _e
      # TODO: Log the error
      if mitc_request_payload[:Name].present?
        # Rails.logger.error { "MitCIntegrationError: for magi_medicaid_application with
        #   hbx_id: #{mitc_request_payload[:Name]} with mitc_request_payload: #{mitc_request_payload}, error: #{e.backtrace}" }
        Failure("Error getting a response from MitC for magi_medicaid_application with hbx_id: #{mitc_request_payload[:Name]}")
      else
        # Rails.logger.error { "MitCIntegrationError: for mitc_request_payload: #{mitc_request_payload}, error: #{e.backtrace}" }
        Failure('Error getting a response from MitC for input mitc_request_payload')
      end
    end

    def publish(mitc_request_payload)
      manager = EventSource::ConnectionManager.instance
      connection = manager.connections_for(:http).first
      channel = connection.channels[:'/determinations/eval']
      publish_operation = channel.publish_operations['/determinations/eval']
      publish_operation.call(mitc_request_payload.merge(CorrelationID: mitc_request_payload[:Name]))
    end
  end
end

# Pending Tasks:
#   1. Log all Failure moands for finding failure cases.
