# frozen_string_literal: true

module Aces
  # Transfers from an outside source coming into Enroll
  class InboundTransfersController < ActionController::Base
    def show
      @transfer = Aces::InboundTransfer.find(params[:id])
      @failure_status = @transfer.failure.nil?
      render layout: "application"
    end
  end
end
