# frozen_string_literal: true

module Aces
  # MecCheck to see if person is in Medicaid System
  class MecCheck
    include Mongoid::Document
    include Mongoid::Timestamps

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

    index({ created_at: -1, updated_at: -1 })
    index({ created_at: 1 })
    index({ application_identifier: 1 })

    def successful?
      self.failure.nil?
    end

    def to_event
      {
        type: "MEC Check",
        created_at: self.created_at,
        success: self.successful?,
        app_id: self.application_identifier
      }
    end

  end
end
