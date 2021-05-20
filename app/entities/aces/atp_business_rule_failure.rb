# frozen_string_literal: true

module Aces
  # Represents the outcome of failing business rule validation.
  class AtpBusinessRuleFailure < Dry::Struct
    transform_keys(&:to_sym)

    attribute :failed_assertions, Types::Array.of(AtpFailedBusinessAssertion)
  end
end