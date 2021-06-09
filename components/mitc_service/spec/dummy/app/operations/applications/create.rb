# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Applications
  # Operation creates persitance application object with
  # application_identifier, application_request_payload & medicaid_request_payload
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
      result = ::AptcCsr::ApplicationContract.new.call(params)

      if result.success?
        Success(result.to_h)
      else
        Failure(result)
      end
    end

    def persist(values)
      application = ::Medicaid::Application.new(values)

      if application.save
        Success(application)
      else
        Failure('Unable to persist medicaid application object.')
      end
    end
  end
end
