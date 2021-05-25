# frozen_string_literal: true

module AptcCsr
  # Schema and validation rules for {AptcCsr::AptcCalculationMember}
  class AptcCalculationMemberContract < Dry::Validation::Contract
    # @!method call(opts)
    # @param [Hash] opts the parameters to validate using this contract
    # @option opts [String] :member_identifier required
    # @option opts [String] :relationship_kind_to_primary required
    # @option opts [Integer] :age_of_applicant required
    # @option opts [Types::Money] :member_premium required
    # @return [Dry::Monads::Result]
    params do
      required(:member_identifier).filled(:string)
      # self is also allowed as one of the types
      required(:relationship_kind_to_primary).filled(:string)
      # required(:age_of_applicant).filled(:integer)
      required(:member_premium).filled(Types::Money)
    end
  end
end
