# frozen_string_literal: true

FactoryBot.define do
  factory :benchmark_calculation_member, class: "::Medicaid::BenchmarkCalculationMember" do
    aptc_household

    sequence(:member_identifier) { |n| "20000#{n}" }
    relationship_kind_to_primary { 'self' }
    member_premium { 355.5 }
  end
end
