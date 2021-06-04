# frozen_string_literal: true

module Medicaid
  # AptcHousehold is a one to one mapping to the TaxHousehold.
  # A set of applicants, grouped according to IRS and ACA rules,
  # who are considered a single unit when determining eligibility for
  # Insurance Assistance and Medicaid
  class AptcHousehold
    include Mongoid::Document
    include Mongoid::Timestamps

    field :total_household_count, type: Integer
    field :annual_tax_household_income, type: Float
    field :is_aptc_calculated, type: Boolean
    field :maximum_aptc_amount, type: Float
    field :total_expected_contribution_amount, type: Float
    field :total_benchmark_plan_monthly_premium_amount, type: Float
    field :assistance_year, type: Integer
    field :fpl, type: Hash
    field :fpl_percent, type: Float
    field :eligibility_date, type: Date

    embeds_many :benchmark_calculation_members, class_name: '::Medicaid::BenchmarkCalculationMember'
    embeds_many :aptc_household_members, class_name: '::Medicaid::AptcHouseholdMember'
    accepts_nested_attributes_for :benchmark_calculation_members, :aptc_household_members

    embedded_in :application, class_name: '::Medicaid::Application'
  end
end
