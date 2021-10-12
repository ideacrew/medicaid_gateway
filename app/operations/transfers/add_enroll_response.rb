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
      transfer_id = params["transfer_id"]
      transfer = Aces::InboundTransfer.where(external_id: transfer_id).last
      transfer ? Success(transfer) : Failure("Failed to find inbound transfer record for: #{transfer_id}")
    end

    def update_transfer(params, transfer)
      result = Try do
        params["payload"] = "" if params["result"] == "Success"
        transfer.update!(params.except("transfer_id"))
      end
      result.success? ? Success(transfer) : Failure("Failed to update transfer")
    end

  end
end