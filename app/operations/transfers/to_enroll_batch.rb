# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'
require 'aca_entities/serializers/xml/medicaid/atp'
require 'aca_entities/atp/transformers/cv/family'
module Transfers
  # Transfer an account from ACES to enroll
  class ToEnrollBatch
    send(:include, Dry::Monads[:result, :do, :try])
    # @param [String] Application ID from ACES
    # @return [Dry::Result]
    def call(transfer_id)
      transfers = yield get_transfers(transfer_id)
      payload = yield get_payload(transfers)
      transformed_params = yield transform_params(payload, transfers)
      initiate_transfer(transformed_params)
    end

    private

    def get_transfers(transfer_id)
      inbound_transfers = Aces::InboundTransfer.all.select{|t| t.external_id == transfer_id }
      Success(inbound_transfers)
    rescue StandardError => e
      Failure("get transfers error: #{e}")
    end

    def get_payload(inbound_transfers)
      payloads = inbound_transfers.map {|xfer| xfer.payload }
      return unless payloads
      transfers = []
      payloads.each do |payload|
        next if payload.nil?
        transfer = create_transfer(payload)
        transfers << (transfer.success? ? transfer.value!.to_hash(identifier: true) : transfer)
      end

      applicants = transfers.map{|t| t[:insurance_application][:insurance_applicants]}
      return Success(transfers.first) unless applicants
      applicants.each do |applicant|
        transfers.first[:insurance_application][:insurance_applicants][applicant.keys.first] = applicant[applicant.keys.first]
      end
      Success(transfers.first)
    rescue StandardError => e
      Failure("get_payload error: #{e}")
    end

    def create_transfer(input)
      record = ::AcaEntities::Serializers::Xml::Medicaid::Atp::AccountTransferRequest.parse(input)
      result = record.is_a?(Array) ? record.first : record
      Success(result)
    rescue StandardError => e
      Failure("serializer error #{e}")
    end

    def transform_params(result, transfers)
      transformed = ::AcaEntities::Atp::Transformers::Cv::Family.transform(result)
      
      uniq_id = "#{DateTime.now.strftime("%Y%m%d_%H%M%S")}_#{transformed[:family][:magi_medicaid_applications][0][:transfer_id]}"
      transfers.each do |transfer|
        transfer.update!(external_id: uniq_id)
      end
      transformed[:family][:magi_medicaid_applications][0][:transfer_id] = uniq_id
      
      Success(transformed)
    rescue StandardError => e
      Failure("transform_params error #{e}")
    end

    def initiate_transfer(payload)
      transfer = Transfers::InitiateTransferToEnroll.new.call(payload)
      transfer.success? ? Success("Transferred accounts to Enroll") : Failure(transfer)
    end
  end
end