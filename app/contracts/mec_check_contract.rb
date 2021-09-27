# frozen_string_literal: true

# Schema and validation rules
class MecCheckContract < Dry::Validation::Contract
  # @!method call(opts)
  # @param [Hash] opts the parameters to validate using this contract
  # @return [Dry::Monads::Result]
  params do
    required(:application_identifier).filled(:string)
    required(:family_identifier).filled(:string)
    required(:applicant_responses).filled(:hash)
    required(:type).filled(:string)
  end
end
