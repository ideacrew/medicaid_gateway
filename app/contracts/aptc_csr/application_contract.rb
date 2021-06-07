# frozen_string_literal: true

module AptcCsr
  # Schema and validation rules
  class ApplicationContract < Dry::Validation::Contract
    # @!method call(opts)
    # @param [Hash] opts the parameters to validate using this contract
    # @return [Dry::Monads::Result]
    params do
      required(:application_identifier).filled(:string)
      required(:application_request_payload).filled(:string)
      optional(:application_response_payload).filled(:string)
      required(:medicaid_request_payload).filled(:string)
      optional(:medicaid_response_payload).filled(:string)

      optional(:aptc_households).array(AptcHouseholdContract.params)
    end

    rule(:aptc_households).each do |index:|
      if key? && value
        if value.is_a?(Hash)
          result = AptcHouseholdContract.new.call(value)
          key([:aptc_households, index]).failure(text: 'invalid aptc_household', error: result.errors.to_h) if result&.failure?
        else
          key([:aptc_households, index]).failure(text: 'invalid aptc_households. Expected a hash.')
        end
      end
    end
  end
end
