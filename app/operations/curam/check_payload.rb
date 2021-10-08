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
      built_check   = yield build_check_request(find_transfer(id))
      encoded_check = yield encode_check(built_check)
      submitted     = yield submit_check(encoded_check)
      save_check(submitted, find_transfer(id))
    end

    protected

    def find_transfer(transfer_id)
      transfer = Aces::Transfer.find(transfer_id)
      transfer || Failure(:no_transfers_found)
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

    def save_check(check, transfer)
      response = JSON.parse(check.to_json)
      xml = Nokogiri::XML(response["body"])
      status = xml.xpath('//tns:STATUS', 'tns' => 'http://xmlns.dhs.dc.gov/dcas/esb/acctransappstatuccheck/V1')
      status_text = status.any? ? status.last.text : "N/A"
      transfer.update_attribute(:callback_payload, check.to_json)
      transfer.update_attribute(:callback_status, status_text)
      Success("Callback response added")
    end
  end
end