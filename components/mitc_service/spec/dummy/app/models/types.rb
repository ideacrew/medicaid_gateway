# frozen_string_literal: true

require 'dry-types'

Dry::Types.load_extensions(:maybe)

# Extend Dry Types
module Types
  include Dry.Types
  include Dry::Logic

  Money = Types.Constructor(BigDecimal) { |val| BigDecimal(val.to_s) }

  TaxFilerKind = Types::Coercible::String.enum('tax_filer',
                                               'single',
                                               'joint',
                                               'separate',
                                               'dependent',
                                               'non_filer')

  FplKind = Types::Coercible::Integer.enum(324, 221, 215)

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
    },
    {
      medicaid_year: 2022,
      annual_poverty_guideline: BigDecimal(13_590.to_s),
      annual_per_person_amount: BigDecimal(4_720.to_s)
    },
    {
      medicaid_year: 2023,
      annual_poverty_guideline: BigDecimal(13_590.to_s),
      annual_per_person_amount: BigDecimal(4_720.to_s)
    },
    # adding 2024 values as placeholders to placate specs. These values are not verified.
    {
      medicaid_year: 2024,
      annual_poverty_guideline: BigDecimal(13_590.to_s),
      annual_per_person_amount: BigDecimal(4_720.to_s)
    }
  ].freeze

  # Use ResourceRegistry to configure these values
  IncomeThresholds = [
    {
      2020 => {
        earned_income: BigDecimal('12_400'),
        unearned_income: BigDecimal('1_100')
      }
    },
    {
      2021 => {
        earned_income: BigDecimal('12_400'),
        unearned_income: BigDecimal('1_100')
      }
    },
    {
      2022 => {
        earned_income: BigDecimal('12_400'),
        unearned_income: BigDecimal('1_100')
      }
    },
    {
      2023 => {
        earned_income: BigDecimal('12_400'),
        unearned_income: BigDecimal('1_100')
      }
    },
    {
      2024 => {
        earned_income: BigDecimal('12_950'),
        unearned_income: BigDecimal('1_150')
      }
    },
    {
      2025 => {
        earned_income: BigDecimal('13_850'),
        unearned_income: BigDecimal('1_250')
      }
    },
    # adding 2026 values as placeholders to placate specs. These values are not verified.
    {
      2026 => {
        earned_income: BigDecimal('13_850'),
        unearned_income: BigDecimal('1_250')
      }
    }
  ].freeze

  # Use ResourceRegistry to configure below
  AffordabilityThresholds = [
    { 2020 => BigDecimal('9.83') },
    { 2021 => BigDecimal('9.83') },
    { 2022 => BigDecimal('9.61') },
    { 2023 => BigDecimal('9.12') },
    { 2024 => BigDecimal('8.39') },
    { 2025 => BigDecimal('9.02') },
    # adding 2026 values as placeholders to placate specs. These values are not verified.
    { 2026 => BigDecimal('9.02') }
  ].freeze

  CsrKind = Types::Coercible::String.enum('0',
                                          '73',
                                          '87',
                                          '94',
                                          '100',
                                          'limited')
end
