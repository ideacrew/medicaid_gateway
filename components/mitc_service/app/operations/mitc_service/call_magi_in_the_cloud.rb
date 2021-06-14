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
    include EventSource::Command

    # @param [Hash] opts
    # @option opts [Hash] :mitc_request_payload
    # @return [Dry::Monads::Result]
    def call(mitc_request_payload)
      event = yield build_event(mitc_request_payload)
      response_payload = yield call_magi_in_the_cloud(event, mitc_request_payload)

      Success(response_payload)
    end

    private

    def build_event(payload)
      event("events.determinations.eval", attributes: payload.merge(CorrelationID: payload[:Name]))
    end

    def call_magi_in_the_cloud(event, mitc_request_payload)
      event.publish

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
  end
end

# Pending Tasks:
#   1. Log all Failure moands for finding failure cases.
