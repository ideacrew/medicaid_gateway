# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Transfers
  # Adds Enroll response to transfer
  class AddEnrollResponse
    send(:include, Dry::Monads[:result, :do, :try])

    # Takes the params, finds the inbound transfer and updates with response details from enroll
    def call(params)
      valid_params = yield validate_params(params)
      transfers = yield get_transfers(valid_params)
      update_transfer(params, transfers)
    end

    private

    def validate_params(params)
      invalid_keys = params.keys.filter {|key| key.class != Symbol}
      invalid_keys.empty? ? Success(params) : Failure("Param keys must be symbols. Found non-symbol keys: #{invalid_keys}")
    end

    def get_transfers(params)
      transfer_id = params[:transfer_id]
      transfer = Aces::InboundTransfer.where(external_id: transfer_id)
      transfer&.any? ? Success(transfer) : Failure("Failed to find inbound transfer record for: #{transfer_id}")
    end

    def update_transfer(params, transfers)
      result = Try do
        transfers.each do |transfer|
          transfer.update!(params.except(:transfer_id))
        end
      end
      result.success? ? Success(transfers) : Failure("Failed to update transfer")
    end

  end
end