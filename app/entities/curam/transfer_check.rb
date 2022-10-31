# frozen_string_literal: true

module Curam
  # Encapsulates an account transfer request header and payload, sent
  # sent specifically to the ACES system.
  # This wraps both SOAP authorization and the body, which is a CMS ATP request.
  class TransferCheck < Dry::Struct
    transform_keys(&:to_sym)

    attribute :header, Types.Nominal(::Curam::Atp::SoapAuthorizationHeader)

    # This exists currently for the purpose of connectivity testing - it is an
    # opaque XML payload.  It will become a full-fledged aca_entities object
    # once the aca_entities AccountTransferRequest object is complete and
    # serializable as XML.
    attribute :global_application_id, Types::String
    attribute :last_written, Types::Date
  end
end
