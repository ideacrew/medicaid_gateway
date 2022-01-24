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
      result = ::Transfers::ToService.new.call(JSON.generate(instance_eval(params[:transfer][:outbound_payload])))

      if result.success?
        flash[:success] = 'Successfully send payload'
        redirect_to account_transfers_reports_path
      else
        error = result.failure[:failure]
        outbound_transfer = Aces::Transfer.find(result.failure[:transfer_id])
        outbound_transfer.update!(failure: error)
        flash[:error] = "Error: #{error}"
        redirect_to new_aces_transfer_path
      end
    rescue StandardError => e
      flash[:error] = "Exception raised: #{e}"
      redirect_to new_aces_transfer_path
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
