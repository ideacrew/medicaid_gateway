# frozen_string_literal: true

module Aces
  # Transfer is a record of transfer requests into EA for reporting purposes
  class InboundTransfer
    include Mongoid::Document
    include Mongoid::Timestamps
    include CableReady::Broadcaster

    # Unique Identifier. Derived from payload field:
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

    def from_cms_to_aces?
      return true unless to_enroll || payload.blank?
    end

    def from_cms_to_aces
      Transfers::FromCms.new.call(self.payload, self.id)
    end

    def self.from_cms
      where(to_enroll: false)
    end

    def successful?
      self.failure.nil?
    end

    def to_event
      {
        id: "inbound-transfer-row-#{self.id}",
        type: "Transfer In",
        created_at: self.updated_at,
        success: self.successful?,
        app_id: self.application_identifier
      }
    end

    def resubmit_to_enroll
      Transfers::ToEnroll.new.call(payload, id)
    end

    def resubmittable?
      payload.present? && payload.length > 100 && ['Sent to Enroll', 'Failed'].include?(result) && to_enroll
    end

    after_create do
      row_morph
    end

    after_update do
      row_morph
    end

    def row_morph
      row_html = ApplicationController.render(
        partial: "reports/inbound_transfer_row",
        locals: { transfer: self }
      )

      cable_ready["inbound_transfers"].remove(
        selector: "#inbound-transfer-row-#{id}",
        html: row_html
      )

      cable_ready["inbound_transfers"].prepend(
        selector: 'table tbody',
        html: row_html
      )

      cable_ready.broadcast("inbound_transfers")
    end
  end
end
