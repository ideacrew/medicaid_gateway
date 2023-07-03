# frozen_string_literal: true

RSpec.shared_context 'totally_ineligible incarcerated_medicaid_ineligible', :shared_context => :metadata do
  let(:today) { Date.today }
  let(:assistance_year) { today.year.next }
  let(:oe_start_on) { today.beginning_of_month }
  let(:start_of_year) { today.beginning_of_year }
  let(:aptc_effective_date) { Date.new(assistance_year) }

  let(:app_params) do
    {
      "family_reference" => {
        "hbx_id" => "200203687"
      },
      "assistance_year" => assistance_year,
      "aptc_effective_date" => aptc_effective_date,
      "years_to_renew" => assistance_year + 5,
      "renewal_consent_through_year" => 5,
      "is_ridp_verified" => true,
      "is_renewal_authorized" => true,
      "applicants" => [
        {
          "name" => {
            "first_name" => "Burt",
            "middle_name" => nil,
            "last_name" => "Bees",
            "name_sfx" => nil,
            "name_pfx" => nil
          },
          "identifying_information" => {
            "encrypted_ssn" => "D5Y4Wexh55TGQ3dUJcXP/MsdVrXZzP3e+w==\n",
            "has_ssn" => true
          },
          "demographic" => {
            "gender" => "Male",
            "dob" => "1990-01-01",
            "ethnicity" => [],
            "race" => nil,
            "is_veteran_or_active_military" => false,
            "is_vets_spouse_or_child" => false
          },
          "attestation" => {
            "is_incarcerated" => true,
            "is_self_attested_disabled" => false,
            "is_self_attested_blind" => false,
            "is_self_attested_long_term_care" => false
          },
          "is_primary_applicant" => true,
          "native_american_information" => {
            "indian_tribe_member" => false,
            "tribal_name" => nil,
            "tribal_state" => nil
          },
          "citizenship_immigration_status_information" => {
            "citizen_status" => "us_citizen",
            "is_resident_post_092296" => nil,
            "is_lawful_presence_self_attested" => false
          },
          "is_consumer_role" => true,
          "is_resident_role" => false,
          "is_applying_coverage" => true,
          "five_year_bar_applies" => false,
          "five_year_bar_met" => false,
          "qualified_non_citizen" => false,
          "is_consent_applicant" => false,
          "vlp_document" => nil,
          "family_member_reference" => {
            "family_member_hbx_id" => "200203686",
            "first_name" => "Burt",
            "last_name" => "Bees",
            "person_hbx_id" => "200203686",
            "is_primary_family_member" => true
          },
          "person_hbx_id" => "200203686",
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
          "is_primary_caregiver" => false,
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
              "address_1" => "123 Fake St",
              "address_2" => nil,
              "address_3" => nil,
              "city" => "Augusta",
              "county" => "York",
              "state" => "ME",
              "zip" => "04005",
              "country_name" => nil
            }
          ],
          "emails" => [],
          "phones" => [],
          "incomes" => [
            {
              "title" => nil,
              "kind" => "net_self_employment",
              "wage_type" => nil,
              "hours_per_week" => nil,
              "amount" => "150000.0",
              "amount_tax_exempt" => "0.0",
              "frequency_kind" => "Annually",
              "start_on" => "2023-01-01",
              "end_on" => nil,
              "is_projected" => false,
              "employer" => nil,
              "has_property_usage_rights" => nil,
              "ssi_type" => nil,
              "submitted_at" => "2023-06-28T19:56:06.000+00:00"
            }
          ],
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
            "health_only_lcsp_premiums" => [
              {
                "member_identifier" => "200203686",
                "monthly_premium" => "391.76"
              }
            ],
            "health_only_slcsp_premiums" => [
              {
                "member_identifier" => "200203686",
                "monthly_premium" => "399.69"
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
            "other_income" => 150_000,
            "magi_deductions" => 0,
            "adjusted_gross_income" => 150_000,
            "deductible_part_of_self_employment_tax" => 0,
            "ira_deduction" => 0,
            "student_loan_interest_deduction" => 0,
            "tution_and_fees" => 0,
            "other_magi_eligible_income" => 0
          },
          "mitc_relationships" => [],
          "mitc_state_resident" => true,
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
          "hbx_id" => "201561",
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
                "first_name" => "Burt",
                "last_name" => "Bees",
                "dob" => "1990-01-01",
                "person_hbx_id" => "200203686",
                "encrypted_ssn" => "D5Y4Wexh55TGQ3dUJcXP/MsdVrXZzP3e+w==\n"
              }
            }
          ],
          "annual_tax_household_income" => "0.0",
          "effective_on" => nil,
          "determined_on" => nil,
          "yearly_expected_contribution" => "0.0"
        }
      ],
      "relationships" => [],
      "us_state" => "ME",
      "hbx_id" => "200202800",
      "oe_start_on" => "2022-11-01",
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
              "person_id" => 200_203_686
            }
          ]
        }
      ],
      "mitc_tax_returns" => [
        {
          "filers" => [
            {
              "person_id" => 200_203_686
            }
          ],
          "dependents" => []
        }
      ],
      "submitted_at" => start_of_year.to_s
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
      "Determination Date" => start_of_year.to_s,
      "Applicants" => [
        {
          "Person ID" => 200_203_686,
          "Medicaid Household" => {
            "People" => [
              200_203_686
            ],
            "MAGI" => 150_000,
            "MAGI as Percentage of FPL" => 1028,
            "Size" => 1
          },
          "Medicaid Eligible" => "N",
          "CHIP Eligible" => "N",
          "Ineligibility Reason" => [
            "Applicant's MAGI above the threshold for category"
          ],
          "Non-MAGI Referral" => "N",
          "CHIP Ineligibility Reason" => [
            "Applicant did not meet the requirements for any CHIP category",
            "Applicant is incarcerated"
          ],
          "Category" => "Adult Group Category",
          "Category Threshold" => 20_120,
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
              "Indicator" => "N",
              "Ineligibility Code" => 127,
              "Ineligibility Reason" => "Applicant's age is not within the allowed age range"
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
              "Indicator" => "X"
            },
            "CHIP CHIPRA 214" => {
              "Indicator" => "X"
            },
            "Trafficking Victim" => {
              "Indicator" => "X"
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
