# frozen_string_literal: true

module AptcCsr
  # An entity to represent a MemberDetermination
  class MemberDetermination < Dry::Struct

    attribute :kind, Types::MemberDeterminationKind
    attribute :criteria_met, Types::Bool
    attribute :determination_reasons, Types::Array.of(Types::Symbol)
    attribute :eligibility_overrides, Types::Array.of(AptcCsr::EligibilityOverride)

  end
end
