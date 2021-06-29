# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  # PublishDetermination will publish determination events to enroll and polypress
  class PublishDetermination
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

    def build_event(params, event_name)
      event_key = "determined_#{event_name}"
      result = event("events.magi_medicaid.mitc.eligibilities.#{event_key}", attributes: params.to_h)
      logger.info "MedicaidGateway Reponse Publisher to enroll & polypress, event_key: #{event_key}, attributes: #{params.to_h}, result: #{result}"
      logger.info('-' * 100)
      result
    end

    def send_to_enroll(event)
      event.publish
    end
  end
end
