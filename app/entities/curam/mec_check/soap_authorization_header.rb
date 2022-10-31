# frozen_string_literal: true

module Curam
  module MecCheck
    # Represents a soap authorization header used to talk to Curam services.
    class SoapAuthorizationHeader < Dry::Struct
      transform_keys(&:to_sym)

      attribute :username, Types::String
      attribute :password, Types::String
      attribute :timestamp, Curam::Timestamp
      attribute :nonce, Types::String
    end
  end
end
