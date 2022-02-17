# frozen_string_literal: true

# factory for users
FactoryBot.define do
  factory :hbx_staff_role do
    permission_id { FactoryBot.create(:permission).id }

    trait :no_permissions do
      permission_id { FactoryBot.create(:permission, :no_permissions).id }
    end

    trait :super_admin do
      permission_id { FactoryBot.create(:permission, :super_admin).id }
    end
  end
end
