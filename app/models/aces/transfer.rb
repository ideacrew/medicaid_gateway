# frozen_string_literal: true

module Aces
  # Transfer is a record of transfer out of EA to services via Medicaid Gateway for reporting purposes
  class Transfer
    include Mongoid::Document
    include Mongoid::Timestamps

    # Unique Identifier(hbx_id) of the application.
    # For example: EA's FinancialAssistance::Application's hbx_id
    field :application_identifier, type: String

    # Unique Identifier(hbx_id) of the family.
    # For example: EA's FinancialAssistance::Family's hbx_id
    field :family_identifier, type: String

    # Indication of the service the account was transferred to ex. curam or aces
    field :service, type: String

    # Server response from the service
    field :response_payload, type: String

    # Callback response from the service
    field :callback_payload, type: String

    # Callback response status from the service
    field :callback_status, type: String

    # Record of transfer failure
    field :failure, type: String
  end
end
