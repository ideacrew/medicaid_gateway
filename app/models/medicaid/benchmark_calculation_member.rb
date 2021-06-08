# frozen_string_literal: true

module Medicaid
  # Represents member that is used in the benchmark calculation.
  class BenchmarkCalculationMember
    include Mongoid::Document
    include Mongoid::Timestamps

    # member_identifier is a unique identifier to identify a member
    field :member_identifier, type: String

    # Relationship Kind
    field :relationship_kind_to_primary, type: String

    # Premium amount that is used for this member for determining APTC/CSR
    field :member_premium, type: Float

    embedded_in :aptc_household, class_name: '::Medicaid::AptcHousehold'
  end
end
