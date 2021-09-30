# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Aces
  # Operation creates persitance application object with
  # application identifier, family identifer and application results
  # params only.
  class CreateMecCheck
    include Dry::Monads[:result, :do]

    # @param [Hash] opts The options to create application object
    # @option opts [Hash] :params MEC Check params
    # @return [Dry::Monads::Result]
    def call(params)
      values = yield validate_params(params)
      application = yield persist(values)

      Success(application)
    end

    private

    def validate_params(params)
      result = MecCheckContract.new.call(params)
      if result.success?
        Success(result.to_h)
      else
        Failure(result)
      end
    end

    def persist(values)
      application = ::Aces::MecCheck.new(values)
      if application.save
        Success(application)
      else
        Failure('Unable to persist MEC Check.')
      end
    end
  end
end
