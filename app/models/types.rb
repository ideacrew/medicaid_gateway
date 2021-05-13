# frozen_string_literal: true

require 'dry-types'

Dry::Types.load_extensions(:maybe)

# Extend Dry Types
module Types
  include Dry.Types
  include Dry::Logic

  MedicaidFederalPovertyLevels = [
    { 324 => [:child_under_19, :pregnant_women] },
    { 221 => [:child_aged_btw_19_and_20, :parents_and_caretaker_relatives] },
    { 215 => [:adults_without_children_aged_btw_21_and_64] }
  ].freeze

  FederalPovertyLevels = [
    {
      medicaid_year: 2013,
      annual_poverty_guideline: BigDecimal(11_490.to_s),
      annual_per_person_amount: BigDecimal(4_020.to_s)
    },
    {
      medicaid_year: 2014,
      annual_poverty_guideline: BigDecimal(11_670.to_s),
      annual_per_person_amount: BigDecimal(4_060.to_s)
    },
    {
      medicaid_year: 2015,
      annual_poverty_guideline: BigDecimal(11_770.to_s),
      annual_per_person_amount: BigDecimal(4_160.to_s)
    },
    {
      medicaid_year: 2016,
      annual_poverty_guideline: BigDecimal(11_880.to_s),
      annual_per_person_amount: BigDecimal(4_160.to_s)
    },
    {
      medicaid_year: 2017,
      annual_poverty_guideline: BigDecimal(12_060.to_s),
      annual_per_person_amount: BigDecimal(4_180.to_s)
    },
    {
      medicaid_year: 2018,
      annual_poverty_guideline: BigDecimal(12_140.to_s),
      annual_per_person_amount: BigDecimal(4_320.to_s)
    },
    {
      medicaid_year: 2019,
      annual_poverty_guideline: BigDecimal(12_490.to_s),
      annual_per_person_amount: BigDecimal(4_420.to_s)
    },
    {
      medicaid_year: 2020,
      annual_poverty_guideline: BigDecimal(12_760.to_s),
      annual_per_person_amount: BigDecimal(4_480.to_s)
    },
    {
      medicaid_year: 2021,
      annual_poverty_guideline: BigDecimal(12_880.to_s),
      annual_per_person_amount: BigDecimal(4_540.to_s)
    }
  ].freeze
end
