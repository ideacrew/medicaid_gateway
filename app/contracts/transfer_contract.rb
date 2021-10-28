# frozen_string_literal: true

# Schema and validation rules
class TransferContract < Dry::Validation::Contract
  # @!method call(opts)
  # @param [Hash] opts the parameters to validate using this contract
  # @return [Dry::Monads::Result]
  params do
    required(:application_identifier).filled(:string)
    required(:family_identifier).filled(:string)
    required(:service).filled(:string)
    optional(:response_payload).filled(:string)
    optional(:callback_payload).filled(:string)
    optional(:callback_status).filled(:string)
    optional(:failure).filled(:string)
    optional(:outbound_payload).filled(:string)
  end

  rule(:response_payload) do
    key.failure(text: 'should be a valid JSON string') if key? && !valid_json?(value)
  end

  rule(:callback_payload) do
    key.failure(text: 'should be a valid JSON string') if key? && !valid_json?(value)
  end

  rule(:outbound_payload) do
    key.failure(text: 'should be a valid JSON string') if key? && !valid_json?(value)
  end

  def valid_json?(json_input)
    JSON.parse(json_input)
  rescue JSON::ParserError => _e
    false
  end
end
