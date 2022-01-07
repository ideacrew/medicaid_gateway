# frozen_string_literal: true

# Verify ActionCable connection in lower envs (TestChannel does not exist in production)
class TestChannel < ApplicationCable::Channel
  def subscribed
    stream_from "test"
  end

  def receive(data)
    puts data["message"]
    ActionCable.server.broadcast("test", "ActionCable is connected")
  end
end