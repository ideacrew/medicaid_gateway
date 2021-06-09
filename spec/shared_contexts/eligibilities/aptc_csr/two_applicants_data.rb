# frozen_string_literal: true

RSpec.shared_context 'setup magi_medicaid application with two applicants tiffany and thomas', :shared_context => :metadata do
  let(:current_date) { Date.today }
  let(:attestation) do
    { is_self_attested_blind: false,
      is_self_attested_disabled: true,
      is_incarcerated: false }
  end
  let(:benchmark_premium) do
    { health_only_lcsp_premiums: [{ member_identifier: '95', monthly_premium: 310.50 },
                                  { member_identifier: '96', monthly_premium: 310.60 }],
      health_only_slcsp_premiums: [{ member_identifier: '95', monthly_premium: 320.50 },
                                   { member_identifier: '96', monthly_premium: 320.60 }] }
  end
  let(:family_member_reference) do
    { family_member_hbx_id: '1000',
      first_name: 'tiffany',
      last_name: 'last',
      person_hbx_id: '95',
      is_primary_family_member: true }
  end
  let(:family_member2_reference) do
    { family_member_hbx_id: '1001',
      first_name: name2[:first_name],
      last_name: name2[:last_name],
      person_hbx_id: '96',
      is_primary_family_member: false }
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
  let(:job_income) do
    { kind: 'wages_and_salaries',
      amount: 1_700.00,
      frequency_kind: 'BiWeekly',
      start_on: Date.new(current_date.year) }
  end

  let(:tiffany) do
    { name: { first_name: 'tiffany', last_name: 'last' },
      identifying_information: { has_ssn: false },
      citizenship_immigration_status_information: { citizen_status: 'us_citizen', is_lawful_presence_self_attested: false },
      demographic: { gender: 'Female',
                     dob: Date.new(current_date.year - 45, current_date.month, current_date.day),
                     is_veteran_or_active_military: false },
      attestation: attestation,
      is_primary_applicant: true,
      is_applying_coverage: true,
      family_member_reference: family_member_reference,
      person_hbx_id: '95',
      is_required_to_file_taxes: true,
      tax_filer_kind: 'tax_filer',
      is_joint_tax_filing: false,
      is_claimed_as_tax_dependent: false,
      claimed_as_tax_dependent_by: nil,
      student: { is_student: false },
      foster_care: { is_former_foster_care: false },
      pregnancy_information: pregnancy_information,
      has_job_income: true,
      has_self_employment_income: false,
      has_unemployment_income: false,
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
      incomes: [job_income],
      addresses: [address1],
      is_temporarily_out_of_state: false,
      age_of_applicant: 45,
      is_claimed_as_dependent_by_non_applicant: false,
      benchmark_premium: benchmark_premium,
      is_homeless: false }
  end

  let(:thomas) do
    { name: { first_name: 'thomas', last_name: 'last' },
      identifying_information: { has_ssn: false },
      citizenship_immigration_status_information: { citizen_status: 'us_citizen', is_lawful_presence_self_attested: false },
      demographic: { gender: 'Male',
                     dob: Date.new(current_date.year - 13, current_date.month, current_date.day),
                     is_veteran_or_active_military: false },
      attestation: attestation,
      is_primary_applicant: true,
      is_applying_coverage: true,
      family_member_reference: family_member_reference,
      person_hbx_id: '96',
      is_required_to_file_taxes: true,
      tax_filer_kind: 'tax_filer',
      is_joint_tax_filing: false,
      is_claimed_as_tax_dependent: true,
      claimed_as_tax_dependent_by: applicant_reference,
      student: { is_student: false },
      foster_care: { is_former_foster_care: false },
      pregnancy_information: pregnancy_information,
      has_job_income: false,
      has_self_employment_income: false,
      has_unemployment_income: false,
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
      addresses: [address1],
      is_temporarily_out_of_state: false,
      age_of_applicant: 13,
      is_claimed_as_dependent_by_non_applicant: false,
      benchmark_premium: benchmark_premium,
      is_homeless: false }
  end

  let(:applicant_reference) do
    { first_name: tiffany[:name][:first_name],
      last_name: tiffany[:name][:last_name],
      dob: tiffany[:demographic][:dob],
      person_hbx_id: tiffany[:person_hbx_id] }
  end

  let(:applicant2_reference) do
    { first_name: thomas[:name][:first_name],
      last_name: thomas[:name][:last_name],
      dob: thomas[:demographic][:dob],
      person_hbx_id: thomas[:person_hbx_id] }
  end

  let(:relationships) do
    [{ kind: 'parent', applicant_reference: applicant_reference, relative_reference: applicant2_reference },
     { kind: 'child', applicant_reference: applicant2_reference, relative_reference: applicant_reference }]
  end

  let(:product_eligibility_determination) do
    { is_ia_eligible: false,
      is_medicaid_chip_eligible: false,
      is_non_magi_medicaid_eligible: false,
      is_totally_ineligible: false,
      is_without_assistance: false,
      is_magi_medicaid: false,
      magi_medicaid_monthly_household_income: 6474.42,
      medicaid_household_size: 1,
      magi_medicaid_monthly_income_limit: 3760.67,
      magi_as_percentage_of_fpl: 10.0,
      magi_medicaid_category: 'parent_caretaker' }
  end

  let(:tax_household_member2) do
    { product_eligibility_determination: product_eligibility_determination,
      applicant_reference: applicant2_reference }
  end

  let(:product_eligibility_determination2) do
    { is_ia_eligible: false,
      is_medicaid_chip_eligible: false,
      is_non_magi_medicaid_eligible: false,
      is_totally_ineligible: false,
      is_without_assistance: false,
      is_magi_medicaid: false,
      magi_medicaid_monthly_household_income: 6474.42,
      medicaid_household_size: 1,
      magi_medicaid_monthly_income_limit: 3760.67,
      magi_as_percentage_of_fpl: 10.0,
      magi_medicaid_category: 'child' }
  end

  let(:tax_household_member) do
    { product_eligibility_determination: product_eligibility_determination,
      applicant_reference: applicant_reference }
  end

  let(:tax_household_member2) do
    { product_eligibility_determination: product_eligibility_determination2,
      applicant_reference: applicant2_reference }
  end

  let(:tax_hh) do
    { max_aptc: nil,
      csr: nil,
      hbx_id: '12345',
      is_insurance_assistance_eligible: nil,
      tax_household_members: [tax_household_member, tax_household_member2] }
  end

  let(:app_params) do
    { us_state: 'DC',
      oe_start_on: Date.new(Date.today.year, 11, 1),
      hbx_id: '200000123',
      family_reference: { hbx_id: '10011' },
      assistance_year: Date.today.year,
      aptc_effective_date: Date.today,
      relationships: relationships,
      applicants: [tiffany, thomas],
      tax_households: [tax_hh] }
  end

  let(:input_application) do
    ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
  end

  let(:input_tax_household) do
    input_application.tax_households.first
  end
end