# frozen_string_literal: true

module Curam
  # Represents a timestamp in soap authorization header used to talk to Curam services.
  class Timestamp < Dry::Struct
    transform_keys(&:to_sym)

    attribute :created, Types::String
    attribute :expires, Types::String
  end
end
