# frozen_string_literal: true

module EventSource
  module Subscribers
    # Subscriber will receive response payload from mitc and perform validation along with persisting the payload
    class DeterminationRequestSubscriber
      include ::EventSource::Subscriber[http: '/determinations/eval']

      # # from: MagiMedicaidEngine of EA after Application's submission
      # # { event: magi_medicaid_application_submitted, payload: :magi_medicaid_application }
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
        puts message
      rescue StandardError => e
        # TODO: log error message
        puts e.inspect
      end
    end
  end
end
