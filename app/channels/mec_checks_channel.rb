# frozen_string_literal: true

# class for managing the Events Stimulus Reflex web socket channel
class MecChecksChannel < ApplicationCable::Channel
  def subscribed
    stream_from "mec_checks"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
