# frozen_string_literal: true

module AptcCsr
  # An entity to represent a BenchmarkCalculationMember
  class BenchmarkCalculationMember < Dry::Struct

    attribute :member_identifier, Types::String
    attribute :relationship_kind_to_primary, Types::String
    attribute :member_premium, Types::Money

  end
end
