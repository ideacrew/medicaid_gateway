# frozen_string_literal: true

module Medicaid
  # Represents member of an AptcHousehold.
  # One to one mapping to TaxHousholdMember
  class AptcHouseholdMember
    include Mongoid::Document
    include Mongoid::Timestamps

    field :member_identifier, type: String
    field :household_count, type: Integer
    field :annual_household_income_contribution, type: Float
    field :tax_filer_status, type: String
    field :is_applicant, type: Boolean
    field :benchmark_plan_monthly_premium_amount, type: Float
    field :aptc_eligible, type: Boolean
    field :totally_ineligible, type: Boolean
    field :uqhp_eligible, type: Boolean
    field :csr_eligible, type: Boolean
    field :csr, type: String

    embedded_in :aptc_household, class_name: '::Medicaid::AptcHousehold'
  end
end
