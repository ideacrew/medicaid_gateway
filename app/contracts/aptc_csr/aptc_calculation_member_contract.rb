# frozen_string_literal: true

module AptcCsr
  # Schema and validation rules for {AptcCsr::AptcCalculationMember}
  class AptcCalculationMemberContract < Dry::Validation::Contract
    # @!method call(opts)
    # @param [Hash] opts the parameters to validate using this contract
    # @option opts [Integer] :member_identifier required
    # @option opts [String] :relationship_kind_to_primary required
    # @option opts [Types::Money] :member_premium required
    # @return [Dry::Monads::Result]
    params do
      required(:member_identifier).filled(:integer)
      required(:relationship_kind_to_primary).filled(:string)
      required(:member_premium).filled(Types::Money)
    end
  end
end
