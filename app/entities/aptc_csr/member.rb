# frozen_string_literal: true

module AptcCsr
  # An entity to represent a AptcHouseholdMember
  class Member < Dry::Struct

    attribute :member_identifier, Types::String
    attribute :household_count, Types::Integer
    attribute :annual_household_income_contribution, Types::Money.optional.meta(omittable: true)
    attribute :tax_filer_status, Types::TaxFilerKind
    attribute :is_applicant, Types::Bool
    attribute :benchmark_plan_monthly_premium_amount, Types::Money.optional.meta(omittable: true)
    attribute :age_of_applicant, Types::Integer

    attribute :aptc_eligible, Types::Bool.optional.meta(omittable: true)
    attribute :is_gap_filling, Types::Bool.optional.meta(omittable: true)
    attribute :totally_ineligible, Types::Bool.optional.meta(omittable: true)
    attribute :uqhp_eligible, Types::Bool.optional.meta(omittable: true)
    attribute :magi_medicaid_eligible, Types::Bool.optional.meta(omittable: true)
    attribute :csr_eligible, Types::Bool.optional.meta(omittable: true)

    attribute :csr, Types::CsrKind.optional.meta(omittable: true)

    attribute :member_determinations, Types::Array.of(MemberDetermination).optional.meta(omittable: true)
  end
end
