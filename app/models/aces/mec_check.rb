# frozen_string_literal: true

module Aces
  # MecCheck to see if person is in Medicaid System
  class MecCheck
    include Mongoid::Document
    include Mongoid::Timestamps

    # Unique Identifier(application_id) of the application.
    # For example: EA's FinancialAssistance::Application's hbx_id
    field :application_identifier, type: String

    # Unique Identifier(hbx_id) of the family.
    # For example: EA's FinancialAssistance::Family's hbx_id
    field :family_identifier, type: String

    # Server response from the service
    field :applicant_responses, type: Hash

    # Payload type of person or application
    field :type, type: String

  end
end
