# frozen_string_literal: true

module Aces
  # Transfer is a record of transfer out of EA to services via Medicaid Gateway for reporting purposes
  class Transfer
    include Mongoid::Document
    include Mongoid::Timestamps

    # Unique Identifier(hbx_id) of the application.
    # For example: EA's FinancialAssistance::Application's hbx_id
    field :application_identifier, type: String

    # Unique Identifier(hbx_id) of the primary family member
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

    # Full payload to send to service
    field :outbound_payload, type: String

    # xml payload from CMS to send to service
    field :xml_payload, type: String

    field :from_cms, type: Boolean

    index({ created_at: 1, updated_at: 1 })
    index({ updated_at: 1 })

    def successful?
      self.failure.nil?
    end

    def from_cms?
      self.xml_payload.present?
    end

    def resubmittable?
      self.callback_status != "Success" && outbound_payload.present?
    end

    def to_event
      {
        type: "Transfer Out",
        created_at: self.created_at,
        success: self.successful?,
        app_id: self.application_identifier
      }
    end

  end
end
