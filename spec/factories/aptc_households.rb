# frozen_string_literal: true

FactoryBot.define do

  factory :aptc_household, class: "::Medicaid::AptcHousehold" do
    sequence(:_id) { |n| "20000#{n}" }
    total_household_count { 1 }
    annual_tax_household_income { 10_000.89 }
    is_aptc_calculated { true }
    maximum_aptc_amount { 345.78 }
    total_expected_contribution_amount { 5_000.34 }
    total_benchmark_plan_monthly_premium_amount { 355.5 }
    assistance_year { Date.today.year }

    fpl do
      { state_code: "DC",
        household_size: 1,
        medicaid_year: Date.today.year,
        annual_poverty_guideline: 12_760.0,
        annual_per_person_amount: 4480.0,
        monthly_poverty_guideline: 1100.0,
        monthly_per_person_amount: 370.0,
        aptc_effective_start_on: Date.new(Date.today.year, 11, 1),
        aptc_effective_end_on: Date.new(Date.today.year + 1, 10, 31) }
    end

    aptc_household_members do
      [FactoryBot.build(:aptc_household_member)]
    end

    tax_household_identifier { '192837465' }
    fpl_percent { 256.00 }
    eligibility_date { Date.today.next_month.beginning_of_month }

    trait :with_benchmark_calculation_members do
      benchmark_calculation_members do
        [FactoryBot.build(:benchmark_calculation_member)]
      end
    end
  end
end
