# frozen_string_literal: true

module Aces
  # Encapsulates an account transfer request header and payload, sent
  # sent specifically to the ACES system.
  # This wraps both SOAP authorization and the body, which is a CMS ATP request.
  class AccountTransferRequest < Dry::Struct
    transform_keys(&:to_sym)

    attribute :header, Types.Nominal(::Aces::SoapAuthorizationHeader)
  end
end
