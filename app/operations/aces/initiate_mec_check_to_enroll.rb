# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Aces
  # InitiateMecCheckToEnroll will publish MEC check events to enroll
  class InitiateMecCheckToEnroll
    include EventSource::Command
    include Dry::Monads[:result, :do]
    include EventSource::Logging

    # @option opts [Hash] :mec_check
    # @return [Dry::Monads::Result]
    def call(params)
      event = yield build_event(params)
      result = send_to_enroll(event)

      Success(result)
    end

    private

    def build_event(params)
      result = event("events.magi_medicaid.mec_check.mec_checked", attributes: params)
      logger.info "MedicaidGateway MEC Check Publisher to enroll, event_key: mec_checked, attributes: #{params.to_h}, result: #{result}"
      logger.info('-' * 100)
      result
    end

    def send_to_enroll(event)
      event.publish
    end
  end
end
