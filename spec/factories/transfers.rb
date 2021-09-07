# frozen_string_literal: true

FactoryBot.define do
  factory :transfer, class: "::Aces::Transfer" do
    sequence(:application_identifier) { |n| "20000#{n}" }
    sequence(:family_identifier) { |n| "20000#{n}" }
    response_payload { "{\"Applicants\":[{\"Person ID\":99}]}" }
    service {"curam"}
  end
end
