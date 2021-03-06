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
    def call(params)
      event = yield build_event(params)
      result = send_to_enroll(event)

      Success(result)
    end

    private

    def build_event(params)
      result = event("events.magi_medicaid.atp.enroll.transfer_in", attributes: params.to_h)
      logger.info "MedicaidGateway Transfer Publisher to enroll, event_key: transfer_in, attributes: #{params.to_h}, result: #{result}"
      logger.info('-' * 100)
      result
    end

    def send_to_enroll(event)
      event.publish
    end
  end
end
