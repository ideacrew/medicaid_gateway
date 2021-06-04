# frozen_string_literal: true

FactoryBot.define do
  factory :application, class: "::MagiMedicaid::Application" do
    sequence(:application_identifier) { |n| "10000#{n}" }
    application_request_payload { "{\"us_state\":\"DC\",\"hbx_id\":\"200000123\"}" }
    application_response_payload { "{\"us_state\":\"DC\",\"hbx_id\":\"200000123\"}" }
    medicaid_request_payload { "{\"Applicants\":[{\"Person ID\":95}]}" }
    medicaid_response_payload { "{\"Applicants\":[{\"Person ID\":95}]}" }

    trait :with_aptc_households do
      aptc_households do
        [FactoryBot.build(:aptc_household)]
      end
    end
  end
end
