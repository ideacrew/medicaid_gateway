# frozen_string_literal: true

module Medicaid
  # Application is a one to one mapping to the Incoming Application(EA's FinancialAssistance::Application).
  # Object to store request payloads, response payloads, and
  # aptc households.
  class Application
    include Mongoid::Document
    include Mongoid::Timestamps

    # Unique Identifier(hbx_id) of the incoming application.
    # For example: EA's FinancialAssistance::Application's hbx_id
    field :application_identifier, type: String

    field :application_request_payload, type: String
    field :application_response_payload, type: String
    field :medicaid_request_payload, type: String
    field :medicaid_response_payload, type: String

    embeds_many :aptc_households, class_name: '::Medicaid::AptcHousehold'
    accepts_nested_attributes_for :aptc_households
  end
end
