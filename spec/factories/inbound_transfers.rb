# frozen_string_literal: true

FactoryBot.define do
  factory :inbound_transfer, class: "::Aces::InboundTransfer" do
    payload { "<xml></xml>" }

    trait :to_enroll do
      to_enroll { true }
    end
  end
end
