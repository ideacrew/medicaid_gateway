# frozen_string_literal: true

FactoryBot.define do
  factory :permission do
    name { 'hbx_staff' }
    can_view_transfer_summary { true }
    can_view_transfers_sent { true }
    can_view_transfers_received { true }
    can_view_determinations { true }
    can_view_mec_checks { true }
    can_pull_irs_consent { false }

    trait :super_admin do
      name { 'super_admin' }
      can_pull_irs_consent { true }
    end

    trait :no_permissions do
      can_view_transfer_summary { false }
      can_view_transfers_sent { false }
      can_view_transfers_received { false }
      can_view_determinations { false }
      can_view_mec_checks { false }
      can_pull_irs_consent { false }
    end
  end
end
