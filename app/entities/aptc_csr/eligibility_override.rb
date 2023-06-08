# frozen_string_literal: true

module AptcCsr
  # An entity to represent a EligibilityOverride
  class EligibilityOverride < Dry::Struct

    attribute :override_rule, Types::EligibilityOverrideRule
    attribute :override_applied, Types::Bool

  end
end
