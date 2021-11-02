# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'
require 'aca_entities/serializers/xml/medicaid/atp'
require 'aca_entities/atp/transformers/cv/family'

module Transfers
  # Transfer an account from ACES to enroll
  class ToEnroll
    send(:include, Dry::Monads[:result, :do, :try])

    # @param [String] Take in the raw payload and serialize and transform it, then tranfer the result to EA.
    # @return [Dry::Result]
    def call(params, transfer_id)
      payload = yield create_transfer(params)
      transformed_params = yield transform_params(payload, transfer_id)
      initiate_transfer(transformed_params)
    end

    private

    def create_transfer(input)
      record = ::AcaEntities::Serializers::Xml::Medicaid::Atp::AccountTransferRequest.parse(input)
      result = record.is_a?(Array) ? record.first : record
      Success(result)
    rescue StandardError => e
      Failure("serializer error #{e}")
    end

    def transform_params(result, transfer_id)
      transformed = ::AcaEntities::Atp::Transformers::Cv::Family.transform(result.to_hash(identifier: true))
      uniq_id = "#{transfer_id}_#{transformed[:family][:magi_medicaid_applications][0][:transfer_id]}"
      update_transfer(transfer_id, uniq_id)
      transformed[:family][:magi_medicaid_applications][0][:transfer_id] = uniq_id
      Success(transformed)
    rescue StandardError => e
      Failure("to_aces transformer #{e}")
    end

    def update_transfer(transfer_id, external_id)
      transfer = Aces::InboundTransfer.find(transfer_id)
      transfer.update!(external_id: external_id)
    end

    def initiate_transfer(payload)
      transfer = Transfers::InitiateTransferToEnroll.new.call(payload)
      transfer.success? ? Success("Transferred account to Enroll") : Failure(transfer)
    end
  end
end