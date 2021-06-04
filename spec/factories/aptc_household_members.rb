# frozen_string_literal: true

FactoryBot.define do
  factory :aptc_household_member, class: "::MagiMedicaid::AptcHouseholdMember" do
    aptc_household

    sequence(:member_identifier) { |n| "20000#{n}" }
    household_count { 1 }
    annual_household_income_contribution { 10_000.89 }
    tax_filer_status { 'tax_filer' }
    is_applicant { true }
    benchmark_plan_monthly_premium_amount { 355.5 }
    aptc_eligible { true }
    totally_ineligible { false }
    uqhp_eligible { false }
    csr_eligible { true }
    csr { '73' }
  end
end
