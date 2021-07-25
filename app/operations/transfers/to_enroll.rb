# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Transfers
  class ToEnroll
    send(:include, Dry::Monads[:result, :do])

    # @param [String] raw_payload
    # @return [Dry::Result]
    def call(params)
      serialized_params = yield serialize_data(params)
      cv3_params = yield transform_params(serialized_params)
      # validated_params = yield validate_params(cv3_params)
      Success(initiate_transfer(cv3_params))
    end

    private

    def serialize_data(input_xml)
      record = ::AcaEntities::Serializers::Xml::Medicaid::Atp::AccountTransferRequest.parse(input_xml)
      Success(record.to_hash(identifier: true))
    end

    def transform_params(input)
      ::AcaEntities::Atp::Transformers::Cv::Family.transform(input)
    end

    def initiate_transfer(payload)
      Transfers::InitiateTransferToEnroll.new.call(payload)

      Success("Initiated account transfer to Enroll")
    end
  end
end