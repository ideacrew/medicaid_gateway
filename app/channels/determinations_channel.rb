# frozen_string_literal: true

# class for managing the Events Stimulus Reflex web socket channel
class DeterminationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "determinations"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
