# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

  # This class is for detemining the full eligibility for a MedicaidApplication
module Eligibilities
  class PublishDetermination
    include EventSource::Command
    include Dry::Monads[:result, :do]

    # @param [Hash] opts The options to determine eligibility
    # @option opts [Hash] :medicaid_application_id MedicaidApplication identifier
    # @option opts [Hash] :medicaid_response_payload
    # @return [Dry::Monads::Result]
    def call(params, event_name)
      event = yield build_event(params, event_name)
      result = send_to_enroll(event)

      Success(result)
    end

    private

    def build_event(params, event_name)
      event_key = "determined_#{event_name}"
      event("events.magi_medicaid.mitc.eligibilities.#{event_key}", attributes: params)
    end

    def send_to_enroll(event)
      event.publish
    end
  end
end
