# frozen_string_literal: true

module Aces
  # Transfer is a record of transfer requests into EA for reporting purposes
  class InboundTransfer
    include Mongoid::Document
    include Mongoid::Timestamps
    include CableReady::Broadcaster

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

    field :failure, type: String

    field :to_enroll, type: Boolean

    def successful?
      self.failure.nil?
    end

    def to_event
      {
        type: "Transfer In",
        created_at: self.created_at,
        success: self.successful?,
        app_id: self.application_identifier
      }
    end

    def resubmittable?
      payload.present? && ['Sent', 'Failed'].include?(result)
    end

    after_update do
      row_morph
      # show_morph
    end

    def update_morph
      show_morph
    end

    def row_morph
      row_html = ApplicationController.render(
        partial: "reports/inbound_transfer_row",
        locals: { transfer: self }
      )

      cable_ready["inbound_transfers"].morph(
        selector: "#inbound-transfer-row-#{id}",
        html: row_html
      )

      cable_ready.broadcast
    end

    def show_morph
      show_html = ApplicationController.render(
        partial: "reports/inbound_transfer",
        locals: { report: self }
      )

      cable_ready["inbound_transfers"].morph(
        selector: "#inbound-transfer-#{id}",
        html: show_html
      )

      cable_ready.broadcast
    end

    # after_create do
    #   create_morph
    # end

    # def create_morph
    #   row_html = ApplicationController.render(
    #     partial: "events/row",
    #     locals: { event: self }
    #   )

    #   cable_ready['events'].prepend(
    #     selector: 'table tbody',
    #     html: row_html
    #   )

    #   cable_ready.broadcast
    # end
  end
end
