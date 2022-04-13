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
    }
  ].freeze

  # Use ResourceRegistry to configure below
  AffordabilityThresholds = [
    { 2020 => BigDecimal('9.83') },
    { 2021 => BigDecimal('9.83') },
    { 2022 => BigDecimal('9.83') },
    { 2023 => BigDecimal('9.83') }
  ].freeze

  CsrKind = Types::Coercible::String.enum('0',
                                          '73',
                                          '87',
                                          '94',
                                          '100',
                                          'limited')
  ELIGIBLE_INSURANCE_KINDS = %w[
    medicaid
    child_health_insurance_plan
    medicare
    medicare_advantage
    tricare
    retiree_health_benefits
    veterans_administration_health_benefits
    peace_corps_health_benefits
  ].freeze

  ENROLLED_INSURANCE_KINDS = ['medicaid', 'child_health_insurance_plan', 'medicare', 'medicare_advantage', 'tricare',
                              'employer_sponsored_insurance', 'health_reimbursement_arrangement', 'cobra',
                              'retiree_health_benefits', 'veterans_administration_health_benefits', 'peace_corps_health_benefits'].freeze

  if MedicaidGatewayRegistry.feature_enabled?(:additional_ineligible_types)
    ELIGIBLE_INSURANCE_KINDS += [
      'acf_refugee_medical_assistance',
      'americorps_health_benefits',
      'state_supplementary_payment',
      'veterans_benefits',
      'naf_health_benefit_program',
      'self_funded_student_health_coverage',
      'foreign_government_health_coverage',
      'coverage_under_the_state_health_benefits_risk_pool',
      'parents_domestic_partner',
      'health_care_for_peace_corp_volunteers',
      'department_of_defense_non_appropriated_health_benefits'
    ]

    ENROLLED_INSURANCE_KINDS += [
      'acf_refugee_medical_assistance',
      'americorps_health_benefits',
      'state_supplementary_payment',
      'veterans_benefits',
      'naf_health_benefit_program',
      'self_funded_student_health_coverage',
      'foreign_government_health_coverage',
      'coverage_under_the_state_health_benefits_risk_pool',
      'parents_domestic_partner',
      'health_care_for_peace_corp_volunteers',
      'department_of_defense_non_appropriated_health_benefits',
      'employer_sponsored_insurance', 'health_reimbursement_arrangement'
    ]
  end
end
