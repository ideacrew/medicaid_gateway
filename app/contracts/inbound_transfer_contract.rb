# frozen_string_literal: true

# Schema and validation rules
class InboundTransferContract < Dry::Validation::Contract
  # @!method call(opts)
  # @param [Hash] opts the parameters to validate using this contract
  # @return [Dry::Monads::Result]
  params do
    optional(:application_identifier).filled(:string)
    optional(:family_identifier).filled(:string)
    optional(:payload).filled(:string)
    optional(:result).filled(:string)
    optional(:external_id).filled(:string)
    optional(:to_enroll).filled(:bool)
  end
end
