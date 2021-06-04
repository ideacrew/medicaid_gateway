# frozen_string_literal: true

module MagiMedicaid
  # Represents member that is used in the benchmark calculation.
  class BenchmarkCalculationMember
    include Mongoid::Document
    include Mongoid::Timestamps

    field :member_identifier, type: String
    field :relationship_kind_to_primary, type: String
    field :member_premium, type: Float

    embedded_in :aptc_household, class_name: '::MagiMedicaid::AptcHousehold'
  end
end
