# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Transfers
  # PublishDetermination will publish determination events to enroll and polypress
  class InitiateTransferToEnroll
    include EventSource::Command
    include Dry::Monads[:result, :do]
    include EventSource::Logging

    # @option opts [Hash] :fully_determined_medicaid_application
    # @option opts [String] :determined_aptc_eligible
    # @return [Dry::Monads::Result]
    def call(params, event_name)
      event = yield build_event(params, event_name)
      result = send_to_enroll(event)

      Success(result)
    end

    private

    def build_event(payload)
      event('magi_medicaid.atp.enroll.transfer_in', attributes: payload)
    end

    def send_to_enroll(event)
      event.publish
    end
  end
end
