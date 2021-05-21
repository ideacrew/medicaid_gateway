# frozen_string_literal: true

module AptcCsr
  # An entity to represent a AptcHouseholdMember
  class AptcCalculationMember < Dry::Struct

    attribute :member_identifier, Types::String
    attribute :relationship_kind_to_primary, Types::String
    # attribute :age_of_applicant, Types::Integer
    attribute :member_premium, Types::Money

  end
end
