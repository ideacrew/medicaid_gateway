# frozen_string_literal: true

RSpec.shared_context 'cms ME simple_scenarios test_case_c', :shared_context => :metadata do
  let(:current_date) { Date.today }
  let(:family_member_reference) do
    { family_member_hbx_id: '1000',
      first_name: 'Aisha',
      last_name: 'Curtis',
      person_hbx_id: '95',
      is_primary_family_member: true }
  end

  let(:attestation) do
    { is_self_attested_blind: false,
      is_self_attested_disabled: true,
      is_incarcerated: false }
  end

  let(:unemployment_income) do
    { kind: 'unemployment_income',
      amount: 288,
      frequency_kind: 'Weekly',
      start_on: Date.new(current_date.year) }
  end

  let(:pregnancy_information) do
    { is_pregnant: false,
      is_post_partum_period: false,
      expected_children_count: nil }
  end
  let(:address1) do
    { has_fixed_address: true,
      kind: 'home',
      address_1: '1234',
      address_3: 'person',
      city: 'test',
      county: '',
      county_name: '',
      state: 'DC',
      zip: '12345',
      country_name: 'USA',
      validation_status: 'ValidMatch',
      lives_outside_state_temporarily: false,
      start_on: Date.today.to_s,
      end_on: nil }
  end
  let(:mitc_income) do
    { amount: 14_976,
      taxable_interest: 0,
      tax_exempt_interest: 0,
      taxable_refunds: 0,
      alimony: 0,
      capital_gain_or_loss: 0,
      pensions_and_annuities_taxable_amount: 0,
      farm_income_or_loss: 0,
      unemployment_compensation: 0,
      other_income: 0,
      magi_deductions: 0,
      adjusted_gross_income: 0,
      deductible_part_of_self_employment_tax: 0,
      ira_deduction: 0,
      student_loan_interest_deduction: 0,
      tution_and_fees: 0,
      other_magi_eligible_income: 0 }
  end
  let(:aisha) do
    { name: { first_name: 'Aisha', last_name: 'Curtis' },
      identifying_information: { has_ssn: false },
      citizenship_immigration_status_information: { citizen_status: 'us_citizen', is_lawful_presence_self_attested: false },
      demographic: { gender: 'Female',
                     dob: Date.new(current_date.year - 33, current_date.month, current_date.day),
                     is_veteran_or_active_military: false },
      attestation: attestation,
      is_primary_applicant: true,
      is_applying_coverage: true,
      family_member_reference: family_member_reference,
      person_hbx_id: '95',
      is_required_to_file_taxes: true,
      tax_filer_kind: 'tax_filer',
      is_joint_tax_filing: true,
      is_claimed_as_tax_dependent: false,
      claimed_as_tax_dependent_by: nil,
      student: { is_student: false },
      foster_care: { is_former_foster_care: false },
      pregnancy_information: pregnancy_information,
      has_job_income: false,
      has_self_employment_income: false,
      has_unemployment_income: true,
      has_other_income: false,
      has_deductions: false,
      has_enrolled_health_coverage: false,
      has_eligible_health_coverage: false,
      is_medicare_eligible: false,
      is_self_attested_long_term_care: false,
      has_insurance: false,
      has_state_health_benefit: false,
      had_prior_insurance: false,
      hours_worked_per_week: 0,
      is_subject_to_five_year_bar: false,
      is_five_year_bar_met: false,
      is_trafficking_victim: false,
      is_refugee: false,
      incomes: [unemployment_income],
      addresses: [address1],
      is_temporarily_out_of_state: false,
      age_of_applicant: 33,
      is_claimed_as_dependent_by_non_applicant: false,
      benchmark_premium: { monthly_slcsp_premium: 496.02, monthly_lcsp_premium: 430.48 },
      is_homeless: false,
      mitc_relationships: [],
      mitc_income: mitc_income }
  end
  let(:applicant_reference) do
    { first_name: aisha[:name][:first_name],
      last_name: aisha[:name][:last_name],
      dob: aisha[:demographic][:dob],
      person_hbx_id: aisha[:person_hbx_id] }
  end

  let(:product_eligibility_determination) do
    { is_ia_eligible: false,
      is_medicaid_chip_eligible: false,
      is_non_magi_medicaid_eligible: false,
      is_totally_ineligible: false,
      is_without_assistance: false,
      is_magi_medicaid: false }
  end

  let(:tax_household_member) do
    { product_eligibility_determination: product_eligibility_determination,
      applicant_reference: applicant_reference }
  end

  let(:tax_hh) do
    { max_aptc: nil,
      csr: nil,
      hbx_id: '12345',
      is_insurance_assistance_eligible: nil,
      tax_household_members: [tax_household_member] }
  end

  let(:applicants) do
    [aisha]
  end

  let(:person_references) do
    applicants.collect { |appl| { person_id: appl[:family_member_reference][:person_hbx_id] } }
  end

  let(:mitc_households) do
    [{ household_id: '1',
       people: person_references }]
  end

  let(:mitc_tax_return) do
    { filers: person_references, dependents: [] }
  end

  let(:app_params) do
    { us_state: 'DC',
      oe_start_on: Date.new(Date.today.year, 11, 1),
      hbx_id: '200000123',
      family_reference: { hbx_id: '10011' },
      assistance_year: Date.today.year,
      aptc_effective_date: Date.today,
      relationships: [],
      applicants: applicants,
      tax_households: [tax_hh],
      mitc_households: mitc_households,
      mitc_tax_returns: [mitc_tax_return] }
  end

  let(:application_entity) do
    ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
  end

  let(:input_application) do
    application_entity.to_h
  end

  let(:mitc_response) do
    { :"Determination Date" => Date.today.to_s,
      :Applicants =>
        [
          { :"Person ID" => 95,
            :"Medicaid Household" => { :People => [95],
                                       :MAGI => 14_976,
                                       :"MAGI as Percentage of FPL" => 116,
                                       :Size => 1 },
            :"Medicaid Eligible" => "Y",
            :"CHIP Eligible" => "N",
            :"CHIP Ineligibility Reason" => ["Applicant did not meet the requirements for any CHIP category"],
            :Category => "Adult Group Category",
            :"Category Threshold" => 27_692,
            :"CHIP Category" => "None",
            :"CHIP Category Threshold" => 0,
            :Determinations =>
              { :Residency => { :Indicator => "Y" },
                :"Adult Group Category" => { :Indicator => "Y" },
                :"Parent Caretaker Category" => { :Indicator => "N",
                                                  :"Ineligibility Code" => 146,
                                                  :"Ineligibility Reason" => "No child met all criteria for parent caretaker category" },
                :"Pregnancy Category" => { :Indicator => "N",
                                           :"Ineligibility Code" => 124,
                                           :"Ineligibility Reason" => "Applicant not pregnant or within postpartum period" },
                :"Child Category" => { :Indicator => "N",
                                       :"Ineligibility Code" => 394,
                                       :"Ineligibility Reason" => "Applicant is over the age limit for the young adult threshold in the state" },
                :"Optional Targeted Low Income Child" => { :Indicator => "X" },
                :"CHIP Targeted Low Income Child" => { :Indicator => "X" },
                :"Unborn Child" => { :Indicator => "X" },
                :"Income Medicaid Eligible" => { :Indicator => "Y" },
                :"Income CHIP Eligible" => { :Indicator => "N",
                                             :"Ineligibility Code" => 401,
                                             :"Ineligibility Reason" => "Applicant did not meet the requirements for any eligibility category" },
                :"Medicaid CHIPRA 214" => { :Indicator => "X" },
                :"CHIP CHIPRA 214" => { :Indicator => "X" },
                :"Trafficking Victim" => { :Indicator => "X" },
                :"Seven Year Limit" => { :Indicator => "X" },
                :"Five Year Bar" => { :Indicator => "X" },
                :"Title II Work Quarters Met" => { :Indicator => "X" },
                :"Medicaid Citizen Or Immigrant" => { :Indicator => "Y" },
                :"CHIP Citizen Or Immigrant" => { :Indicator => "Y" },
                :"Former Foster Care Category" => { :Indicator => "N",
                                                    :"Ineligibility Code" => 400,
                                                    :"Ineligibility Reason" => "Applicant was not formerly in foster care" },
                :"Work Quarters Override Income" => { :Indicator => "N",
                                                      :"Ineligibility Code" => 340,
                                                      :"Ineligibility Reason" => "Income is greater than 100% FPL" },
                :"State Health Benefits CHIP" => { :Indicator => "X" },
                :"CHIP Waiting Period Satisfied" => { :Indicator => "X" },
                :"Dependent Child Covered" => { :Indicator => "X" },
                :"Medicaid Non-MAGI Referral" => { :Indicator => "Y" },
                :"Emergency Medicaid" => { :Indicator => "N",
                                           :"Ineligibility Code" => 109,
                                           :"Ineligibility Reason" => "Applicant does not meet the eligibility criteria for emergency Medicaid" },
                :"Refugee Medical Assistance" => { :Indicator => "X" },
                :"APTC Referral" => { :Indicator => "N",
                                      :"Ineligibility Code" => 406,
                                      :"Ineligibility Reason" => "Applicant is eligible for Medicaid" } },
            :"Other Outputs" => { :"Qualified Children List" => [] } }
        ] }
  end
end
