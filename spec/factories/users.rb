# frozen_string_literal: true

# factory for users
FactoryBot.define do
  factory :user do
    sequence(:email) {|n| "example#{n}@example.com"}
    password { "dfkjghfj!!123" }

    trait :with_hbx_staff_role do
      after(:build) do |user, _evaluator|
        user.hbx_staff_role = FactoryBot.build(:hbx_staff_role)
        user.save
      end
    end

    trait :with_super_admin do
      after(:build) do |user, _evaluator|
        user.hbx_staff_role = FactoryBot.build(:hbx_staff_role, :super_admin)
        user.save
      end
    end

    trait :staff_with_no_permissions do
      after(:build) do |user, _evaluator|
        user.hbx_staff_role = FactoryBot.build(:hbx_staff_role, :no_permissions)
        user.save
      end
    end
  end
end
