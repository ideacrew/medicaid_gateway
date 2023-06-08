# frozen_string_literal: true

require 'types'

module AptcCsr
  # Schema and validation rules for {AptcCsr::EligibilityOverrideContract}
  class EligibilityOverrideContract < Dry::Validation::Contract
    # @!method call(opts)
    # @param [Hash] opts the parameters to validate using this contract
    # @return [Dry::Monads::Result]
    params do
      required(:override_rule).filled(Types::EligibilityOverrideRule)
      required(:override_applied).filled(:bool)
    end
  end
end
