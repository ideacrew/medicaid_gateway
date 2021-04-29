# frozen_string_literal: true

module Aces
  # Controller for testing message publishing to ACES using the ATP protocol.
  class PublishingConnectivityTestsController < ApplicationController
    def new
    end

    def create
      payload = params.require("payload")
      @result = Aces::PublishRawPayload.new.call(payload)
      render "created"
    end
  end
end