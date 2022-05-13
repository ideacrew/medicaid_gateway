# frozen_string_literal: true

RSpec.shared_context 'dc_test_scenarios oc_5', :shared_context => :metadata do
  let(:today) { Date.today }
  let(:assistance_year) { today.year.next }
  let(:oe_start_on) { today.beginning_of_month }
  let(:start_of_year) { today.beginning_of_year }
  let(:aptc_effective_date) { Date.new(assistance_year) }

  let(:app_params) do
    {
      "family_reference" => {
        "hbx_id" => "291066"
      },
      "assistance_year" => 2022,
      "aptc_effective_date" => "2022-06-01",
      "years_to_renew" => 2027,
      "renewal_consent_through_year" => 5,
      "is_ridp_verified" => true,
      "is_renewal_authorized" => true,
      "applicants" => [
        {
          "name" => {
            "first_name" => "Ana",
            "middle_name" => nil,
            "last_name" => "OCFIVE",
            "name_sfx" => nil,
            "name_pfx" => nil
          },
          "identifying_information" => {
            "encrypted_ssn" => "LR9+wP7LJuZmjShsc3zhEoIHufwEK8BNlg==\n",
            "has_ssn" => false
          },
          "demographic" => {
            "gender" => "Female",
            "dob" => "1974-01-01",
            "ethnicity" => [
              "",
              "",
              "",
              "",
              "",
              "",
              ""
            ],
            "race" => nil,
            "is_veteran_or_active_military" => false,
            "is_vets_spouse_or_child" => false
          },
          "attestation" => {
            "is_incarcerated" => false,
            "is_self_attested_disabled" => false,
            "is_self_attested_blind" => false,
            "is_self_attested_long_term_care" => false
          },
          "is_primary_applicant" => true,
          "native_american_information" => {
            "indian_tribe_member" => false,
            "tribal_id" => nil
          },
          "citizenship_immigration_status_information" => {
            "citizen_status" => "us_citizen",
            "is_resident_post_092296" => false,
            "is_lawful_presence_self_attested" => false
          },
          "is_consumer_role" => true,
          "is_resident_role" => false,
          "is_applying_coverage" => true,
          "is_consent_applicant" => false,
          "vlp_document" => nil,
          "family_member_reference" => {
            "family_member_hbx_id" => "21210135",
            "first_name" => "Ana",
            "last_name" => "OCFIVE",
            "person_hbx_id" => "21210135",
            "is_primary_family_member" => true
          },
          "person_hbx_id" => "21210135",
          "is_required_to_file_taxes" => true,
          "is_filing_as_head_of_household" => false,
          "tax_filer_kind" => "tax_filer",
          "is_joint_tax_filing" => false,
          "is_claimed_as_tax_dependent" => false,
          "claimed_as_tax_dependent_by" => nil,
          "student" => {
            "is_student" => false,
            "student_kind" => nil,
            "student_school_kind" => nil,
            "student_status_end_on" => nil
          },
          "is_refugee" => false,
          "is_trafficking_victim" => false,
          "foster_care" => {
            "is_former_foster_care" => false,
            "age_left_foster_care" => nil,
            "foster_care_us_state" => nil,
            "had_medicaid_during_foster_care" => false
          },
          "pregnancy_information" => {
            "is_pregnant" => false,
            "is_enrolled_on_medicaid" => false,
            "is_post_partum_period" => false,
            "expected_children_count" => nil,
            "pregnancy_due_on" => nil,
            "pregnancy_end_on" => nil
          },
          "is_subject_to_five_year_bar" => false,
          "is_five_year_bar_met" => false,
          "is_forty_quarters" => false,
          "is_ssn_applied" => false,
          "non_ssn_apply_reason" => nil,
          "moved_on_or_after_welfare_reformed_law" => false,
          "is_currently_enrolled_in_health_plan" => false,
          "has_daily_living_help" => false,
          "need_help_paying_bills" => false,
          "has_job_income" => false,
          "has_self_employment_income" => false,
          "has_unemployment_income" => false,
          "has_other_income" => true,
          "has_deductions" => false,
          "has_enrolled_health_coverage" => false,
          "has_eligible_health_coverage" => false,
          "job_coverage_ended_in_past_3_months" => false,
          "job_coverage_end_date" => nil,
          "medicaid_and_chip" => {
            "not_eligible_in_last_90_days" => false,
            "denied_on" => nil,
            "ended_as_change_in_eligibility" => false,
            "hh_income_or_size_changed" => false,
            "medicaid_or_chip_coverage_end_date" => nil,
            "ineligible_due_to_immigration_in_last_5_years" => false,
            "immigration_status_changed_since_ineligibility" => false
          },
          "other_health_service" => {
            "has_received" => false,
            "is_eligible" => false
          },
          "addresses" => [
            {
              "kind" => "home",
              "address_1" => "103 Madison",
              "address_2" => nil,
              "address_3" => nil,
              "city" => "Falls Church",
              "county" => nil,
              "state" => "VA",
              "zip" => "22042",
              "country_name" => nil
            }
          ],
          "emails" => [],
          "phones" => [],
          "incomes" => [
            {
              "title" => nil,
              "kind" => "scholarship_payments",
              "wage_type" => nil,
              "hours_per_week" => nil,
              "amount" => "43000.0",
              "amount_tax_exempt" => "0.0",
              "frequency_kind" => "Annually",
              "start_on" => "2022-01-01",
              "end_on" => nil,
              "is_projected" => false,
              "employer" => nil,
              "has_property_usage_rights" => nil,
              "submitted_at" => "2022-05-12T22:04:30.000+00:00"
            }
          ],
          "benefits" => [],
          "deductions" => [],
          "is_medicare_eligible" => false,
          "has_insurance" => false,
          "has_state_health_benefit" => false,
          "had_prior_insurance" => false,
          "prior_insurance_end_date" => nil,
          "age_of_applicant" => 48,
          "is_self_attested_long_term_care" => false,
          "hours_worked_per_week" => 0,
          "is_temporarily_out_of_state" => true,
          "is_claimed_as_dependent_by_non_applicant" => false,
          "benchmark_premium" => {
            "health_only_lcsp_premiums" => [
              {
                "member_identifier" => "21210135",
                "monthly_premium" => "515.41"
              }
            ],
            "health_only_slcsp_premiums" => [
              {
                "member_identifier" => "21210135",
                "monthly_premium" => "522.01"
              }
            ]
          },
          "is_homeless" => false,
          "mitc_income" => {
            "amount" => 0,
            "taxable_interest" => 0,
            "tax_exempt_interest" => 0,
            "taxable_refunds" => 0,
            "alimony" => 0,
            "capital_gain_or_loss" => 0,
            "pensions_and_annuities_taxable_amount" => 0,
            "farm_income_or_loss" => 0,
            "unemployment_compensation" => 0,
            "other_income" => 0,
            "magi_deductions" => 0,
            "adjusted_gross_income" => 43_000,
            "deductible_part_of_self_employment_tax" => 0,
            "ira_deduction" => 0,
            "student_loan_interest_deduction" => 0,
            "tution_and_fees" => 0,
            "other_magi_eligible_income" => 0
          },
          "mitc_relationships" => [],
          "mitc_state_resident" => false,
          "mitc_is_required_to_file_taxes" => true,
          "income_evidence" => {
            "key" => "income",
            "title" => "Income",
            "aasm_state" => "pending",
            "description" => nil,
            "received_at" => "2022-05-12T21:56:23.327+00:00",
            "is_satisfied" => true,
            "verification_outstanding" => false,
            "update_reason" => nil,
            "due_on" => nil,
            "external_service" => nil,
            "updated_by" => nil,
            "verification_histories" => [
              {
                "action" => "application_determined",
                "modifier" => nil,
                "update_reason" => "Requested Hub for verification",
                "updated_by" => "system",
                "is_satisfied" => nil,
                "verification_outstanding" => nil,
                "due_on" => nil,
                "aasm_state" => nil
              }
            ]
          },
          "esi_evidence" => {
            "key" => "esi_mec",
            "title" => "ESI MEC",
            "aasm_state" => "verified",
            "description" => nil,
            "received_at" => "2022-05-12T21:56:23.295+00:00",
            "is_satisfied" => true,
            "verification_outstanding" => false,
            "update_reason" => nil,
            "due_on" => nil,
            "external_service" => nil,
            "updated_by" => nil,
            "verification_histories" => [
              {
                "action" => "application_determined",
                "modifier" => nil,
                "update_reason" => "Requested Hub for verification",
                "updated_by" => "system",
                "is_satisfied" => nil,
                "verification_outstanding" => nil,
                "due_on" => nil,
                "aasm_state" => nil
              }
            ],
            "request_results" => [
              {
                "result" => "attested",
                "source" => "FDSH",
                "source_transaction_id" => "627d8287027a0c01301afbbd",
                "code" => "HE000001",
                "code_description" => nil,
                "raw_payload" => ""
              }
            ]
          },
          "non_esi_evidence" => {
            "key" => "non_esi_mec",
            "title" => "Non ESI MEC",
            "aasm_state" => "verified",
            "description" => nil,
            "received_at" => "2022-05-12T21:56:23.311+00:00",
            "is_satisfied" => true,
            "verification_outstanding" => false,
            "update_reason" => nil,
            "due_on" => nil,
            "external_service" => nil,
            "updated_by" => nil,
            "verification_histories" => [
              {
                "action" => "application_determined",
                "modifier" => nil,
                "update_reason" => "Requested Hub for verification",
                "updated_by" => "system",
                "is_satisfied" => nil,
                "verification_outstanding" => nil,
                "due_on" => nil,
                "aasm_state" => nil
              }
            ],
            "request_results" => [
              {
                "result" => "eligible",
                "source" => "FDSH MEDI",
                "source_transaction_id" => "627d8288027a0c01301afbc1",
                "code" => "HX005001",
                "code_description" => nil,
                "raw_payload" => ""
              },
              {
                "result" => "eligible",
                "source" => "FDSH TRIC",
                "source_transaction_id" => "627d8288027a0c01301afbc1",
                "code" => "HX005001",
                "code_description" => nil,
                "raw_payload" => ""
              },
              {
                "result" => "eligible",
                "source" => "FDSH PECO",
                "source_transaction_id" => "627d8288027a0c01301afbc1",
                "code" => "HE000001",
                "code_description" => nil,
                "raw_payload" => ""
              },
              {
                "result" => "eligible",
                "source" => "FDSH VHPC",
                "source_transaction_id" => "627d8288027a0c01301afbc1",
                "code" => "HX005001",
                "code_description" => nil,
                "raw_payload" => ""
              }
            ]
          },
          "local_mec_evidence" => nil
        }
      ],
      "tax_households" => [
        {
          "max_aptc" => "0.0",
          "hbx_id" => "24557",
          "is_insurance_assistance_eligible" => "UnDetermined",
          "tax_household_members" => [
            {
              "product_eligibility_determination" => {
                "is_ia_eligible" => false,
                "is_medicaid_chip_eligible" => false,
                "is_totally_ineligible" => false,
                "is_magi_medicaid" => false,
                "is_non_magi_medicaid_eligible" => false,
                "is_without_assistance" => false,
                "magi_medicaid_monthly_household_income" => "0.0",
                "medicaid_household_size" => nil,
                "magi_medicaid_monthly_income_limit" => "0.0",
                "magi_as_percentage_of_fpl" => "0.0",
                "magi_medicaid_category" => nil
              },
              "applicant_reference" => {
                "first_name" => "Ana",
                "last_name" => "OCFIVE",
                "dob" => "1974-01-01",
                "person_hbx_id" => "21210135",
                "encrypted_ssn" => "LR9+wP7LJuZmjShsc3zhEoIHufwEK8BNlg==\n"
              }
            }
          ],
          "annual_tax_household_income" => "0.0"
        }
      ],
      "relationships" => [],
      "us_state" => "DC",
      "hbx_id" => "220000538",
      "oe_start_on" => "2021-11-01",
      "notice_options" => {
        "send_eligibility_notices" => true,
        "send_open_enrollment_notices" => false,
        "paper_notification" => true
      },
      "mitc_households" => [
        {
          "household_id" => "1",
          "people" => [
            {
              "person_id" => 21_210_135
            }
          ]
        }
      ],
      "mitc_tax_returns" => [
        {
          "filers" => [
            {
              "person_id" => 21_210_135
            }
          ],
          "dependents" => []
        }
      ],
      "submitted_at" => "2022-05-12T22:05:58.329+00:00",
      "full_medicaid_determination" => false
    }
  end

  let(:application_entity) do
    app_params.deep_symbolize_keys!
    ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
  end

  let(:input_application) do
    application_entity.to_h
  end

  let(:mitc_string_response) do
    {
      'Determination Date': "2022-05-13",
      Applicants: [
        {
          'Person ID': 21_210_135,
          'Medicaid Household': {
            People: [
              21_210_135
            ],
            MAGI: 0,
            'MAGI as Percentage of FPL': 0,
            Size: 1
          },
          'Medicaid Eligible': "N",
          'CHIP Eligible': "N",
          'Ineligibility Reason': [
            "Applicant did not meet residency requirements"
          ],
          'Non-MAGI Referral': "N",
          'CHIP Ineligibility Reason': [
            "Applicant did not meet residency requirements",
            "Applicant did not meet the requirements for any CHIP category"
          ],
          Category: "Adult Group Category",
          'Category Threshold': 29_218,
          'CHIP Category': "None",
          'CHIP Category Threshold': 0,
          Determinations: {
            Residency: {
              Indicator: "N",
              'Ineligibility Code': nil,
              'Ineligibility Reason': nil
            },
            'Adult Group Category': {
              Indicator: "Y"
            },
            'Parent Caretaker Category': {
              Indicator: "N",
              'Ineligibility Code': 146,
              'Ineligibility Reason': "No child met all criteria for parent caretaker category"
            },
            'Pregnancy Category': {
              Indicator: "N",
              'Ineligibility Code': 124,
              'Ineligibility Reason': "Applicant not pregnant or within postpartum period"
            },
            'Child Category': {
              Indicator: "N",
              'Ineligibility Code': 394,
              'Ineligibility Reason': "Applicant is over the age limit for the young adult threshold in the state"
            },
            'Optional Targeted Low Income Child': {
              Indicator: "X"
            },
            'CHIP Targeted Low Income Child': {
              Indicator: "X"
            },
            'Unborn Child': {
              Indicator: "X"
            },
            'Income Medicaid Eligible': {
              Indicator: "Y"
            },
            'Income CHIP Eligible': {
              Indicator: "N",
              'Ineligibility Code': 401,
              'Ineligibility Reason': "Applicant did not meet the requirements for any eligibility category"
            },
            'Medicaid CHIPRA 214': {
              Indicator: "X"
            },
            'CHIP CHIPRA 214': {
              Indicator: "X"
            },
            'Trafficking Victim': {
              Indicator: "X"
            },
            'Seven Year Limit': {
              Indicator: "X"
            },
            'Five Year Bar': {
              Indicator: "X"
            },
            'Title II Work Quarters Met': {
              Indicator: "X"
            },
            'Medicaid Citizen Or Immigrant': {
              Indicator: "Y"
            },
            'CHIP Citizen Or Immigrant': {
              Indicator: "Y"
            },
            'Former Foster Care Category': {
              Indicator: "N",
              'Ineligibility Code': 400,
              'Ineligibility Reason': "Applicant was not formerly in foster care"
            },
            'Work Quarters Override Income': {
              Indicator: "N",
              'Ineligibility Code': 338,
              'Ineligibility Reason': "Applicant did not meet all the criteria for income override rule"
            },
            'State Health Benefits CHIP': {
              Indicator: "X"
            },
            'CHIP Waiting Period Satisfied': {
              Indicator: "X"
            },
            'Dependent Child Covered': {
              Indicator: "X"
            },
            'Medicaid Non-MAGI Referral': {
              Indicator: "N",
              'Ineligibility Code': 108,
              'Ineligibility Reason': "Applicant does not meet requirements for a non-MAGI referral"
            },
            'Emergency Medicaid': {
              Indicator: "N",
              'Ineligibility Code': 109,
              'Ineligibility Reason': "Applicant does not meet the eligibility criteria for emergency Medicaid"
            },
            'Refugee Medical Assistance': {
              Indicator: "X"
            },
            'APTC Referral': {
              Indicator: "Y"
            }
          },
          'Other Outputs': {
            'Qualified Children List': []
          }
        }
      ]
    }
  end

  let(:mitc_response) do
    mitc_string_response.deep_symbolize_keys
  end
end
