# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Transfers
  # Operation creates persitance application object with
  # service name, request_payload & application and family ids
  # params only.
  class Create
    include Dry::Monads[:result, :do]

    # @param [Hash] opts The options to create application object
    # @option opts [Hash] :params Medicaid Application params
    # @return [Dry::Monads::Result]
    def call(params)
      values = yield validate_params(params)
      application = yield persist(values)

      Success(application)
    end

    private

    def validate_params(params)
      result = TransferContract.new.call(params)
      if result.success?
        Success(result.to_h)
      else
        Failure(result)
      end
    end

    def persist(values)
      application = ::Aces::Transfer.new(values)
      if application.save
        Success(application)
      else
        Failure('Unable to persist transfer.')
      end
    end
  end
end
