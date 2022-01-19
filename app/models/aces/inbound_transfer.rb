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

    field :applicants, type: Array

    field :failure, type: String

    field :to_enroll, type: Boolean

    index({ created_at: -1, updated_at: -1 })
    index({ created_at: 1 })
    index({ application_identifier: 1 })

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

    def waiting_to_transfer?
      result == "Waiting to Transfer"
    end

    def to_event
      {
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
      payload.present? && payload.length > 100 && ['Sent to Enroll', 'Failed', 'Waiting to Transfer'].include?(result) && to_enroll
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
