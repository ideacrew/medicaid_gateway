# frozen_string_literal: true

require 'dry-types'

module MitcService
  # Extend DryTypes
  module Types
    include Dry.Types
    include Dry::Logic

    MitcToMagiMedicaidMedicaidCategoryMap = {
      'None' => 'none',
      'Residency' => 'residency',
      'Adult Group Category' => 'adult_group',
      'Parent Caretaker Category' => 'parent_caretaker',
      'Pregnancy Category' => 'pregnancy',
      'Child Category' => 'child',
      'Optional Targeted Low Income Child' => 'optional_targeted_low_income_child',
      'CHIP Targeted Low Income Child' => 'chip_targeted_low_income_child',
      'Unborn Child' => 'unborn_child',
      'Income Medicaid Eligible' => 'income_medicaid_eligible',
      'Income CHIP Eligible' => 'income_chip_eligible',
      'Medicaid CHIPRA 214' => 'medicaid_chipra_214',
      'CHIP CHIPRA 214' => 'chip_chipra_214',
      'Trafficking Victim' => 'trafficking_victim',
      'Seven Year Limit' => 'seven_year_limit',
      'Five Year Bar' => 'five_year_bar',
      'Title II Work Quarters Met' => 'title_ii_work_quarters_met',
      'Medicaid Citizen Or Immigrant' => 'medicaid_citizen_or_immigrant',
      'CHIP Citizen Or Immigrant' => 'chip_citizen_or_immigrant',
      'Former Foster Care Category' => 'former_foster_care_category',
      'Work Quarters Override Income' => 'work_quarters_override_income',
      'State Health Benefits CHIP' => 'state_health_benefits_chip',
      'CHIP Waiting Period Satisfied' => 'chip_waiting_period_satisfied',
      'Dependent Child Covered' => 'dependent_child_covered',
      'Medicaid Non-MAGI Referral' => 'medicaid_non_magi_referral',
      'Emergency Medicaid' => 'emergency_medicaid',
      'Refugee Medical Assistance' => 'refugee_medical_assistance',
      'APTC Referral' => 'aptc_referral'
    }.freeze

    MagiMedicaidToMitcMedicaidCategoryMap = MitcToMagiMedicaidMedicaidCategoryMap.invert.freeze
  end
end
