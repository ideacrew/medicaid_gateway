# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Curam
  # Check if a submitted payload was sucessfully ingested by Curam
  class CheckPayload
    send(:include, Dry::Monads[:result, :do])

    # @param [String] hbxid of application
    # @return [Dry::Result]
    def call(id)
      built_check = yield build_check_request(find_transfer(id))
      encoded_check = yield encode_check(built_check)
      submit_check(encoded_check)
    end

    protected

    def find_transfer(application_id)
      transfers = Aces::Transfer.where(application_identifier: application_id)
      transfers.any? ? transfers.last : Failure(:no_transfers_found)
    end

    def build_check_request(transfer)
      Curam::BuildTransferCheck.new.call(transfer.application_identifier, transfer.created_at)
    end

    def encode_check(payload)
      Curam::EncodeAccountTransferCheckRequest.new.call(payload)
    end

    def submit_check(encoded_check)
      Curam::SubmitAccountTransferCheck.new.call(encoded_check)
    end
  end
end