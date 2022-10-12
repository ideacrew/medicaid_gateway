# frozen_string_literal: true

module AptcCsr
  # An entity to represent a AptcHousehold
  class AptcHousehold < Dry::Struct

    attribute :total_household_count, Types::Integer
    attribute :annual_tax_household_income, Types::Money
    attribute :csr_annual_income_limit, Types::Money.optional.meta(omittable: true)
    # attribute :are_all_members_medicaid_eligible, Types::Bool
    attribute :is_aptc_calculated, Types::Bool.optional.meta(omittable: true)
    attribute :maximum_aptc_amount, Types::Money.optional.meta(omittable: true)
    attribute :total_expected_contribution_amount, Types::Money.optional.meta(omittable: true)
    attribute :total_benchmark_plan_monthly_premium_amount, Types::Money.optional.meta(omittable: true)
    attribute :assistance_year, Types::Integer
    attribute :fpl, AcaEntities::MagiMedicaid::FederalPovertyLevel
    attribute :fpl_percent, Types::Money
    attribute :benchmark_calculation_members, Types::Array.of(BenchmarkCalculationMember).optional.meta(omittable: true)
    attribute :members, Types::Array.of(Member)
    attribute :tax_household_identifier, Types::String.optional.meta(omittable: true)

    attribute :eligibility_date, Types::Date
  end
end
