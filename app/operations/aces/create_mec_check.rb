# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Aces
  # Operation creates MEC check object with
  # application identifier, family identifer, applicant responses
  # and payload type params only.
  class CreateMecCheck
    include Dry::Monads[:result, :do]

    # @param [Hash] opts The options to create MEC check object
    # @option opts [Hash] :params MEC Check params
    # @return [Dry::Monads::Result]
    def call(params)
      values = yield validate_params(params)
      mec_check = yield persist(values)

      Success(mec_check)
    end

    private

    def validate_params(params)
      result = MecCheckContract.new.call(params)
      if result.success?
        Success(result.to_h)
      else
        Failure(result.errors.to_h)
      end
    end

    def persist(values)
      mec_check = ::Aces::MecCheck.new(values)
      if mec_check.save
        Success(mec_check)
      else
        Failure('Unable to persist MEC Check.')
      end
    end
  end
end
