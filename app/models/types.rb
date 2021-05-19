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

  MedicaidFederalPovertyLevels = [
    { 324 => [:child_under_19, :pregnant_women] },
    { 221 => [:child_aged_btw_19_and_20, :parents_and_caretaker_relatives] },
    { 215 => [:adults_without_children_aged_btw_21_and_64] }
  ].freeze

  MedicaidCategoriesMap = {
    # adults_without_children_aged_btw_21_and_64
    'Adult Group Category' => :adult_group_category,
    # parents_and_caretaker_relatives
    'Parent Caretaker Category' => :parent_caretaker_category,
    # pregnant_women
    'Pregnancy Category' => :pregnancy_category,
    # child_under_19, child_aged_btw_19_and_20
    'Child Category' => :child_category,
    'Optional Targeted Low Income Child' => :optional_targeted_low_income_child,
    'Income Medicaid Eligible' => :income_medicaid_eligible
  }.freeze

  MedicaidEligibilityCategory = Types::Coercible::Symbol.enum(
    :adult_group_category,
    :parent_caretaker_category,
    :pregnancy_category,
    :child_category,
    :optional_targeted_low_income_child,
    :income_medicaid_eligible
  )

  FplKind = Types::Coercible::Integer.enum(324, 221, 215)

  MedicaidEligibilityCategoriesMap = {
    adult_group_category: {
      mitc_key: 'adult_group',
      medicaid_fpl_percentage: BigDecimal('215')
    },
    parent_caretaker_category: {
      mitc_key: 'parent_caretaker',
      medicaid_fpl_percentage: BigDecimal('221')
    },
    pregnancy_category: {
      mitc_key: 'pregnancy',
      medicaid_fpl_percentage: BigDecimal('324')
    },
    child_category: {
      mitc_key: 'child',
      medicaid_fpl_percentage: BigDecimal('324')
    },
    optional_targeted_low_income_child: {
      mitc_key: 'optional_targeted_low_income_child',
      medicaid_fpl_percentage: BigDecimal('221')
    },
    income_medicaid_eligible: {
      mitc_key: 'income_medicaid_eligible',
      medicaid_fpl_percentage: BigDecimal('324')
    }
  }.freeze

  MedicaidChipCategories = [
    'CHIP Targeted Low Income Child',
    'Income CHIP Eligible'
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
    }
  ].freeze
end
