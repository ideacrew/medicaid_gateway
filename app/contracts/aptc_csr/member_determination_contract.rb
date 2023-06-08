# frozen_string_literal: true

require 'types'

module AptcCsr
  # Schema and validation rules for {AptcCsr::MemberDeterminationContract}
  class MemberDeterminationContract < Dry::Validation::Contract
    # @!method call(opts)
    # @param [Hash] opts the parameters to validate using this contract
    # @return [Dry::Monads::Result]
    params do
      required(:kind).filled(Types::MemberDeterminationKind)
      required(:criteria_met).filled(:bool)
      required(:determination_reasons).array(::Types::Symbol)
      required(:eligibility_overrides).array(AptcCsr::EligibilityOverrideContract.params)
    end
  end
end
