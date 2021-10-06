# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Transfers
  # Adds Enroll response to transfer
  class AddEnrollResponse
    send(:include, Dry::Monads[:result, :do, :try])

    # Takes the params, finds the inbound transfer and updates with response details from enroll
    def call(params)
      transfer = yield get_transfer(params)
      update_transfer(params, transfer)
    end

    private

    def get_transfer(params)
      puts params
      transfer_id = params["transfer_id"]
      transfer = Aces::InboundTransfer.find_by(external_id: transfer_id)
      transfer ? Success(transfer) : Failure("Failed to find transfer for application: #{transfer_id}")
    end

    def update_transfer(params, transfer)
      result = Try do
        transfer.update!(params.except("transfer_id"))
      end
      result.success? ? Success(transfer) : Failure("Failed to update transfer")
    end

  end
end