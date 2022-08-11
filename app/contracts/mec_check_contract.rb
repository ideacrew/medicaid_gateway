# frozen_string_literal: true

# Schema and validation rules
class MecCheckContract < Dry::Validation::Contract
  # @!method call(opts)
  # @param [Hash] opts the parameters to validate using this contract
  # @return [Dry::Monads::Result]
  params do
    required(:application_identifier).filled(:string)
    required(:family_identifier).filled(:string)
    required(:type).filled(:string)
    optional(:request_payload).filled(:string)
    optional(:applicant_responses).maybe(:hash)
    optional(:failure).maybe(:string)
  end
end
