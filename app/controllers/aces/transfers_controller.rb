# frozen_string_literal: true

module Aces
  # Transfers from Enroll to outside agency
  class TransfersController < ApplicationController
    def show
      @transfer = Aces::Transfer.find(params[:id])
      @failure_status = @transfer.failure.nil?
      @response_payload = parse_json(@transfer.response_payload)
      @callback_payload = parse_json(@transfer.callback_payload)
      @outbound_payload = parse_json(@transfer.outbound_payload)
      render layout: "application"
    end

    private

    def parse_json(value)
      return value unless value.present?
      JSON.parse(value)
    rescue JSON::ParserError
      value
    end
  end
end
