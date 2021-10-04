# frozen_string_literal: true

FactoryBot.define do
  factory :inbound_transfer, class: "::Aces::InboundTransfer" do
    payload { "<xml></xml>" }
  end
end
