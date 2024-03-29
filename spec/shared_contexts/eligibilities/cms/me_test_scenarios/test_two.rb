# frozen_string_literal: true

# rubocop:disable Layout/LineLength
RSpec.shared_context 'cms ME me_test_scenarios test_two', :shared_context => :metadata do
  let(:app_params) do
    {
      "family_reference" => {
        "hbx_id" => "10326"
      }, "assistance_year" => 2021, "aptc_effective_date" => "2021-08-01", "years_to_renew" => nil, "renewal_consent_through_year" => 5, "is_ridp_verified" => true, "is_renewal_authorized" => true, "applicants" => [{
        "name" => {
          "first_name" => "Brenda", "middle_name" => nil, "last_name" => "Testing", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "QEVuQwEAnw+TzjzTW0Gv3NPuCpjmVw==", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Female", "dob" => "2000-01-01", "ethnicity" => [], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false
        },
        "is_primary_applicant" => true,
        "native_american_information" => {
          "indian_tribe_member" => false, "tribal_id" => nil
        },
        "citizenship_immigration_status_information" => {
          "citizen_status" => "alien_lawfully_present", "is_resident_post_092296" => false, "is_lawful_presence_self_attested" => true
        },
        "is_consumer_role" => true,
        "is_resident_role" => false,
        "is_applying_coverage" => true,
        "five_year_bar_applies" => false,
        "five_year_bar_met" => false,
        "qualified_non_citizen" => true,
        "is_consent_applicant" => false,
        "vlp_document" => {
          "subject" => "I-766 (Employment Authorization Card)", "alien_number" => "123456789", "i94_number" => nil, "visa_number" => nil, "passport_number" => nil, "sevis_id" => nil, "naturalization_number" => nil, "receipt_number" => nil, "citizenship_number" => nil, "card_number" => "abd1234567890", "country_of_citizenship" => nil, "expiration_date" => "2023-01-01", "issuing_country" => nil
        },
        "family_member_reference" => {
          "family_member_hbx_id" => "1005120", "first_name" => "Brenda", "last_name" => "Testing", "person_hbx_id" => "1005120", "is_primary_family_member" => true
        },
        "person_hbx_id" => "1005120",
        "is_required_to_file_taxes" => true,
        "tax_filer_kind" => "tax_filer",
        "is_joint_tax_filing" => false,
        "is_claimed_as_tax_dependent" => false,
        "claimed_as_tax_dependent_by" => nil,
        "student" => {
          "is_student" => false, "student_kind" => nil, "student_school_kind" => nil, "student_status_end_on" => nil
        },
        "is_refugee" => false,
        "is_trafficking_victim" => false,
        "foster_care" => {
          "is_former_foster_care" => false, "age_left_foster_care" => nil, "foster_care_us_state" => nil, "had_medicaid_during_foster_care" => false
        },
        "pregnancy_information" => {
          "is_pregnant" => false, "is_enrolled_on_medicaid" => false, "is_post_partum_period" => false, "expected_children_count" => nil, "pregnancy_due_on" => nil, "pregnancy_end_on" => nil
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
        "has_self_employment_income" => true,
        "has_unemployment_income" => false,
        "has_other_income" => false,
        "has_deductions" => false,
        "has_enrolled_health_coverage" => false,
        "has_eligible_health_coverage" => false,
        "job_coverage_ended_in_past_3_months" => false,
        "job_coverage_end_date" => nil,
        "medicaid_and_chip" => {
          "not_eligible_in_last_90_days" => false, "denied_on" => nil, "ended_as_change_in_eligibility" => false, "hh_income_or_size_changed" => false, "medicaid_or_chip_coverage_end_date" => nil, "ineligible_due_to_immigration_in_last_5_years" => false, "immigration_status_changed_since_ineligibility" => false
        },
        "other_health_service" => {
          "has_received" => false, "is_eligible" => false
        },
        "addresses" => [{
          "kind" => "home",
          "address_1" => "123 Testing St",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "Augusta",
          "county" => "Testing",
          "state" => "ME",
          "zip" => "04330",
          "country_name" => nil
        }],
        "emails" => [],
        "phones" => [],
        "incomes" => [{
          "title" => nil,
          "kind" => "net_self_employment",
          "wage_type" => nil,
          "hours_per_week" => nil,
          "amount" => "1160.0",
          "amount_tax_exempt" => "0.0",
          "frequency_kind" => "Monthly",
          "start_on" => "2021-03-01",
          "end_on" => "2021-08-31",
          "is_projected" => false,
          "employer" => nil,
          "has_property_usage_rights" => nil,
          "submitted_at" => "2021-07-09T18:04:10.000+00:00"
        }],
        "benefits" => [],
        "deductions" => [],
        "is_medicare_eligible" => false,
        "has_insurance" => false,
        "has_state_health_benefit" => false,
        "had_prior_insurance" => false,
        "prior_insurance_end_date" => nil,
        "age_of_applicant" => 33,
        "is_self_attested_long_term_care" => false,
        "hours_worked_per_week" => 0,
        "is_temporarily_out_of_state" => false,
        "is_claimed_as_dependent_by_non_applicant" => false,
        "benchmark_premium" => {
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1005120",
            "monthly_premium" => "310.5"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1005120",
            "monthly_premium" => "310.5"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 13_920, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 7017, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [],
        "mitc_is_required_to_file_taxes" => true
      }], "tax_households" => [{
        "max_aptc" => "0.0",
        "hbx_id" => "10705",
        "is_insurance_assistance_eligible" => nil,
        "tax_household_members" => [{
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => true, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "13920.0", "medicaid_household_size" => 1, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "108.0", "magi_medicaid_category" => "adult_group", "is_eligible_for_non_magi_reasons" => false, "chip_ineligibility_reasons" => ["Applicant did not meet the requirements for any CHIP category"], "magi_medicaid_category_threshold" => "17774.0", "medicaid_chip_category" => "None", "medicaid_chip_category_threshold" => "0.0", "category_determinations" => [{
              "category" => "Residency",
              "indicator_code" => true,
              "ineligibility_code" => nil,
              "ineligibility_reason" => nil
            }, {
              "category" => "Adult Group Category",
              "indicator_code" => true,
              "ineligibility_code" => nil,
              "ineligibility_reason" => nil
            }, {
              "category" => "Parent Caretaker Category",
              "indicator_code" => false,
              "ineligibility_code" => 146,
              "ineligibility_reason" => "No child met all criteria for parent caretaker category"
            }, {
              "category" => "Pregnancy Category",
              "indicator_code" => false,
              "ineligibility_code" => 124,
              "ineligibility_reason" => "Applicant not pregnant or within postpartum period"
            }, {
              "category" => "Child Category",
              "indicator_code" => false,
              "ineligibility_code" => 394,
              "ineligibility_reason" => "Applicant is over the age limit for the young adult threshold in the state"
            }, {
              "category" => "Optional Targeted Low Income Child",
              "indicator_code" => nil,
              "ineligibility_code" => nil,
              "ineligibility_reason" => nil
            }, {
              "category" => "CHIP Targeted Low Income Child",
              "indicator_code" => false,
              "ineligibility_code" => 127,
              "ineligibility_reason" => "Applicant's age is not within the allowed age range"
            }, {
              "category" => "Unborn Child",
              "indicator_code" => nil,
              "ineligibility_code" => nil,
              "ineligibility_reason" => nil
            }, {
              "category" => "Income Medicaid Eligible",
              "indicator_code" => true,
              "ineligibility_code" => nil,
              "ineligibility_reason" => nil
            }, {
              "category" => "Income CHIP Eligible",
              "indicator_code" => false,
              "ineligibility_code" => 401,
              "ineligibility_reason" => "Applicant did not meet the requirements for any eligibility category"
            }, {
              "category" => "Medicaid CHIPRA 214",
              "indicator_code" => false,
              "ineligibility_code" => 119,
              "ineligibility_reason" => "Applicant is not a child or pregnant woman"
            }, {
              "category" => "CHIP CHIPRA 214",
              "indicator_code" => false,
              "ineligibility_code" => 118,
              "ineligibility_reason" => "Applicant is not a child"
            }, {
              "category" => "Trafficking Victim",
              "indicator_code" => false,
              "ineligibility_code" => 410,
              "ineligibility_reason" => "Applicant is not a victim of trafficking"
            }, {
              "category" => "Seven Year Limit",
              "indicator_code" => nil,
              "ineligibility_code" => nil,
              "ineligibility_reason" => nil
            }, {
              "category" => "Five Year Bar",
              "indicator_code" => nil,
              "ineligibility_code" => nil,
              "ineligibility_reason" => nil
            }, {
              "category" => "Title II Work Quarters Met",
              "indicator_code" => nil,
              "ineligibility_code" => nil,
              "ineligibility_reason" => nil
            }, {
              "category" => "Medicaid Citizen Or Immigrant",
              "indicator_code" => true,
              "ineligibility_code" => nil,
              "ineligibility_reason" => nil
            }, {
              "category" => "CHIP Citizen Or Immigrant",
              "indicator_code" => true,
              "ineligibility_code" => nil,
              "ineligibility_reason" => nil
            }, {
              "category" => "Former Foster Care Category",
              "indicator_code" => false,
              "ineligibility_code" => 400,
              "ineligibility_reason" => "Applicant was not formerly in foster care"
            }, {
              "category" => "Work Quarters Override Income",
              "indicator_code" => false,
              "ineligibility_code" => 340,
              "ineligibility_reason" => "Income is greater than 100% FPL"
            }, {
              "category" => "State Health Benefits CHIP",
              "indicator_code" => nil,
              "ineligibility_code" => nil,
              "ineligibility_reason" => nil
            }, {
              "category" => "CHIP Waiting Period Satisfied",
              "indicator_code" => nil,
              "ineligibility_code" => nil,
              "ineligibility_reason" => nil
            }, {
              "category" => "Dependent Child Covered",
              "indicator_code" => nil,
              "ineligibility_code" => nil,
              "ineligibility_reason" => nil
            }, {
              "category" => "Medicaid Non-MAGI Referral",
              "indicator_code" => false,
              "ineligibility_code" => 108,
              "ineligibility_reason" => "Applicant does not meet requirements for a non-MAGI referral"
            }, {
              "category" => "Emergency Medicaid",
              "indicator_code" => false,
              "ineligibility_code" => 109,
              "ineligibility_reason" => "Applicant does not meet the eligibility criteria for emergency Medicaid"
            }, {
              "category" => "Refugee Medical Assistance",
              "indicator_code" => nil,
              "ineligibility_code" => nil,
              "ineligibility_reason" => nil
            }, {
              "category" => "APTC Referral",
              "indicator_code" => false,
              "ineligibility_code" => 406,
              "ineligibility_reason" => "Applicant is eligible for Medicaid"
            }]
          },
          "applicant_reference" => {
            "first_name" => "Brenda", "last_name" => "Testing", "dob" => "2000-01-01", "person_hbx_id" => "1005120", "encrypted_ssn" => "QEVuQwEAnw+TzjzTW0Gv3NPuCpjmVw=="
          }
        }],
        "annual_tax_household_income" => "0.0",
        "effective_on" => "2021-08-01",
        "determined_on" => "2021-07-09"
      }], "relationships" => [], "us_state" => "ME", notice_options: {
        send_eligibility_notices: true,
        send_open_enrollment_notices: false
      }, "hbx_id" => "270000174", "oe_start_on" => "2020-11-01", "mitc_households" => [{
        "household_id" => "1",
        "people" => [{
          "person_id" => 1_005_120
        }]
      }], "mitc_tax_returns" => [{
        "filers" => [{
          "person_id" => 1_005_120
        }],
        "dependents" => []
      }]
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
    { "Determination Date" => "2021-07-09", "Applicants" => [{ "Person ID" => 1_005_120, "Medicaid Household" => { "People" => [1_005_120], "MAGI" => 13_920, "MAGI as Percentage of FPL" => 108, "Size" => 1 }, "Medicaid Eligible" => "Y", "CHIP Eligible" => "N", "CHIP Ineligibility Reason" => ["Applicant did not meet the requirements for any CHIP category"], "Category" => "Adult Group Category", "Category Threshold" => 17_774, "CHIP Category" => "None", "CHIP Category Threshold" => 0, "Determinations" => { "Residency" => { "Indicator" => "Y" }, "Adult Group Category" => { "Indicator" => "Y" }, "Parent Caretaker Category" => { "Indicator" => "N", "Ineligibility Code" => 146, "Ineligibility Reason" => "No child met all criteria for parent caretaker category" }, "Pregnancy Category" => { "Indicator" => "N", "Ineligibility Code" => 124, "Ineligibility Reason" => "Applicant not pregnant or within postpartum period" }, "Child Category" => { "Indicator" => "N", "Ineligibility Code" => 394, "Ineligibility Reason" => "Applicant is over the age limit for the young adult threshold in the state" }, "Optional Targeted Low Income Child" => { "Indicator" => "X" }, "CHIP Targeted Low Income Child" => { "Indicator" => "N", "Ineligibility Code" => 127, "Ineligibility Reason" => "Applicant's age is not within the allowed age range" }, "Unborn Child" => { "Indicator" => "X" }, "Income Medicaid Eligible" => { "Indicator" => "Y" }, "Income CHIP Eligible" => { "Indicator" => "N", "Ineligibility Code" => 401, "Ineligibility Reason" => "Applicant did not meet the requirements for any eligibility category" }, "Medicaid CHIPRA 214" => { "Indicator" => "N", "Ineligibility Code" => 119, "Ineligibility Reason" => "Applicant is not a child or pregnant woman" }, "CHIP CHIPRA 214" => { "Indicator" => "N", "Ineligibility Code" => 118, "Ineligibility Reason" => "Applicant is not a child" }, "Trafficking Victim" => { "Indicator" => "N", "Ineligibility Code" => 410, "Ineligibility Reason" => "Applicant is not a victim of trafficking" }, "Seven Year Limit" => { "Indicator" => "X" }, "Five Year Bar" => { "Indicator" => "X" }, "Title II Work Quarters Met" => { "Indicator" => "X" }, "Medicaid Citizen Or Immigrant" => { "Indicator" => "Y" }, "CHIP Citizen Or Immigrant" => { "Indicator" => "Y" }, "Former Foster Care Category" => { "Indicator" => "N", "Ineligibility Code" => 400, "Ineligibility Reason" => "Applicant was not formerly in foster care" }, "Work Quarters Override Income" => { "Indicator" => "N", "Ineligibility Code" => 340, "Ineligibility Reason" => "Income is greater than 100% FPL" }, "State Health Benefits CHIP" => { "Indicator" => "X" }, "CHIP Waiting Period Satisfied" => { "Indicator" => "X" }, "Dependent Child Covered" => { "Indicator" => "X" }, "Medicaid Non-MAGI Referral" => { "Indicator" => "N", "Ineligibility Code" => 108, "Ineligibility Reason" => "Applicant does not meet requirements for a non-MAGI referral" }, "Emergency Medicaid" => { "Indicator" => "N", "Ineligibility Code" => 109, "Ineligibility Reason" => "Applicant does not meet the eligibility criteria for emergency Medicaid" }, "Refugee Medical Assistance" => { "Indicator" => "X" }, "APTC Referral" => { "Indicator" => "N", "Ineligibility Code" => 406, "Ineligibility Reason" => "Applicant is eligible for Medicaid" } }, "Other Outputs" => { "Qualified Children List" => [] } }] }
  end

  let(:mitc_response) do
    mitc_string_response.deep_symbolize_keys
  end
end
# rubocop:enable Layout/LineLength
