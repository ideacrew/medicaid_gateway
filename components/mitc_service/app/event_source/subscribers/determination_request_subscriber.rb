# frozen_string_literal: true

module EventSource
  module Subscribers
    class DeterminationRequestSubscriber
      include ::EventSource::Subscriber[http: '/determinations/eval']

      # # from: MagiMedicaidEngine of EA after Application's submission
      # # { event: magi_medicaid_application_submitted, payload: :magi_medicaid_application }
      subscribe(:on_determinations_eval) do |headers, response|

        #TODO requesst payload is not available
        # correlation_id = JSON.parse(response.env.request_body)["Name"]
        # mitc_response_payload = response.merge(correlation_id: correlation_id)

        #operation to persist
        Medicaid::Application.new(mitc_response_payload).call

      end
    end
  end
end
