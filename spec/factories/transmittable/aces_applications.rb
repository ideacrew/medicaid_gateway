# frozen_string_literal: true

FactoryBot.define do
  factory :aces_application, class: "::Transmittable::AcesApplication" do
    application_id {"test_application_123"}
  end
end
