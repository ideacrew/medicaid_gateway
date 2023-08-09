# frozen_string_literal: true

module Transmittable
  # Transmittable Transactions controller
  class TransactionsController < ApplicationController

    def show
      @transaction = Transmittable::Transaction.where(id: params[:id]).last

      render json: "Transaction not found", status: 404 unless @transaction
    end

    def index
      @transactions = Transmittable::Transaction.newest.page params[:page]
    end

  end
end