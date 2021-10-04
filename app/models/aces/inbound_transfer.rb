# frozen_string_literal: true

module Aces
  # Transfer is a record of transfer requests into EA for reporting purposes
  class InboundTransfer
    include Mongoid::Document
    include Mongoid::Timestamps

    # Unique Identifie. Derived from payload field:
    # AccountTransferRequest.InsuranceApplication.ApplicationIdentification.IdentificationID
    field :external_id, type: String

    # Result of the transfer: ie failed_vaildation
    field :result, type: String

    # Full payload for diagnosing purposes, only saved when issues
    field :payload, type: String

    # Unique Identifier(hbx_id) of the application.
    # For example: EA's FinancialAssistance::Application's hbx_id
    field :application_identifier, type: String

    # Unique Identifier(hbx_id) of the family.
    # For example: EA's FinancialAssistance::Family's hbx_id
    field :family_identifier, type: String

  end
end
