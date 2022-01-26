# frozen_string_literal: true

FactoryBot.define do
  factory :transfer, class: "::Aces::Transfer" do
    sequence(:application_identifier) { |n| "20000#{n}" }
    sequence(:family_identifier) { |n| "20000#{n}" }
    response_payload { "{\"Applicants\":[{\"Person ID\":99}]}" }
    outbound_payload { {} }
    service {"curam"}

    trait :with_outbound_payload do
      outbound_payload { File.read("spec/test_data/application_and_family.json") }
    end
  end
end
