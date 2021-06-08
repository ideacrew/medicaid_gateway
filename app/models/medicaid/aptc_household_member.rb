# frozen_string_literal: true

module Medicaid
  # Represents member of an AptcHousehold.
  # One to one mapping to TaxHousholdMember
  class AptcHouseholdMember
    include Mongoid::Document
    include Mongoid::Timestamps

    # member_identifier is a unique identifier to identify a member
    field :member_identifier, type: String

    # Computed household_count that is used for APTC/CSR determination
    # Currently, the value will be 1 for each member
    field :household_count, type: Integer

    # Computed annual_household_income_contribution by this member that is used for APTC/CSR determination
    field :annual_household_income_contribution, type: Float

    # Tax Filer status of the member
    field :tax_filer_status, type: String

    # Is this person applying?
    field :is_applicant, type: Boolean

    # Premium amount that is used for this member for determining APTC/CSR
    field :benchmark_plan_monthly_premium_amount, type: Float

    # Member Eligibility
    field :aptc_eligible, type: Boolean
    field :totally_ineligible, type: Boolean
    field :uqhp_eligible, type: Boolean
    field :csr_eligible, type: Boolean
    field :csr, type: String

    embedded_in :aptc_household, class_name: '::Medicaid::AptcHousehold'
  end
end
