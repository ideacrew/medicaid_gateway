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

    # Input Application Request Payload that we get from external system for Determination in JSON format
    field :application_request_payload, type: String

    # Response Application Payload that we will send back to the external system with Full Determination in JSON format
    field :application_response_payload, type: String

    # Request application that we generate to send it to external system for Medicaid Determination in JSON format
    # For Example: In DC's case the external system is MitC
    field :medicaid_request_payload, type: String

    # Response application that we get back from external system which includes Medicaid Determination in JSON format
    # For Example: In DC's case the external system is MitC
    field :medicaid_response_payload, type: String

    embeds_many :aptc_households, class_name: '::Medicaid::AptcHousehold'
    accepts_nested_attributes_for :aptc_households

    index({ created_at: 1, updated_at: 1 })
    index({ updated_at: 1 })

    def successful?
      return true unless application_response_payload.blank?
    end

    def error_message
      return unless medicaid_response_payload
      json = medicaid_response_payload.to_json
      json["Error"]
    end

    def other_factors
      return 'No other factors' unless self.aptc_households.present?
      aptc_hh_keys = %w[total_household_count annual_tax_household_income csr_annual_income_limit
                        is_aptc_calculated maximum_aptc_amount total_expected_contribution_amount
                        total_benchmark_plan_monthly_premium_amount assistance_year fpl_percent eligibility_date
                        aptc_household_members benchmark_calculation_members]
      self.attributes['aptc_households'].inject([]) do |aptc_hh_array, aptc_hash|
        aptc_hh_array << aptc_hash.select { |k, _v| aptc_hh_keys.include?(k) }
      end
    end

    def to_event
      {
        type: "Determination",
        created_at: self.created_at,
        success: self.successful?,
        app_id: self.application_identifier
      }
    end

  end
end
