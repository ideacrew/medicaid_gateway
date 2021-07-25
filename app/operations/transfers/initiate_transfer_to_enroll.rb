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
<<<<<<< HEAD
    def call(params)
      event = yield build_event(params)
=======
    def call(params, event_name)
      event = yield build_event(params, event_name)
>>>>>>> cc3190e (account transfers)
      result = send_to_enroll(event)

      Success(result)
    end

    private

<<<<<<< HEAD
    def build_event(params)
      puts "building event!"
      result = event("events.magi_medicaid.atp.enroll.transfer_in", attributes: params.to_h)
      logger.info "MedicaidGateway Transfer Publisher to enroll, event_key: transfer_in, attributes: #{params.to_h}, result: #{result}"
      logger.info('-' * 100)
      result
    end

    def send_to_enroll(event)
      puts "sending event!"
=======
    def build_event(payload)
      event('magi_medicaid.atp.enroll.transfer_in', attributes: payload)
    end

    def send_to_enroll(event)
>>>>>>> cc3190e (account transfers)
      event.publish
    end
  end
end
