# frozen_string_literal: true

module Aces
  # Transfers from Enroll to outside agency
  class TransfersController < ActionController::Base
    def show
      @transfer = Aces::Transfer.find(params[:id])
      @failure_status = @transfer.failure.nil?
      render layout: "application"
    end
  end
end
