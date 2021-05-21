# frozen_string_literal: true

module AptcCsr
  # An entity to represent a AptcHouseholdMember
  class Member < Dry::Struct

    attribute :member_identifier, Types::String
    attribute :household_count, Types::Integer
    attribute :annual_household_income_contribution, Types::Money.optional.meta(omittable: true)
    attribute :tax_filer_status, Types::TaxFilerKind
    # attribute :medicaid_eligibility_category, Types::MedicaidEligibilityCategory
    # attribute :medicaid_fpl, Types::FplKind
    attribute :is_applicant, Types::Bool
    attribute :is_mec_eligible, Types::Bool.optional.meta(omittable: true)
    attribute :benchmark_plan_monthly_premium_amount, Types::Money.optional.meta(omittable: true)
    # attribute :expected_contribution, Types::Money.optional.meta(omittable: true)
    attribute :aptc_eligible, Types::Bool.optional.meta(omittable: true)
    attribute :medicaid_eligible, Types::Bool.optional.meta(omittable: true)
    attribute :csr_eligible, Types::Bool.optional.meta(omittable: true)
    attribute :csr, Types::CsrKind.optional.meta(omittable: true)
  end
end
