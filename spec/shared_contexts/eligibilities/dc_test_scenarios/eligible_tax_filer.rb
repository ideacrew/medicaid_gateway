# frozen_string_literal: true

RSpec.shared_context 'dc_test_scenarios primary_non_tax_filer', :shared_context => :metadata do
  let(:today) { Date.today }
  let(:assistance_year) { today.year.next }
  let(:oe_start_on) { today.beginning_of_month }
  let(:start_of_year) { today.beginning_of_year }
  let(:aptc_effective_date) { Date.new(assistance_year) }

  let(:app_params) do
    {
      "family_reference" => {
        "hbx_id" => "288790"
      },
      "assistance_year" => 2022,
      "aptc_effective_date" => "2022-05-01",
      "years_to_renew" => 2027,
      "renewal_consent_through_year" => 5,
      "is_ridp_verified" => true,
      "is_renewal_authorized" => true,
      "applicants" => [
        {
          "name" => {
            "first_name" => "Mandy",
            "middle_name" => nil,
            "last_name" => "Gomes",
            "name_sfx" => nil,
            "name_pfx" => nil
          },
          "identifying_information" => {
            "encrypted_ssn" => "BJSWbA9eVHNFfIKPA0YnY4YFv/sFKsdHkA==\n",
            "has_ssn" => false
          },
          "demographic" => {
            "gender" => "Female",
            "dob" => "1994-01-28",
            "ethnicity" => [
              "",
              "",
              "",
              "",
              "Other",
              "",
              "",
              "",
              "Cuban"
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
            "citizen_status" => "alien_lawfully_present",
            "is_resident_post_092296" => true,
            "is_lawful_presence_self_attested" => true
          },
          "is_consumer_role" => true,
          "is_resident_role" => false,
          "is_applying_coverage" => true,
          "is_consent_applicant" => false,
          "vlp_document" => {
            "subject" => "I-766 (Employment Authorization Card)",
            "alien_number" => "019889555",
            "i94_number" => nil,
            "visa_number" => nil,
            "passport_number" => nil,
            "sevis_id" => nil,
            "naturalization_number" => nil,
            "receipt_number" => nil,
            "citizenship_number" => nil,
            "card_number" => "MSC2191287111",
            "country_of_citizenship" => nil,
            "expiration_date" => "2023-11-21T00:00:00.000+00:00",
            "issuing_country" => nil
          },
          "family_member_reference" => {
            "family_member_hbx_id" => "123745",
            "first_name" => "Mandy",
            "last_name" => "Gomes",
            "person_hbx_id" => "123745",
            "is_primary_family_member" => true
          },
          "person_hbx_id" => "123745",
          "is_required_to_file_taxes" => false,
          "is_filing_as_head_of_household" => false,
          "tax_filer_kind" => "non_filer",
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
          "has_job_income" => true,
          "has_self_employment_income" => false,
          "has_unemployment_income" => false,
          "has_other_income" => false,
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
              "address_1" => "2440 16th St. NW",
              "address_2" => "414",
              "address_3" => nil,
              "city" => "Washington",
              "county" => nil,
              "state" => "DC",
              "zip" => "20009",
              "country_name" => nil
            }
          ],
          "emails" => [
            {
              "kind" => "home",
              "address" => "gomezMandy23@gmail.com"
            }
          ],
          "phones" => [
            {
              "kind" => "mobile",
              "country_code" => nil,
              "area_code" => "202",
              "number" => "2309809",
              "extension" => nil,
              "primary" => false,
              "full_phone_number" => "2022309809"
            }
          ],
          "incomes" => [
            {
              "title" => nil,
              "kind" => "wages_and_salaries",
              "wage_type" => nil,
              "hours_per_week" => nil,
              "amount" => "65352.0",
              "amount_tax_exempt" => "0.0",
              "frequency_kind" => "Annually",
              "start_on" => "2021-02-01",
              "end_on" => "2022-06-01",
              "is_projected" => false,
              "employer" => {
                "employer_name" => "Inter-American Development Bank",
                "employer_id" => nil
              },
              "has_property_usage_rights" => nil,
              "submitted_at" => "2022-01-06T01:37:48.000+00:00"
            }
          ],
          "benefits" => [],
          "deductions" => [],
          "is_medicare_eligible" => false,
          "has_insurance" => false,
          "has_state_health_benefit" => false,
          "had_prior_insurance" => false,
          "prior_insurance_end_date" => nil,
          "age_of_applicant" => 28,
          "is_self_attested_long_term_care" => false,
          "hours_worked_per_week" => 0,
          "is_temporarily_out_of_state" => false,
          "is_claimed_as_dependent_by_non_applicant" => false,
          "benchmark_premium" => {
            "health_only_lcsp_premiums" => [
              {
                "member_identifier" => "123745",
                "monthly_premium" => "289.41"
              }
            ],
            "health_only_slcsp_premiums" => [
              {
                "member_identifier" => "123745",
                "monthly_premium" => "293.11"
              }
            ]
          },
          "is_homeless" => false,
          "mitc_income" => {
            "amount" => 65_352,
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
            "adjusted_gross_income" => 27_215,
            "deductible_part_of_self_employment_tax" => 0,
            "ira_deduction" => 0,
            "student_loan_interest_deduction" => 0,
            "tution_and_fees" => 0,
            "other_magi_eligible_income" => 0
          },
          "mitc_relationships" => [],
          "mitc_is_required_to_file_taxes" => true,
          "income_evidence" => nil,
          "esi_evidence" => nil,
          "non_esi_evidence" => nil,
          "local_mec_evidence" => nil
        }
      ],
      "tax_households" => [
        {
          "max_aptc" => "0.0",
          "hbx_id" => "24189",
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
                "first_name" => "Mandy",
                "last_name" => "Gomes",
                "dob" => "1994-01-28",
                "person_hbx_id" => "123745",
                "encrypted_ssn" => "BJSWbA9eVHNFfIKPA0YnY4YFv/sFKsdHkA==\n"
              }
            }
          ],
          "annual_tax_household_income" => "0.0"
        }
      ],
      "relationships" => [],
      "us_state" => "DC",
      "hbx_id" => "220000193",
      "oe_start_on" => "2021-11-01",
      "notice_options" => {
        "send_eligibility_notices" => true,
        "send_open_enrollment_notices" => false,
        "paper_notification" => false
      },
      "mitc_households" => [
        {
          "household_id" => "1",
          "people" => [
            {
              "person_id" => 20_206_745
            }
          ]
        }
      ],
      "mitc_tax_returns" => [
        {
          "filers" => [
            {
              "person_id" => 20_206_745
            }
          ],
          "dependents" => []
        }
      ],
      "submitted_at" => "2022-03-22T17:26:21.122+00:00",
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
      "Determination Date" => "2022-03-22",
      "Applicants" => [
        {
          "Person ID" => 20_206_745,
          "Medicaid Household" => {
            "People" => [
              20_206_745
            ],
            "MAGI" => 65_352,
            "MAGI as Percentage of FPL" => 480,
            "Size" => 1
          },
          "Medicaid Eligible" => "N",
          "CHIP Eligible" => "N",
          "Ineligibility Reason" => [
            "Applicant's MAGI above the threshold for category"
          ],
          "Non-MAGI Referral" => "N",
          "CHIP Ineligibility Reason" => [
            "Applicant did not meet the requirements for any CHIP category"
          ],
          "Category" => "Adult Group Category",
          "Category Threshold" => 29_218,
          "CHIP Category" => "None",
          "CHIP Category Threshold" => 0,
          "Determinations" => {
            "Residency" => {
              "Indicator" => "Y"
            },
            "Adult Group Category" => {
              "Indicator" => "Y"
            },
            "Parent Caretaker Category" => {
              "Indicator" => "N",
              "Ineligibility Code" => 146,
              "Ineligibility Reason" => "No child met all criteria for parent caretaker category"
            },
            "Pregnancy Category" => {
              "Indicator" => "N",
              "Ineligibility Code" => 124,
              "Ineligibility Reason" => "Applicant not pregnant or within postpartum period"
            },
            "Child Category" => {
              "Indicator" => "N",
              "Ineligibility Code" => 394,
              "Ineligibility Reason" => "Applicant is over the age limit for the young adult threshold in the state"
            },
            "Optional Targeted Low Income Child" => {
              "Indicator" => "X"
            },
            "CHIP Targeted Low Income Child" => {
              "Indicator" => "X"
            },
            "Unborn Child" => {
              "Indicator" => "X"
            },
            "Income Medicaid Eligible" => {
              "Indicator" => "N",
              "Ineligibility Code" => 402,
              "Ineligibility Reason" => "Applicant's income is greater than the threshold for all eligible categories"
            },
            "Income CHIP Eligible" => {
              "Indicator" => "N",
              "Ineligibility Code" => 401,
              "Ineligibility Reason" => "Applicant did not meet the requirements for any eligibility category"
            },
            "Medicaid CHIPRA 214" => {
              "Indicator" => "N",
              "Ineligibility Code" => 119,
              "Ineligibility Reason" => "Applicant is not a child or pregnant woman"
            },
            "CHIP CHIPRA 214" => {
              "Indicator" => "X"
            },
            "Trafficking Victim" => {
              "Indicator" => "N",
              "Ineligibility Code" => 410,
              "Ineligibility Reason" => "Applicant is not a victim of trafficking"
            },
            "Seven Year Limit" => {
              "Indicator" => "X"
            },
            "Five Year Bar" => {
              "Indicator" => "X"
            },
            "Title II Work Quarters Met" => {
              "Indicator" => "X"
            },
            "Medicaid Citizen Or Immigrant" => {
              "Indicator" => "Y"
            },
            "CHIP Citizen Or Immigrant" => {
              "Indicator" => "Y"
            },
            "Former Foster Care Category" => {
              "Indicator" => "N",
              "Ineligibility Code" => 400,
              "Ineligibility Reason" => "Applicant was not formerly in foster care"
            },
            "Work Quarters Override Income" => {
              "Indicator" => "N",
              "Ineligibility Code" => 340,
              "Ineligibility Reason" => "Income is greater than 100% FPL"
            },
            "State Health Benefits CHIP" => {
              "Indicator" => "X"
            },
            "CHIP Waiting Period Satisfied" => {
              "Indicator" => "X"
            },
            "Dependent Child Covered" => {
              "Indicator" => "X"
            },
            "Medicaid Non-MAGI Referral" => {
              "Indicator" => "N",
              "Ineligibility Code" => 108,
              "Ineligibility Reason" => "Applicant does not meet requirements for a non-MAGI referral"
            },
            "Emergency Medicaid" => {
              "Indicator" => "N",
              "Ineligibility Code" => 109,
              "Ineligibility Reason" => "Applicant does not meet the eligibility criteria for emergency Medicaid"
            },
            "Refugee Medical Assistance" => {
              "Indicator" => "X"
            },
            "APTC Referral" => {
              "Indicator" => "Y"
            }
          },
          "Other Outputs" => {
            "Qualified Children List" => []
          }
        }
      ]
    }
  end

  let(:mitc_response) do
    mitc_string_response.deep_symbolize_keys
  end
end
