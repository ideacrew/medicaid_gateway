# frozen_string_literal: true

module Curam
  module Atp
    # Represents a soap authorization header used to talk to Curam services.
    class SoapAuthorizationHeader < Dry::Struct
      transform_keys(&:to_sym)

      attribute :username, Types::String
      attribute :password, Types::String
      attribute :created, Types::String
    end
  end
end
