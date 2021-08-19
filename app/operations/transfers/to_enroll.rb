# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Transfers
  # Transfers an account from the Medicaid service into EA
  class ToEnroll
    send(:include, Dry::Monads[:result, :do])

    # @param [String] Take in the raw payload and serialize and transform it, then tranfer the result to EA.
    # @return [Dry::Result]
    def call(params)
      payload = yield create_transfer(params)
      transformed_params = yield transform_params(payload)
      initiate_transfer(transformed_params)
    end

    private

    def create_transfer(input)
      puts "creating transfer"
      record = ::AcaEntities::Serializers::Xml::Medicaid::Atp::AccountTransferRequest.parse(input)
      result = record.is_a?(Array) ? record.first : record
      Success(result)
    end

    def transform_params(result)
      puts "transforming"
      transformed = ::AcaEntities::Atp::Transformers::Cv::Family.transform(result.to_hash(identifier: true))
      Success(transformed)
    end

    def initiate_transfer(payload)
      puts "transferring"
      transfer = Transfers::InitiateTransferToEnroll.new.call(payload)
      transfer.success? ? Success("Transferred account to Enroll") : Failure(transfer)
    end
  end
end