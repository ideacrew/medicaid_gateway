# frozen_string_literal: true

module Aces
  # MecCheck to see if person is in Medicaid System
  class MecCheck
    include Mongoid::Document
    include Mongoid::Timestamps
    include CableReady::Broadcaster

    # Unique Identifier(application_id) of the application.
    # For example: EA's FinancialAssistance::Application's application_id
    field :application_identifier, type: String

    # Unique Identifier(hbx_id) of the family.
    # For example: EA's FinancialAssistance::Family's hbx_id
    field :family_identifier, type: String

    # Server response from the service
    field :applicant_responses, type: Hash

    # Payload type of person or application
    field :type, type: String

    # Record of failure point in the MEC check process
    field :failure, type: String

    def successful?
      self.failure.nil?
    end

    def to_event
      {
        id: "check-row-#{self.id}",
        type: "MEC Check",
        created_at: self.created_at,
        updated_at: self.updated_at,
        success: self.successful?,
        app_id: self.application_identifier
      }
    end

    after_update do
      row_morph
    end

    def row_morph
      row_html = ApplicationController.render(
        partial: "reports/mec_check_row",
        locals: { check: self }
      )

      cable_ready["mec_checks"].remove(
        selector: "#mec-check-row-#{id}",
        html: row_html
      )

      cable_ready["mec_checks"].prepend(
        selector: 'table tbody',
        html: row_html
      )

      cable_ready.broadcast
    end
  end
end
