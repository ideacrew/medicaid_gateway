# frozen_string_literal: true

module Aces
  # Transfers from an outside source coming into Enroll
  class InboundTransfersController < ApplicationController
    respond_to :html, :xml, :json

    def show
      @transfer = Aces::InboundTransfer.find(params[:id])
      @failure_status = @transfer.failure.nil?
      render layout: "application"
    end

    def new
      @transfer = InboundTransfer.new
    end

    def create
      @transfer = InboundTransfer.new(transfer_params)

      redirect_to new_aces_inbound_transfer unless @transfer.save
      result = Aces::ProcessAtpSoapRequest.new.call(@transfer.payload, @transfer.id)
      update_transfer(@transfer, result)
      redirect_to account_transfers_to_enroll_reports_path
    end

    private

    def transfer_params
      params.require(:inbound_transfer).permit(:result, :payload)
    end

    def update_transfer(transfer, request)
      result_text = if request.success?
                      "Waiting to Transfer"
                    else
                      "Failed"
                    end
      failure_text = request.failure? ? request.failure : transfer.failure
      transfer.update!(result: result_text, failure: failure_text)
    end

  end
end