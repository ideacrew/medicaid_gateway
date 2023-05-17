# frozen_string_literal: true

module AptcCsr
  # An entity to represent a MemberDetermination
  class MemberDetermination < Dry::Struct

    attribute :kind, Types::MemberDeterminationKind
    attribute :is_eligible, Types::Boolean
    attribute :determination_reasons, Types::Array.of(Types::Symbol).optional.meta(omittable: true)

  end
end
