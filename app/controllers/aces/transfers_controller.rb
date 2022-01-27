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

    def new
    end

    def create
      payload = params.dig(:transfer, :outbound_payload)
      parsed = valid_json(payload) ? payload : JSON.generate(instance_eval(payload))
      result = ::Transfers::ToService.new.call(parsed)

      if result.success?
        flash[:notice] = 'Successfully sent payload'
        redirect_to account_transfers_reports_path
      else
        error = result.failure[:failure]
        outbound_transfer = Aces::Transfer.find(result.failure[:transfer_id])
        outbound_transfer.update!(failure: error)
        flash[:alert] = "Error: #{error}"
        redirect_to new_aces_transfer_path
      end
    rescue StandardError => e
      flash[:alert] = "Exception raised: #{e}"
      redirect_to new_aces_transfer_path
    end

    private

    def valid_json(value)
      return false unless value.present?
      JSON.parse(value)
      true
    rescue JSON::ParserError
      false
    end

    def parse_json(value)
      return value unless value.present?
      JSON.parse(value)
    rescue JSON::ParserError
      value
    end
  end
end