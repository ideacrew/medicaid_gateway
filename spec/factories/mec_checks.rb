# frozen_string_literal: true

FactoryBot.define do
  factory :mec_check, class: "::Aces::MecCheck" do
    sequence(:application_identifier) { |n| "20000#{n}" }
    sequence(:family_identifier) { |n| "20000#{n}" }
    failure { nil }
  end
end
