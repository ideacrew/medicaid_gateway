# frozen_string_literal: true

module Medicaid
  # Represents an eligibility override for a member
  class EligibilityOverride
    include Mongoid::Document
    include Mongoid::Timestamps

    # The override rule that was applied.
    field :override_rule, type: Symbol

    # Whether or not the override was applied.
    field :override_applied, type: Boolean

    embedded_in :member_determination, class_name: '::Medicaid::MemberDetermination'

    before_validation :symbolize_override_rule
    validates_inclusion_of :override_rule, in: Types::EligibilityOverrideRule.values

    def symbolize_override_rule
      return if override_rule.is_a?(Symbol)
      self.override_rule = override_rule&.to_sym
    end
  end
end
