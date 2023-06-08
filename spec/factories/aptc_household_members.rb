# frozen_string_literal: true

FactoryBot.define do
  factory :aptc_household_member, class: "::Medicaid::AptcHouseholdMember" do

    sequence(:member_identifier) { |n| "30000#{n}" }
    household_count { 1 }
    annual_household_income_contribution { 10_000.89 }
    tax_filer_status { 'tax_filer' }
    is_applicant { true }
    age_of_applicant { 20 }
    benchmark_plan_monthly_premium_amount { 355.5 }
    aptc_eligible { true }
    totally_ineligible { false }
    uqhp_eligible { false }
    csr_eligible { true }
    csr { '73' }

    member_determinations do
      [{
        kind: 'Insurance Assistance Determination',
        criteria_met: true,
        determination_reasons: [:income_above_threshold],
        eligibility_overrides: []
      }]
    end

  end
end
