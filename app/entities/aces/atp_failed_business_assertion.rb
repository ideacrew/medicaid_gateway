# frozen_string_literal: true

module Aces
  # Encapsulates a single failed assertion in ATP business logic.
  class AtpFailedBusinessAssertion < Dry::Struct
    transform_keys(&:to_sym)

    attribute :location, Types::String
    attribute :text, Types::String
  end
end