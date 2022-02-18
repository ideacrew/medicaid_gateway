# frozen_string_literal: true

require 'types'

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

    # Submission date and time of the Incoming Application
    # field :submitted_at, type: DateTime

    embeds_many :aptc_households, class_name: '::Medicaid::AptcHousehold'
    accepts_nested_attributes_for :aptc_households

    index({ created_at: 1, updated_at: 1 })
    index({ updated_at: 1 })

    after_save :check_submitted_at

    def successful?
      return true unless application_response_payload.blank?
    end

    def error_message
      return unless medicaid_response_payload
      json = medicaid_response_payload.to_json
      json["Error"]
    end

    def application_response_payload_json
      return {} if application_response_payload.nil?
      # return unless application_response_payload
      JSON.parse(application_response_payload, symbolize_names: true)
    rescue JSON::ParserError => _e
      {}
    end

    def assistance_year
      return unless application_request_payload
      params = JSON.parse(application_request_payload, symbolize_names: true)
      params[:assistance_year]
    end

    def fpl
      return unless assistance_year
      fpl_year = assistance_year - 1
      fpl_data = ::Types::FederalPovertyLevels.detect do |fpl_hash|
        fpl_hash[:medicaid_year] == fpl_year
      end
      { medicaid_year: assistance_year,
        annual_poverty_guideline: fpl_data[:annual_poverty_guideline],
        annual_per_person_amount: fpl_data[:annual_per_person_amount] }
    end

    def benchmarks
      return unless application_response_payload_json
      # applicants = application_response_payload_json[:applicants]
      # return unless applicants
      applicants.map { |a| a[:benchmark_premium][:health_only_slcsp_premiums] }.flatten
    end

    def primary_applicant
      application_response_payload_json[:applicants]&.detect {|applicant| applicant[:is_primary_applicant]}
    end

    def primary_hbx_id
      primary_applicant[:person_hbx_id]
    end

    def submitted_at
      submitted_at = application_response_payload_json[:submitted_at]
      DateTime.parse(submitted_at) unless submitted_at.nil?
    end

    def applicants
      application_response_payload_json[:applicants] || []
    end

    def non_magi_medicaid_eligible?(member_identifier)
      tax_households = application_response_payload_json[:tax_households]
      tax_households.each do |household|
        members = household[:tax_household_members]
        members.each do |member|
          if member_identifier.to_s == member[:applicant_reference][:person_hbx_id]&.to_s
            return member[:product_eligibility_determination][:is_non_magi_medicaid_eligible]
          end
        end
      end
      "#{member_identifier} not found"
    end

    def attestation(member_identifier)
      applicants.each do |applicant|
        return applicant[:attestation] if member_identifier.to_s == applicant[:person_hbx_id]&.to_s
      end
      [:is_self_attested_blind, :is_self_attested_disabled].collect { |item| [item, "#{member_identifier} not found"] }.to_h
    end

    def daily_living_help?(member_identifier)
      applicants.each do |applicant|
        return applicant[:has_daily_living_help] if member_identifier.to_s == applicant[:person_hbx_id]&.to_s
      end
      "#{member_identifier} not found"
    end

    def full_medicaid_determination
      application_response_payload_json[:full_medicaid_determination]
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

    def check_submitted_at
      return unless submitted_at.nil? && application_response_payload_json

      submitted_at_string = application_response_payload_json[:submitted_at]
      parsed_submitted_at = DateTime.parse(submitted_at_string) if submitted_at_string
      self.update(submitted_at: parsed_submitted_at) if parsed_submitted_at
    end
  end
end
