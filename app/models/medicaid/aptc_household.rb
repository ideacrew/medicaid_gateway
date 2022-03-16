# frozen_string_literal: true

module Medicaid
  # AptcHousehold is a one to one mapping to the TaxHousehold.
  # A set of applicants, grouped according to IRS and ACA rules,
  # who are considered a single unit when determining eligibility for
  # Insurance Assistance and Medicaid
  class AptcHousehold
    include Mongoid::Document
    include Mongoid::Timestamps

    # Computed total_household_count that is used for APTC/CSR determination
    field :total_household_count, type: Integer

    # Computed annual_tax_household_income that is used for APTC/CSR determination
    field :annual_tax_household_income, type: Float

    # Computed csr_annual_income_limit that is sent to the determination request system
    field :csr_annual_income_limit, type: Float

    # is_aptc_calculated tells us if APTC/CSR is calculated
    field :is_aptc_calculated, type: Boolean

    # maximum_aptc_amount is computed amount that the group is eligible for
    field :maximum_aptc_amount, type: Float

    # Computed total_expected_contribution_amount that is used for APTC/CSR determination
    field :total_expected_contribution_amount, type: Float

    # Computed total_benchmark_plan_monthly_premium_amount that is used for APTC/CSR determination
    field :total_benchmark_plan_monthly_premium_amount, type: Float

    # assistance_year is the year that is sent by the external system to which year the application applies to
    field :assistance_year, type: Integer

    # maps to ::AcaEntities::MagiMedicaid::FederalPovertyLevel
    field :fpl, type: Hash

    # Computed fpl_percent that is used for APTC/CSR determination
    field :fpl_percent, type: Float

    # eligibility_date is the date for which this determination is applicable for
    field :eligibility_date, type: Date

    embeds_many :benchmark_calculation_members, class_name: '::Medicaid::BenchmarkCalculationMember'
    embeds_many :aptc_household_members, class_name: '::Medicaid::AptcHouseholdMember'
    accepts_nested_attributes_for :benchmark_calculation_members, :aptc_household_members

    embedded_in :application, class_name: '::Medicaid::Application'

    def contribution_percent
      return 0 if annual_tax_household_income.to_i == 0 || !total_expected_contribution_amount
      (total_expected_contribution_amount / annual_tax_household_income) * 100
    end
  end
end
