# frozen_string_literal: true

# class for managing the Events Stimulus Reflex web socket channel
class InboundTransfersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "inbound_transfers"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
