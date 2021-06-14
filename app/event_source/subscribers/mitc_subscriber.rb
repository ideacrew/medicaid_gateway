# frozen_string_literal: true

module EventSource
  module Subscribers
    # Subscriber will receive response payload from mitc and perform validation along with persisting the payload
    class MitcSubscriber
      include ::EventSource::Subscriber[http: '/determinations/eval']

      # From medicaid_gateway request is published to mitc from call_magi_in_the_cloud operation
      # Response from mitc is received in this subscriber
      # headers: Hash contains correlation id
      # response Hash[determination_hash] contains determination from mitc
      #
      # @return [success/failure message]
      subscribe(:on_determinations_eval) do |headers, response|
        correlation_id = headers["CorrelationID"]
        persist(response, correlation_id)
      end

      def self.persist(response, correlation_id)
        params = { medicaid_application_id: correlation_id, medicaid_response_payload: response }
        result = Eligibilities::DetermineFullEligibility.new.call(params.deep_symbolize_keys!)

        message = if result.success?
                    result.success
                  else
                    result.failure
                  end
        # TODO: log message
        puts "determination_request_subscriber_message: #{message.is_a?(Hash) ? message[:event] : message}"
      rescue StandardError => e
        # TODO: log error message
        puts "determination_request_subscriber_error: #{e.backtrace}"
      end
    end
  end
end
