# frozen_string_literal: true

module Aces
  # Transfer is a record of transfer out of EA to services via Medicaid Gateway for reporting purposes
  class Transfer
    include Mongoid::Document
    include Mongoid::Timestamps
    include CableReady::Broadcaster

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

    # Full payload to send to service
    field :outbound_payload, type: String

    # xml payload from CMS to send to service
    field :xml_payload, type: String

    field :from_cms, type: Boolean

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
        id: "transfer-row-#{self.id}",
        type: "Transfer Out",
        created_at: self.created_at,
        updated_at: self.updated_at,
        success: self.successful?,
        app_id: self.application_identifier
      }
    end

    after_create do
      event_row_morph
      row_morph
    end

    after_update do
      event_row_morph
      row_morph
    end

    def row_morph
      row_html = ApplicationController.render(
        partial: "reports/transfer_row",
        locals: { transfer: self }
      )

      cable_ready["transfers"].remove(
        selector: "#transfer-row-#{id}",
        html: row_html
      )

      cable_ready["transfers"].prepend(
        selector: '#transfers-sent-table-body',
        html: row_html
      )

      cable_ready.broadcast
    end

    def event_row_morph
      event_html = ApplicationController.render(
        partial: "reports/event_row",
        locals: { event: self.to_event }
      )

      cable_ready["events"].remove(
        selector: "#event-transfer-row-#{id}",
        html: event_html
      )

      cable_ready["events"].prepend(
        selector: '#events-table-body',
        html: event_html
      )
      cable_ready.broadcast
    end
  end
end
