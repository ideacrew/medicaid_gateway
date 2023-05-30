# frozen_string_literal: true

require 'types'

module AptcCsr
  # Schema and validation rules for {AptcCsr::MemberDeterminationContract}
  class MemberDeterminationContract < Dry::Validation::Contract
    # @!method call(opts)
    # @param [Hash] opts the parameters to validate using this contract
    # @return [Dry::Monads::Result]
    params do
      optional(:kind).maybe(Types::MemberDeterminationKind)
      optional(:is_eligible).maybe(:bool)
      optional(:determination_reasons).array(::Types::Symbol)
    end
  end
end
