# frozen_string_literal: true

module Medicaid
  # Represents determnation details for a member
  class MemberDetermination
    include Mongoid::Document
    include Mongoid::Timestamps

    # The kind of determination.
    field :kind, type: String

    # Whether or not the member is eligible for the kind of determination.
    field :is_eligible, type: Boolean

    # the reasons the member qualifies for the determination.
    field :determination_reasons, type: Array

    embedded_in :aptc_household_member, class_name: '::Medicaid::AptcHouseholdMember'

  end
end
