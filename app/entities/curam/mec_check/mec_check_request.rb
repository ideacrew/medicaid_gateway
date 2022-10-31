# frozen_string_literal: true

module Curam
  module MecCheck
    # Encapsulates a MEC check request header and payload, sent
    # sent specifically to the CURAM system.
    # This wraps both SOAP authorization and the body, which is a Curam MEC request.
    class MecCheckRequest < Dry::Struct
      transform_keys(&:to_sym)

      attribute :header, Types.Nominal(::Curam::MecCheck::SoapAuthorizationHeader)
      attribute :raw_body, Types::String
    end
  end
end