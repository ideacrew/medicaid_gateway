# frozen_string_literal: true

module Aces
  # Represents a soap authorization header used to talk to ACES services.
  class SoapAuthorizationHeader < Dry::Struct
    transform_keys(&:to_sym)

    attribute :username, Types::String
    attribute :password, Types::String
    attribute :nonce, Types::String
    attribute :created, Types::String
  end
end
