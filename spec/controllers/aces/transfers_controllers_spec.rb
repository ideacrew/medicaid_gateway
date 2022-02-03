# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/ModuleLength
# Spec for TransfersController
module Aces
  RSpec.describe TransfersController, type: :controller, dbclean: :after_each do

    describe 'GET new' do
      let(:user) { FactoryBot.create(:user) }

      before :each do
        sign_in user
        get :new
      end

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end
    end

    describe 'POST create', dbclean: :after_each do
      let(:user) { FactoryBot.create(:user) }

      let(:outbound_payload) do
        {
          family: {
            hbx_id: "11046",
            ext_app_id: "IDC61261111114166619",
            family_members: [
              {
                person: {
                  ext_app_id: "pe1992374604681766994",
                  person_name: {
                    first_name: "Simple",
                    middle_name: "Transfer",
                    last_name: "L",
                    full_name: "Simple Transfer L"
                  },
                  hbx_id: "1003158",
                  person_health: {
                    is_tobacco_user: nil,
                    is_physically_disabled: nil
                  },
                  is_homeless: false,
                  is_temporarily_out_of_state: false,
                  age_off_excluded: nil,
                  is_active: nil,
                  is_disabled: false,
                  person_demographics: {
                    gender: "male",
                    dob: "01/01/1941",
                    ssn: "111111111",
                    no_ssn: "0",
                    date_of_death: nil,
                    dob_check: nil,
                    is_incarcerated: false,
                    tribal_id: nil,
                    language_code: nil,
                    tribal_state: nil,
                    tribal_name: nil
                  },
                  race: "White",
                  consumer_role: {
                    is_active: "true",
                    lawful_presence_determination: {
                      citizen_status: "us_citizen"
                    },
                    language_preference: "english",
                    five_year_bar: nil,
                    requested_coverage_start_date: "2021-05-07",
                    is_applicant: true,
                    birth_location: nil,
                    marital_status: false,
                    is_applying_coverage: true,
                    bookmark_url: nil,
                    admin_bookmark_url: nil,
                    contact_method: "mobile",
                    is_state_resident: nil,
                    identity_validation: nil,
                    identity_update_reason: nil,
                    application_validation: nil,
                    application_update_reason: nil,
                    identity_rejected: nil,
                    application_rejected: nil,
                    documents: [],
                    vlp_documents: [],
                    ridp_documents: [],
                    verification_type_history_elements: [],
                    local_residency_responses: [],
                    local_residency_requests: []
                  },
                  addresses: [
                    {
                      kind: "home",
                      address_1: "514 Test Street",
                      address_2: nil,
                      address_3: nil,
                      city: "Augusta",
                      county: "KENNEBEC",
                      county_code: "011",
                      state: "ME",
                      zip: "04330",
                      country_name: nil
                    },
                    {
                      kind: "mailing",
                      address_1: "37 ML",
                      address_2: nil,
                      address_3: nil,
                      city: "Augusta",
                      county: "KENNEBEC",
                      county_code: "011",
                      state: "ME",
                      zip: "04330",
                      country_name: nil
                    }
                  ],
                  emails: [
                    {
                      address: "M80@gmail.com",
                      kind: "home"
                    }
                  ],
                  phones: [
                    {
                      extension: nil,
                      kind: "mobile",
                      area_code: "301",
                      number: "1510342",
                      primary: true,
                      full_phone_number: "3011510342",
                      start_on: nil,
                      end_on: nil
                    }
                  ],
                  person_relationships: [
                    {
                      relative: {
                        hbx_id: "1003158",
                        first_name: "Simple",
                        last_name: "L",
                        gender: "Male",
                        dob: "01/01/1941",
                        ssn: "111111"
                      },
                      kind: "self"
                    }
                  ]
                },
                ethnicity: [],
                is_consent_applicant: nil,
                is_coverage_applicant: true,
                is_primary_applicant: true,
                hbx_id: "1003158"
              },
              {
                person: {
                  ext_app_id: "pe1992374604681766995",
                  person_name: {
                    first_name: "Helen",
                    middle_name: nil,
                    last_name: "test",
                    full_name: "Helen test"
                  },
                  hbx_id: "1002699",
                  person_health: {
                    is_tobacco_user: nil,
                    is_physically_disabled: nil
                  },
                  is_homeless: false,
                  is_temporarily_out_of_state: false,
                  age_off_excluded: nil,
                  is_active: nil,
                  is_disabled: false,
                  person_demographics: {
                    gender: "female",
                    dob: "01/01/1997",
                    ssn: "111111111",
                    no_ssn: "1",
                    date_of_death: nil,
                    dob_check: nil,
                    is_incarcerated: false,
                    tribal_id: nil,
                    language_code: nil,
                    tribal_state: nil,
                    tribal_name: nil
                  },
                  race: "White",
                  consumer_role: {
                    is_active: "true",
                    lawful_presence_determination: {
                      citizen_status: "us_citizen"
                    },
                    language_preference: "english",
                    five_year_bar: nil,
                    requested_coverage_start_date: "2021-05-07",
                    is_applicant: false,
                    birth_location: nil,
                    marital_status: false,
                    is_applying_coverage: true,
                    bookmark_url: nil,
                    admin_bookmark_url: nil,
                    contact_method: nil,
                    is_state_resident: nil,
                    identity_validation: nil,
                    identity_update_reason: nil,
                    application_validation: nil,
                    application_update_reason: nil,
                    identity_rejected: nil,
                    application_rejected: nil,
                    documents: [],
                    vlp_documents: [],
                    ridp_documents: [],
                    verification_type_history_elements: [],
                    local_residency_responses: [],
                    local_residency_requests: []
                  },
                  addresses: [
                    {
                      kind: "home",
                      address_1: "514 Test Street",
                      address_2: nil,
                      address_3: nil,
                      city: "Augusta",
                      county: "KENNEBEC",
                      county_code: "011",
                      state: "ME",
                      zip: "04330",
                      country_name: nil
                    },
                    {
                      kind: "mailing",
                      address_1: "37 ML",
                      address_2: nil,
                      address_3: nil,
                      city: "Augusta",
                      county: "KENNEBEC",
                      county_code: "011",
                      state: "ME",
                      zip: "04330",
                      country_name: nil
                    }
                  ],
                  emails: [
                    {
                      address: "H24@gmail.com",
                      kind: "home"
                    }
                  ],
                  phones: [
                    {
                      extension: nil,
                      kind: "mobile",
                      area_code: "301",
                      number: "2228341",
                      primary: true,
                      full_phone_number: "3012228342",
                      start_on: nil,
                      end_on: nil
                    }
                  ],
                  person_relationships: [
                    {
                      relative: {
                        hbx_id: "1234",
                        first_name: "Simple",
                        last_name: "L",
                        gender: "Male",
                        dob: "01/01/1941",
                        ssn: nil
                      },
                      kind: "child"
                    }
                  ]
                },
                ethnicity: [],
                is_consent_applicant: nil,
                is_coverage_applicant: true,
                is_primary_applicant: false,
                hbx_id: "1002699"
              },
              {
                person: {
                  ext_app_id: "pe1992374604681766996",
                  person_name: {
                    first_name: "Robert",
                    middle_name: nil,
                    last_name: "test",
                    full_name: "Robert test"
                  },
                  hbx_id: "1003159",
                  person_health: {
                    is_tobacco_user: nil,
                    is_physically_disabled: nil
                  },
                  is_homeless: false,
                  is_temporarily_out_of_state: false,
                  age_off_excluded: nil,
                  is_active: nil,
                  is_disabled: false,
                  person_demographics: {
                    ssn: "212828539",
                    gender: "male",
                    dob: "01/01/2010",
                    no_ssn: "0",
                    date_of_death: nil,
                    dob_check: nil,
                    is_incarcerated: false,
                    tribal_id: nil,
                    language_code: nil,
                    tribal_state: nil,
                    tribal_name: nil
                  },
                  race: "White",
                  consumer_role: {
                    is_active: "true",
                    lawful_presence_determination: {
                      citizen_status: "us_citizen"
                    },
                    language_preference: "english",
                    five_year_bar: nil,
                    requested_coverage_start_date: "2021-05-07",
                    is_applicant: false,
                    birth_location: nil,
                    marital_status: false,
                    is_applying_coverage: true,
                    bookmark_url: nil,
                    admin_bookmark_url: nil,
                    contact_method: nil,
                    is_state_resident: nil,
                    identity_validation: nil,
                    identity_update_reason: nil,
                    application_validation: nil,
                    application_update_reason: nil,
                    identity_rejected: nil,
                    application_rejected: nil,
                    documents: [],
                    vlp_documents: [],
                    ridp_documents: [],
                    verification_type_history_elements: [],
                    local_residency_responses: [],
                    local_residency_requests: []
                  },
                  addresses: [
                    {
                      kind: "home",
                      address_1: "510 Test Street",
                      address_2: nil,
                      address_3: nil,
                      city: "Augusta",
                      county: "KENNEBEC",
                      county_code: "011",
                      state: "ME",
                      zip: "04330",
                      country_name: nil
                    },
                    {
                      kind: "mailing",
                      address_1: "37 ML",
                      address_2: nil,
                      address_3: nil,
                      city: "Augusta",
                      county: "KENNEBEC",
                      county_code: "011",
                      state: "ME",
                      zip: "04330",
                      country_name: nil
                    }
                  ],
                  emails: [
                    {
                      address: "RH10@gmail.com",
                      kind: "home"
                    }
                  ],
                  phones: [
                    {
                      extension: nil,
                      kind: "mobile",
                      area_code: "202",
                      number: "1768341",
                      primary: true,
                      full_phone_number: "2021768341",
                      start_on: nil,
                      end_on: nil
                    }
                  ],
                  person_relationships: [
                    {
                      relative: {
                        hbx_id: "1234",
                        first_name: "Simple",
                        last_name: "L",
                        gender: "Male",
                        dob: "01/01/1941",
                        ssn: nil
                      },
                      kind: "child"
                    }
                  ]
                },
                ethnicity: [],
                is_consent_applicant: nil,
                is_coverage_applicant: true,
                is_primary_applicant: false,
                hbx_id: "1003159"
              }
            ],
            general_agency_accounts: [],
            special_enrollment_periods: [],
            irs_groups: [],
            broker_accounts: [],
            documents: [],
            payment_transactions: [],
            magi_medicaid_applications: {
              family_reference: {
                hbx_id: "10419"
              },
              assistance_year: 2021,
              aptc_effective_date: "2021-09-01T00:00:00.000+00:00",
              years_to_renew: nil,
              renewal_consent_through_year: 5,
              is_ridp_verified: true,
              is_renewal_authorized: true,
              applicants: [
                {
                  name: {
                    first_name: "Simple",
                    middle_name: nil,
                    last_name: "L",
                    name_sfx: nil,
                    name_pfx: nil
                  },
                  identifying_information: {
                    has_ssn: "1",
                    encrypted_ssn: nil
                  },
                  demographic: {
                    gender: "Male",
                    dob: "1941-01-01",
                    ethnicity: ["White"],
                    race: nil,
                    is_veteran_or_active_military: false,
                    is_vets_spouse_or_child: false
                  },
                  attestation: {
                    is_incarcerated: false,
                    is_self_attested_disabled: false,
                    is_self_attested_blind: false,
                    is_self_attested_long_term_care: false
                  },
                  is_primary_applicant: true,
                  native_american_information: {
                    indian_tribe_member: false,
                    tribal_id: nil
                  },
                  citizenship_immigration_status_information: {
                    citizen_status: "us_citizen",
                    is_lawful_presence_self_attested: false,
                    is_resident_post_092296: false
                  },
                  is_consumer_role: true,
                  is_resident_role: false,
                  is_applying_coverage: true,
                  is_consent_applicant: false,
                  vlp_document: nil,
                  family_member_reference: {
                    family_member_hbx_id: "1003158",
                    first_name: "Simple",
                    last_name: "L",
                    person_hbx_id: "1003158",
                    is_primary_family_member: true
                  },
                  person_hbx_id: "1003158",
                  is_required_to_file_taxes: true,
                  is_filing_as_head_of_household: true,
                  is_joint_tax_filing: false,
                  is_claimed_as_tax_dependent: false,
                  claimed_as_tax_dependent_by: nil,
                  tax_filer_kind: "tax_filer",
                  student: {
                    is_student: false,
                    student_kind: nil,
                    student_school_kind: nil,
                    student_status_end_on: nil
                  },
                  is_refugee: false,
                  is_trafficking_victim: false,
                  foster_care: {
                    is_former_foster_care: false,
                    age_left_foster_care: nil,
                    foster_care_us_state: "",
                    had_medicaid_during_foster_care: false
                  },
                  pregnancy_information: {
                    is_pregnant: false,
                    is_enrolled_on_medicaid: false,
                    is_post_partum_period: false,
                    expected_children_count: nil,
                    pregnancy_due_on: nil,
                    pregnancy_end_on: nil
                  },
                  is_subject_to_five_year_bar: false,
                  is_five_year_bar_met: false,
                  is_forty_quarters: false,
                  is_ssn_applied: false,
                  non_ssn_apply_reason: "",
                  moved_on_or_after_welfare_reformed_law: false,
                  is_currently_enrolled_in_health_plan: false,
                  has_daily_living_help: false,
                  need_help_paying_bills: false,
                  has_job_income: true,
                  has_self_employment_income: false,
                  has_unemployment_income: false,
                  has_other_income: false,
                  has_deductions: false,
                  has_enrolled_health_coverage: false,
                  has_eligible_health_coverage: false,
                  job_coverage_ended_in_past_3_months: false,
                  job_coverage_end_date: nil,
                  medicaid_and_chip: {
                    not_eligible_in_last_90_days: false,
                    denied_on: nil,
                    ended_as_change_in_eligibility: false,
                    hh_income_or_size_changed: false,
                    medicaid_or_chip_coverage_end_date: nil,
                    ineligible_due_to_immigration_in_last_5_years: false,
                    immigration_status_changed_since_ineligibility: false
                  },
                  other_health_service: {
                    has_received: false,
                    is_eligible: false
                  },
                  addresses: [
                    {
                      kind: "home",
                      address_1: "514 Test Street",
                      address_2: "",
                      address_3: "",
                      city: "Augusta",
                      county: "KENNEBEC",
                      state: "ME",
                      zip: "04330",
                      country_name: nil
                    },
                    {
                      kind: "mailing",
                      address_1: "37 ML",
                      address_2: "",
                      address_3: "",
                      city: "Augusta",
                      county: "KENNEBEC",
                      state: "ME",
                      zip: "04330",
                      country_name: nil
                    }
                  ],
                  emails: [
                    {
                      kind: "home",
                      address: "M80@gmail.com"
                    }
                  ],
                  phones: [
                    {
                      kind: "mobile",
                      primary: false,
                      area_code: "301",
                      number: "1510342",
                      country_code: "",
                      extension: "",
                      full_phone_number: "3011510342"
                    }
                  ],
                  incomes: [
                    {
                      title: nil,
                      kind: "wages_and_salaries",
                      wage_type: nil,
                      hours_per_week: nil,
                      amount: 78_100.0,
                      amount_tax_exempt: 0,
                      frequency_kind: "Annually",
                      start_on: "2021-01-01",
                      end_on: nil,
                      is_projected: false,
                      tax_form: nil,
                      employer: {
                        employer_name: "City of Augusta Bank",
                        employer_id: "em2009481180751485382"
                      },
                      has_property_usage_rights: nil,
                      submitted_at: "2021-07-27T14:29:26.000+00:00"
                    }
                  ],
                  benefits: [],
                  deductions: [],
                  is_medicare_eligible: false,
                  is_self_attested_long_term_care: false,
                  has_insurance: false,
                  has_state_health_benefit: false,
                  had_prior_insurance: false,
                  prior_insurance_end_date: nil,
                  age_of_applicant: 80,
                  hours_worked_per_week: 0,
                  is_temporarily_out_of_state: false,
                  is_claimed_as_dependent_by_non_applicant: false,
                  benchmark_premium: {
                    health_only_lcsp_premiums: [
                      {
                        member_identifier: "1003158",
                        monthly_premium: 310.5
                      },
                      {
                        member_identifier: "1002699",
                        monthly_premium: 310.5
                      },
                      {
                        member_identifier: "1003159",
                        monthly_premium: 310.5
                      }
                    ],
                    health_only_slcsp_premiums: [
                      {
                        member_identifier: "1003158",
                        monthly_premium: 310.5
                      },
                      {
                        member_identifier: "1002699",
                        monthly_premium: 310.5
                      },
                      {
                        member_identifier: "1003159",
                        monthly_premium: 310.5
                      }
                    ]
                  },
                  is_homeless: false,
                  mitc_income: {
                    amount: 78_100,
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
                    adjusted_gross_income: {
                      cents: 7_810_000,
                      currency_iso: "USD"
                    },
                    deductible_part_of_self_employment_tax: 0,
                    ira_deduction: 0,
                    student_loan_interest_deduction: 0,
                    tution_and_fees: 0,
                    other_magi_eligible_income: 0
                  },
                  mitc_relationships: [
                    {
                      other_id: "1002699",
                      attest_primary_responsibility: "Y",
                      relationship_code: "03"
                    },
                    {
                      other_id: "1003159",
                      attest_primary_responsibility: "Y",
                      relationship_code: "03"
                    }
                  ],
                  mitc_is_required_to_file_taxes: true
                },
                {
                  name: {
                    first_name: "Helen",
                    middle_name: nil,
                    last_name: "test",
                    name_sfx: nil,
                    name_pfx: nil
                  },
                  identifying_information: {
                    has_ssn: "0",
                    encrypted_ssn: nil
                  },
                  demographic: {
                    gender: "Female",
                    dob: "1997-01-01",
                    ethnicity: [],
                    race: nil,
                    is_veteran_or_active_military: false,
                    is_vets_spouse_or_child: false
                  },
                  attestation: {
                    is_incarcerated: false,
                    is_self_attested_disabled: false,
                    is_self_attested_blind: false,
                    is_self_attested_long_term_care: false
                  },
                  is_primary_applicant: false,
                  native_american_information: {
                    indian_tribe_member: false,
                    tribal_id: nil
                  },
                  citizenship_immigration_status_information: {
                    citizen_status: "us_citizen",
                    is_lawful_presence_self_attested: false,
                    is_resident_post_092296: false
                  },
                  is_consumer_role: true,
                  is_resident_role: false,
                  is_applying_coverage: true,
                  is_consent_applicant: false,
                  vlp_document: nil,
                  family_member_reference: {
                    family_member_hbx_id: "1002699",
                    first_name: "Helen",
                    last_name: "test",
                    person_hbx_id: "1002699",
                    is_primary_family_member: false
                  },
                  person_hbx_id: "1002699",
                  is_required_to_file_taxes: false,
                  is_filing_as_head_of_household: false,
                  is_joint_tax_filing: false,
                  is_claimed_as_tax_dependent: true,
                  claimed_as_tax_dependent_by: {
                    first_name: "Simple",
                    last_name: "L",
                    dob: "1941-01-01",
                    person_hbx_id: "1003158",
                    encrypted_ssn: nil
                  },
                  tax_filer_kind: "dependent",
                  student: {
                    is_student: false,
                    student_kind: nil,
                    student_school_kind: nil,
                    student_status_end_on: nil
                  },
                  is_refugee: false,
                  is_trafficking_victim: false,
                  foster_care: {
                    is_former_foster_care: true,
                    age_left_foster_care: 18,
                    foster_care_us_state: "ME",
                    had_medicaid_during_foster_care: true
                  },
                  pregnancy_information: {
                    is_pregnant: false,
                    is_enrolled_on_medicaid: false,
                    is_post_partum_period: false,
                    expected_children_count: nil,
                    pregnancy_due_on: nil,
                    pregnancy_end_on: nil
                  },
                  is_subject_to_five_year_bar: false,
                  is_five_year_bar_met: false,
                  is_forty_quarters: false,
                  is_ssn_applied: false,
                  non_ssn_apply_reason: nil,
                  moved_on_or_after_welfare_reformed_law: false,
                  is_currently_enrolled_in_health_plan: false,
                  has_daily_living_help: false,
                  need_help_paying_bills: false,
                  has_job_income: false,
                  has_self_employment_income: false,
                  has_unemployment_income: false,
                  has_other_income: false,
                  has_deductions: false,
                  has_enrolled_health_coverage: false,
                  has_eligible_health_coverage: false,
                  job_coverage_ended_in_past_3_months: false,
                  job_coverage_end_date: nil,
                  medicaid_and_chip: {
                    not_eligible_in_last_90_days: false,
                    denied_on: nil,
                    ended_as_change_in_eligibility: false,
                    hh_income_or_size_changed: false,
                    medicaid_or_chip_coverage_end_date: nil,
                    ineligible_due_to_immigration_in_last_5_years: false,
                    immigration_status_changed_since_ineligibility: false
                  },
                  other_health_service: {
                    has_received: false,
                    is_eligible: false
                  },
                  addresses: [
                    {
                      kind: "home",
                      address_1: "514 Test Street",
                      address_2: "",
                      address_3: "",
                      city: "Augusta",
                      county: "KENNEBEC",
                      state: "ME",
                      zip: "04330",
                      country_name: nil
                    },
                    {
                      kind: "mailing",
                      address_1: "37 ML",
                      address_2: "",
                      address_3: "",
                      city: "Augusta",
                      county: "KENNEBEC",
                      state: "ME",
                      zip: "04330",
                      country_name: nil
                    }
                  ],
                  emails: [
                    {
                      kind: "home",
                      address: "H24@gmail.com"
                    }
                  ],
                  phones: [
                    {
                      kind: "mobile",
                      primary: true,
                      area_code: "301",
                      number: "2228341",
                      country_code: "",
                      extension: "",
                      full_phone_number: "3012228342"
                    }
                  ],
                  incomes: [],
                  benefits: [],
                  deductions: [],
                  is_medicare_eligible: false,
                  is_self_attested_long_term_care: false,
                  has_insurance: false,
                  has_state_health_benefit: false,
                  had_prior_insurance: false,
                  prior_insurance_end_date: nil,
                  age_of_applicant: 24,
                  hours_worked_per_week: 0,
                  is_temporarily_out_of_state: false,
                  is_claimed_as_dependent_by_non_applicant: false,
                  benchmark_premium: {
                    health_only_lcsp_premiums: [
                      {
                        member_identifier: "1003158",
                        monthly_premium: 310.5
                      },
                      {
                        member_identifier: "1002699",
                        monthly_premium: 310.5
                      },
                      {
                        member_identifier: "1003159",
                        monthly_premium: 310.5
                      }
                    ],
                    health_only_slcsp_premiums: [
                      {
                        member_identifier: "1003158",
                        monthly_premium: 310.5
                      },
                      {
                        member_identifier: "1002699",
                        monthly_premium: 310.5
                      },
                      {
                        member_identifier: "1003159",
                        monthly_premium: 310.5
                      }
                    ]
                  },
                  is_homeless: false,
                  mitc_income: {
                    amount: 0,
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
                    adjusted_gross_income: {
                      cents: 0,
                      currency_iso: "USD"
                    },
                    deductible_part_of_self_employment_tax: 0,
                    ira_deduction: 0,
                    student_loan_interest_deduction: 0,
                    tution_and_fees: 0,
                    other_magi_eligible_income: 0
                  },
                  mitc_relationships: [
                    {
                      other_id: "1003158",
                      attest_primary_responsibility: "N",
                      relationship_code: "04"
                    },
                    {
                      other_id: "1003159",
                      attest_primary_responsibility: "N",
                      relationship_code: "07"
                    }
                  ],
                  mitc_is_required_to_file_taxes: false
                },
                {
                  name: {
                    first_name: "Robert",
                    middle_name: nil,
                    last_name: "test",
                    name_sfx: nil,
                    name_pfx: nil
                  },
                  identifying_information: {
                    has_ssn: "0",
                    encrypted_ssn: "QEVuQwEAhSGtHhAjniLFopfwZ8h6dQ=="
                  },
                  demographic: {
                    gender: "Male",
                    dob: "2010-01-01",
                    ethnicity: [],
                    race: nil,
                    is_veteran_or_active_military: false,
                    is_vets_spouse_or_child: false
                  },
                  attestation: {
                    is_incarcerated: false,
                    is_self_attested_disabled: false,
                    is_self_attested_blind: false,
                    is_self_attested_long_term_care: false
                  },
                  is_primary_applicant: false,
                  native_american_information: {
                    indian_tribe_member: false,
                    tribal_id: nil
                  },
                  citizenship_immigration_status_information: {
                    citizen_status: "us_citizen",
                    is_lawful_presence_self_attested: false,
                    is_resident_post_092296: false
                  },
                  is_consumer_role: true,
                  is_resident_role: false,
                  is_applying_coverage: true,
                  is_consent_applicant: false,
                  vlp_document: nil,
                  family_member_reference: {
                    family_member_hbx_id: "1003159",
                    first_name: "Robert",
                    last_name: "test",
                    person_hbx_id: "1003159",
                    is_primary_family_member: false
                  },
                  person_hbx_id: "1003159",
                  is_required_to_file_taxes: false,
                  is_filing_as_head_of_household: false,
                  is_joint_tax_filing: false,
                  is_claimed_as_tax_dependent: true,
                  claimed_as_tax_dependent_by: {
                    first_name: "Simple",
                    last_name: "L",
                    dob: "1941-01-01",
                    person_hbx_id: "1003158",
                    encrypted_ssn: nil
                  },
                  tax_filer_kind: "dependent",
                  student: {
                    is_student: false,
                    student_kind: nil,
                    student_school_kind: nil,
                    student_status_end_on: nil
                  },
                  is_refugee: false,
                  is_trafficking_victim: false,
                  foster_care: {
                    is_former_foster_care: false,
                    age_left_foster_care: nil,
                    foster_care_us_state: nil,
                    had_medicaid_during_foster_care: false
                  },
                  pregnancy_information: {
                    is_pregnant: false,
                    is_enrolled_on_medicaid: false,
                    is_post_partum_period: false,
                    expected_children_count: nil,
                    pregnancy_due_on: nil,
                    pregnancy_end_on: nil
                  },
                  is_subject_to_five_year_bar: false,
                  is_five_year_bar_met: false,
                  is_forty_quarters: false,
                  is_ssn_applied: false,
                  non_ssn_apply_reason: nil,
                  moved_on_or_after_welfare_reformed_law: false,
                  is_currently_enrolled_in_health_plan: false,
                  has_daily_living_help: false,
                  need_help_paying_bills: false,
                  has_job_income: false,
                  has_self_employment_income: false,
                  has_unemployment_income: false,
                  has_other_income: false,
                  has_deductions: false,
                  has_enrolled_health_coverage: false,
                  has_eligible_health_coverage: false,
                  job_coverage_ended_in_past_3_months: false,
                  job_coverage_end_date: nil,
                  medicaid_and_chip: {
                    not_eligible_in_last_90_days: false,
                    denied_on: nil,
                    ended_as_change_in_eligibility: false,
                    hh_income_or_size_changed: false,
                    medicaid_or_chip_coverage_end_date: nil,
                    ineligible_due_to_immigration_in_last_5_years: false,
                    immigration_status_changed_since_ineligibility: false
                  },
                  other_health_service: {
                    has_received: false,
                    is_eligible: false
                  },
                  addresses: [
                    {
                      kind: "home",
                      address_1: "510 Test Street",
                      address_2: "",
                      address_3: "",
                      city: "Augusta",
                      county: "KENNEBEC",
                      state: "ME",
                      zip: "04330",
                      country_name: nil
                    },
                    {
                      kind: "mailing",
                      address_1: "37 ML",
                      address_2: "",
                      address_3: "",
                      city: "Augusta",
                      county: "KENNEBEC",
                      state: "ME",
                      zip: "04330",
                      country_name: nil
                    }
                  ],
                  emails: [
                    {
                      kind: "home",
                      address: "RH10@gmail.com"
                    }
                  ],
                  phones: [
                    {
                      kind: "mobile",
                      primary: false,
                      area_code: "202",
                      number: "1768341",
                      country_code: "",
                      extension: "",
                      full_phone_number: "2021768341"
                    }
                  ],
                  incomes: [],
                  benefits: [],
                  deductions: [],
                  is_medicare_eligible: false,
                  is_self_attested_long_term_care: false,
                  has_insurance: false,
                  has_state_health_benefit: false,
                  had_prior_insurance: false,
                  prior_insurance_end_date: nil,
                  age_of_applicant: 11,
                  hours_worked_per_week: 0,
                  is_temporarily_out_of_state: false,
                  is_claimed_as_dependent_by_non_applicant: false,
                  benchmark_premium: {
                    health_only_lcsp_premiums: [
                      {
                        member_identifier: "1003158",
                        monthly_premium: 310.5
                      },
                      {
                        member_identifier: "1002699",
                        monthly_premium: 310.5
                      },
                      {
                        member_identifier: "1003159",
                        monthly_premium: 310.5
                      }
                    ],
                    health_only_slcsp_premiums: [
                      {
                        member_identifier: "1003158",
                        monthly_premium: 310.5
                      },
                      {
                        member_identifier: "1002699",
                        monthly_premium: 310.5
                      },
                      {
                        member_identifier: "1003159",
                        monthly_premium: 310.5
                      }
                    ]
                  },
                  is_homeless: false,
                  mitc_income: {
                    amount: 0,
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
                    adjusted_gross_income: {
                      cents: 0,
                      currency_iso: "USD"
                    },
                    deductible_part_of_self_employment_tax: 0,
                    ira_deduction: 0,
                    student_loan_interest_deduction: 0,
                    tution_and_fees: 0,
                    other_magi_eligible_income: 0
                  },
                  mitc_relationships: [
                    {
                      other_id: "1003158",
                      attest_primary_responsibility: "N",
                      relationship_code: "04"
                    },
                    {
                      other_id: "1002699",
                      attest_primary_responsibility: "N",
                      relationship_code: "07"
                    }
                  ],
                  mitc_is_required_to_file_taxes: false
                }
              ],
              relationships: [
                {
                  kind: "child",
                  applicant_reference: {
                    first_name: "Helen",
                    last_name: "test",
                    dob: "1997-01-01",
                    person_hbx_id: "1002699",
                    encrypted_ssn: nil
                  },
                  relative_reference: {
                    first_name: "Simple",
                    last_name: "L",
                    dob: "1941-01-01",
                    person_hbx_id: "1003158",
                    encrypted_ssn: nil
                  },
                  live_with_household_member: false
                },
                {
                  kind: "parent",
                  applicant_reference: {
                    first_name: "Simple",
                    last_name: "L",
                    dob: "1941-01-01",
                    person_hbx_id: "1003158",
                    encrypted_ssn: nil
                  },
                  relative_reference: {
                    first_name: "Helen",
                    last_name: "test",
                    dob: "1997-01-01",
                    person_hbx_id: "1002699",
                    encrypted_ssn: nil
                  },
                  live_with_household_member: false
                },
                {
                  kind: "child",
                  applicant_reference: {
                    first_name: "Robert",
                    last_name: "test",
                    dob: "2010-01-01",
                    person_hbx_id: "1003159",
                    encrypted_ssn: "QEVuQwEAhSGtHhAjniLFopfwZ8h6dQ=="
                  },
                  relative_reference: {
                    first_name: "Simple",
                    last_name: "L",
                    dob: "1941-01-01",
                    person_hbx_id: "1003158",
                    encrypted_ssn: nil
                  },
                  live_with_household_member: false
                },
                {
                  kind: "parent",
                  applicant_reference: {
                    first_name: "Simple",
                    last_name: "L",
                    dob: "1941-01-01",
                    person_hbx_id: "1003158",
                    encrypted_ssn: nil
                  },
                  relative_reference: {
                    first_name: "Robert",
                    last_name: "test",
                    dob: "2010-01-01",
                    person_hbx_id: "1003159",
                    encrypted_ssn: "QEVuQwEAhSGtHhAjniLFopfwZ8h6dQ=="
                  },
                  live_with_household_member: false
                },
                {
                  kind: "sibling",
                  applicant_reference: {
                    first_name: "Helen",
                    last_name: "test",
                    dob: "1997-01-01",
                    person_hbx_id: "1002699",
                    encrypted_ssn: nil
                  },
                  relative_reference: {
                    first_name: "Robert",
                    last_name: "test",
                    dob: "2010-01-01",
                    person_hbx_id: "1003159",
                    encrypted_ssn: "QEVuQwEAhSGtHhAjniLFopfwZ8h6dQ=="
                  },
                  live_with_household_member: false
                },
                {
                  kind: "sibling",
                  applicant_reference: {
                    first_name: "Robert",
                    last_name: "test",
                    dob: "2010-01-01",
                    person_hbx_id: "1003159",
                    encrypted_ssn: "QEVuQwEAhSGtHhAjniLFopfwZ8h6dQ=="
                  },
                  relative_reference: {
                    first_name: "Helen",
                    last_name: "test",
                    dob: "1997-01-01",
                    person_hbx_id: "1002699",
                    encrypted_ssn: nil
                  },
                  live_with_household_member: false
                }
              ],
              tax_households: [
                {
                  hbx_id: "10711",
                  max_aptc: {
                    cents: 0,
                    currency_iso: "USD"
                  },
                  is_insurance_assistance_eligible: nil,
                  annual_tax_household_income: {"cents": "72332.0"},
                  tax_household_members: [
                    {
                      applicant_reference: {
                        first_name: "Simple",
                        last_name: "L",
                        dob: "1941-01-01",
                        person_hbx_id: "1003158",
                        encrypted_ssn: nil
                      },
                      product_eligibility_determination: {
                        is_ia_eligible: false,
                        is_medicaid_chip_eligible: false,
                        is_totally_ineligible: false,
                        is_magi_medicaid: false,
                        is_non_magi_medicaid_eligible: false,
                        is_without_assistance: false,
                        magi_medicaid_monthly_household_income: {
                          cents: 0,
                          currency_iso: "USD"
                        },
                        medicaid_household_size: nil,
                        magi_medicaid_monthly_income_limit: {
                          cents: 0,
                          currency_iso: "USD"
                        },
                        magi_as_percentage_of_fpl: 0.0,
                        magi_medicaid_category: nil
                      }
                    },
                    {
                      applicant_reference: {
                        first_name: "Helen",
                        last_name: "test",
                        dob: "1997-01-01",
                        person_hbx_id: "1002699",
                        encrypted_ssn: nil
                      },
                      product_eligibility_determination: {
                        is_ia_eligible: false,
                        is_medicaid_chip_eligible: false,
                        is_totally_ineligible: false,
                        is_magi_medicaid: false,
                        is_non_magi_medicaid_eligible: false,
                        is_without_assistance: false,
                        magi_medicaid_monthly_household_income: {
                          cents: 0,
                          currency_iso: "USD"
                        },
                        medicaid_household_size: nil,
                        magi_medicaid_monthly_income_limit: {
                          cents: 0,
                          currency_iso: "USD"
                        },
                        magi_as_percentage_of_fpl: 0.0,
                        magi_medicaid_category: nil
                      }
                    },
                    {
                      applicant_reference: {
                        first_name: "Robert",
                        last_name: "test",
                        dob: "2010-01-01",
                        person_hbx_id: "1003159",
                        encrypted_ssn: "QEVuQwEAhSGtHhAjniLFopfwZ8h6dQ=="
                      },
                      product_eligibility_determination: {
                        is_ia_eligible: false,
                        is_medicaid_chip_eligible: false,
                        is_totally_ineligible: false,
                        is_magi_medicaid: false,
                        is_non_magi_medicaid_eligible: false,
                        is_without_assistance: false,
                        magi_medicaid_monthly_household_income: {
                          cents: 0,
                          currency_iso: "USD"
                        },
                        medicaid_household_size: nil,
                        magi_medicaid_monthly_income_limit: {
                          cents: 0,
                          currency_iso: "USD"
                        },
                        magi_as_percentage_of_fpl: 0.0,
                        magi_medicaid_category: nil
                      }
                    }
                  ]
                }
              ],
              us_state: "ME",
              hbx_id: "1000886",
              oe_start_on: "2020-11-01",
              mitc_households: [
                {
                  household_id: "1",
                  people: [
                    {
                      person_id: "1003158"
                    },
                    {
                      person_id: "1002699"
                    }
                  ]
                },
                {
                  household_id: "2",
                  people: [
                    {
                      person_id: "1003159"
                    }
                  ]
                }
              ],
              mitc_tax_returns: [
                {
                  filers: [
                    {
                      person_id: "1003158"
                    }
                  ],
                  dependents: [
                    {
                      person_id: "1002699"
                    },
                    {
                      person_id: "1003159"
                    }
                  ]
                }
              ]
            }
          }
        }
      end

      let(:outbound_payload_json) { File.read("spec/test_data/application_and_family.json") }
      let(:aces_connection) { double('Aces Connection') }

      before :each do
        allow(::MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(double(item: "aces"))
        allow(::MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(aces_connection)
        allow(aces_connection).to receive(:setting).with(:aces_atp_service_username).and_return(double(item: 'username'))
        allow(aces_connection).to receive(:setting).with(:aces_atp_service_password).and_return(double(item: 'password'))
        allow(aces_connection).to receive(:setting).with(:aces_atp_service_uri).and_return(double(item: 'URI'))
        allow(Faraday).to receive(:post).and_return({ test: 'test' })

        sign_in user
        post :create, params: { transfer: { :outbound_payload => outbound_payload.to_s } }
      end

      context 'with valid payload - hash format' do
        it 'redirects with notice flash ' do
          expect(response).to have_http_status(:redirect)
          expect(flash[:notice]).to match(/Successfully sent payload/)
        end
      end

      context 'with valid payload - JSON format' do
        it 'redirects with notice flash ' do
          post :create, params: { transfer: { :outbound_payload => outbound_payload_json } }
          expect(response).to have_http_status(:redirect)
          expect(flash[:notice]).to match(/Successfully sent payload/)
        end
      end

      context 'with invalid payload' do
        let(:outbound_payload) do
          {}
        end

        it 'redirects with alert flash' do
          expect(response).to have_http_status(:redirect)
          expect(flash[:alert]).to match(/Exception raised/)
        end
      end
    end
  end
end
# rubocop:enable Metrics/ModuleLength
