# frozen_string_literal: true

RSpec.shared_context 'dc_test_scenarios qa_core_4_magi_ua_009', :shared_context => :metadata do
  let(:today) { Date.today }
  let(:assistance_year) { today.year.next }
  let(:oe_start_on) { today.beginning_of_month }
  let(:start_of_year) { today.beginning_of_year }
  let(:aptc_effective_date) { Date.new(assistance_year) }

  let(:app_params) do
    {
      "family_reference" => {
        "hbx_id" => "291115"
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
            "first_name" => "John",
            "middle_name" => nil,
            "last_name" => "PR",
            "name_sfx" => nil,
            "name_pfx" => nil
          },
          "identifying_information" => {
            "encrypted_ssn" => "8mktCZyO/kqA5zichYun7oMKu/wHKMRIkw==\n",
            "has_ssn" => false
          },
          "demographic" => {
            "gender" => "Male",
            "dob" => "1985-01-01",
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
            "family_member_hbx_id" => "21210282",
            "first_name" => "John",
            "last_name" => "PR",
            "person_hbx_id" => "21210282",
            "is_primary_family_member" => true
          },
          "person_hbx_id" => "21210282",
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
              "address_1" => "0419 ABC",
              "address_2" => nil,
              "address_3" => nil,
              "city" => "Washington",
              "county" => nil,
              "state" => "DC",
              "zip" => "20000",
              "country_name" => nil
            }
          ],
          "emails" => [],
          "phones" => [],
          "incomes" => [
            {
              "title" => nil,
              "kind" => "dividend",
              "wage_type" => nil,
              "hours_per_week" => nil,
              "amount" => "25713.52",
              "amount_tax_exempt" => "0.0",
              "frequency_kind" => "Annually",
              "start_on" => "2019-01-01",
              "end_on" => nil,
              "is_projected" => false,
              "employer" => nil,
              "has_property_usage_rights" => nil,
              "submitted_at" => "2022-04-19T13:11:11.000+00:00"
            }
          ],
          "benefits" => [],
          "deductions" => [],
          "is_medicare_eligible" => false,
          "has_insurance" => false,
          "has_state_health_benefit" => false,
          "had_prior_insurance" => false,
          "prior_insurance_end_date" => nil,
          "age_of_applicant" => 37,
          "is_self_attested_long_term_care" => false,
          "hours_worked_per_week" => 0,
          "is_temporarily_out_of_state" => false,
          "is_claimed_as_dependent_by_non_applicant" => false,
          "benchmark_premium" => {
            "health_only_lcsp_premiums" => [
              {
                "member_identifier" => "21210282",
                "monthly_premium" => "356.32"
              },
              {
                "member_identifier" => "21210283",
                "monthly_premium" => "340.75"
              },
              {
                "member_identifier" => "21210284",
                "monthly_premium" => "254.4"
              },
              {
                "member_identifier" => "21210285",
                "monthly_premium" => "254.4"
              }
            ],
            "health_only_slcsp_premiums" => [
              {
                "member_identifier" => "21210282",
                "monthly_premium" => "360.87"
              },
              {
                "member_identifier" => "21210283",
                "monthly_premium" => "345.11"
              },
              {
                "member_identifier" => "21210284",
                "monthly_premium" => "257.65"
              },
              {
                "member_identifier" => "21210285",
                "monthly_premium" => "257.65"
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
            "other_income" => 25_713,
            "magi_deductions" => 0,
            "adjusted_gross_income" => 25_713,
            "deductible_part_of_self_employment_tax" => 0,
            "ira_deduction" => 0,
            "student_loan_interest_deduction" => 0,
            "tution_and_fees" => 0,
            "other_magi_eligible_income" => 0
          },
          "mitc_relationships" => [
            {
              "other_id" => 21_210_283,
              "attest_primary_responsibility" => "Y",
              "relationship_code" => "02"
            },
            {
              "other_id" => 21_210_284,
              "attest_primary_responsibility" => "Y",
              "relationship_code" => "03"
            },
            {
              "other_id" => 21_210_285,
              "attest_primary_responsibility" => "Y",
              "relationship_code" => "03"
            }
          ],
          "mitc_state_resident" => true,
          "mitc_is_required_to_file_taxes" => true,
          "income_evidence" => nil,
          "esi_evidence" => nil,
          "non_esi_evidence" => nil,
          "local_mec_evidence" => nil
        },
        {
          "name" => {
            "first_name" => "Marry",
            "middle_name" => nil,
            "last_name" => "PR",
            "name_sfx" => nil,
            "name_pfx" => nil
          },
          "identifying_information" => {
            "encrypted_ssn" => "t+JuFT1brrEwRtiqmgF+yoMEu/0HKMRIkw==\n",
            "has_ssn" => false
          },
          "demographic" => {
            "gender" => "Female",
            "dob" => "1987-01-01",
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
          "is_primary_applicant" => false,
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
            "family_member_hbx_id" => "21210283",
            "first_name" => "Marry",
            "last_name" => "PR",
            "person_hbx_id" => "21210283",
            "is_primary_family_member" => false
          },
          "person_hbx_id" => "21210283",
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
              "address_1" => "0419 ABC",
              "address_2" => nil,
              "address_3" => nil,
              "city" => "Washington",
              "county" => nil,
              "state" => "DC",
              "zip" => "20000",
              "country_name" => nil
            }
          ],
          "emails" => [],
          "phones" => [],
          "incomes" => [
            {
              "title" => nil,
              "kind" => "interest",
              "wage_type" => nil,
              "hours_per_week" => nil,
              "amount" => "25355.18",
              "amount_tax_exempt" => "0.0",
              "frequency_kind" => "Annually",
              "start_on" => "2019-01-01",
              "end_on" => nil,
              "is_projected" => false,
              "employer" => nil,
              "has_property_usage_rights" => nil,
              "submitted_at" => "2022-04-19T13:13:00.000+00:00"
            }
          ],
          "benefits" => [],
          "deductions" => [],
          "is_medicare_eligible" => false,
          "has_insurance" => false,
          "has_state_health_benefit" => false,
          "had_prior_insurance" => false,
          "prior_insurance_end_date" => nil,
          "age_of_applicant" => 35,
          "is_self_attested_long_term_care" => false,
          "hours_worked_per_week" => 0,
          "is_temporarily_out_of_state" => false,
          "is_claimed_as_dependent_by_non_applicant" => false,
          "benchmark_premium" => {
            "health_only_lcsp_premiums" => [
              {
                "member_identifier" => "21210282",
                "monthly_premium" => "356.32"
              },
              {
                "member_identifier" => "21210283",
                "monthly_premium" => "340.75"
              },
              {
                "member_identifier" => "21210284",
                "monthly_premium" => "254.4"
              },
              {
                "member_identifier" => "21210285",
                "monthly_premium" => "254.4"
              }
            ],
            "health_only_slcsp_premiums" => [
              {
                "member_identifier" => "21210282",
                "monthly_premium" => "360.87"
              },
              {
                "member_identifier" => "21210283",
                "monthly_premium" => "345.11"
              },
              {
                "member_identifier" => "21210284",
                "monthly_premium" => "257.65"
              },
              {
                "member_identifier" => "21210285",
                "monthly_premium" => "257.65"
              }
            ]
          },
          "is_homeless" => false,
          "mitc_income" => {
            "amount" => 0,
            "taxable_interest" => 25_355,
            "tax_exempt_interest" => 0,
            "taxable_refunds" => 0,
            "alimony" => 0,
            "capital_gain_or_loss" => 0,
            "pensions_and_annuities_taxable_amount" => 0,
            "farm_income_or_loss" => 0,
            "unemployment_compensation" => 0,
            "other_income" => 0,
            "magi_deductions" => 0,
            "adjusted_gross_income" => 25_355,
            "deductible_part_of_self_employment_tax" => 0,
            "ira_deduction" => 0,
            "student_loan_interest_deduction" => 0,
            "tution_and_fees" => 0,
            "other_magi_eligible_income" => 0
          },
          "mitc_relationships" => [
            {
              "other_id" => 21_210_282,
              "attest_primary_responsibility" => "N",
              "relationship_code" => "02"
            },
            {
              "other_id" => 21_210_284,
              "attest_primary_responsibility" => "N",
              "relationship_code" => "03"
            },
            {
              "other_id" => 21_210_285,
              "attest_primary_responsibility" => "N",
              "relationship_code" => "03"
            }
          ],
          "mitc_state_resident" => true,
          "mitc_is_required_to_file_taxes" => true,
          "income_evidence" => nil,
          "esi_evidence" => nil,
          "non_esi_evidence" => nil,
          "local_mec_evidence" => nil
        },
        {
          "name" => {
            "first_name" => "nina",
            "middle_name" => nil,
            "last_name" => "PR",
            "name_sfx" => nil,
            "name_pfx" => nil
          },
          "identifying_information" => {
            "encrypted_ssn" => "/L3aPK6cbdtvLLzkXgA6C4MLu/4EL8lKkw==\n",
            "has_ssn" => false
          },
          "demographic" => {
            "gender" => "Female",
            "dob" => "2005-01-01",
            "ethnicity" => [],
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
          "is_primary_applicant" => false,
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
            "family_member_hbx_id" => "21210284",
            "first_name" => "nina",
            "last_name" => "PR",
            "person_hbx_id" => "21210284",
            "is_primary_family_member" => false
          },
          "person_hbx_id" => "21210284",
          "is_required_to_file_taxes" => false,
          "is_filing_as_head_of_household" => false,
          "tax_filer_kind" => "dependent",
          "is_joint_tax_filing" => false,
          "is_claimed_as_tax_dependent" => true,
          "claimed_as_tax_dependent_by" => {
            "first_name" => "John",
            "last_name" => "PR",
            "dob" => "1985-01-01",
            "person_hbx_id" => "21210282",
            "encrypted_ssn" => "8mktCZyO/kqA5zichYun7oMKu/wHKMRIkw==\n"
          },
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
              "address_1" => "2995 L",
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
              "kind" => "interest",
              "wage_type" => nil,
              "hours_per_week" => nil,
              "amount" => "25000.0",
              "amount_tax_exempt" => "0.0",
              "frequency_kind" => "Annually",
              "start_on" => "2019-01-01",
              "end_on" => nil,
              "is_projected" => false,
              "employer" => nil,
              "has_property_usage_rights" => nil,
              "submitted_at" => "2022-04-19T13:14:01.000+00:00"
            }
          ],
          "benefits" => [],
          "deductions" => [],
          "is_medicare_eligible" => false,
          "has_insurance" => false,
          "has_state_health_benefit" => false,
          "had_prior_insurance" => false,
          "prior_insurance_end_date" => nil,
          "age_of_applicant" => 17,
          "is_self_attested_long_term_care" => false,
          "hours_worked_per_week" => 0,
          "is_temporarily_out_of_state" => false,
          "is_claimed_as_dependent_by_non_applicant" => false,
          "benchmark_premium" => {
            "health_only_lcsp_premiums" => [
              {
                "member_identifier" => "21210282",
                "monthly_premium" => "356.32"
              },
              {
                "member_identifier" => "21210283",
                "monthly_premium" => "340.75"
              },
              {
                "member_identifier" => "21210284",
                "monthly_premium" => "254.4"
              },
              {
                "member_identifier" => "21210285",
                "monthly_premium" => "254.4"
              }
            ],
            "health_only_slcsp_premiums" => [
              {
                "member_identifier" => "21210282",
                "monthly_premium" => "360.87"
              },
              {
                "member_identifier" => "21210283",
                "monthly_premium" => "345.11"
              },
              {
                "member_identifier" => "21210284",
                "monthly_premium" => "257.65"
              },
              {
                "member_identifier" => "21210285",
                "monthly_premium" => "257.65"
              }
            ]
          },
          "is_homeless" => false,
          "mitc_income" => {
            "amount" => 0,
            "taxable_interest" => 25_000,
            "tax_exempt_interest" => 0,
            "taxable_refunds" => 0,
            "alimony" => 0,
            "capital_gain_or_loss" => 0,
            "pensions_and_annuities_taxable_amount" => 0,
            "farm_income_or_loss" => 0,
            "unemployment_compensation" => 0,
            "other_income" => 0,
            "magi_deductions" => 0,
            "adjusted_gross_income" => 25_000,
            "deductible_part_of_self_employment_tax" => 0,
            "ira_deduction" => 0,
            "student_loan_interest_deduction" => 0,
            "tution_and_fees" => 0,
            "other_magi_eligible_income" => 0
          },
          "mitc_relationships" => [
            {
              "other_id" => 21_210_282,
              "attest_primary_responsibility" => "N",
              "relationship_code" => "04"
            },
            {
              "other_id" => 21_210_285,
              "attest_primary_responsibility" => "N",
              "relationship_code" => "07"
            },
            {
              "other_id" => 21_210_283,
              "attest_primary_responsibility" => "N",
              "relationship_code" => "04"
            }
          ],
          "mitc_state_resident" => false,
          "mitc_is_required_to_file_taxes" => true,
          "income_evidence" => nil,
          "esi_evidence" => nil,
          "non_esi_evidence" => nil,
          "local_mec_evidence" => nil
        },
        {
          "name" => {
            "first_name" => "Sarah",
            "middle_name" => nil,
            "last_name" => "PR",
            "name_sfx" => nil,
            "name_pfx" => nil
          },
          "identifying_information" => {
            "encrypted_ssn" => "wQpQaPUZbVWebL2tK0L0eYMHvPoHKMRLkw==\n",
            "has_ssn" => false
          },
          "demographic" => {
            "gender" => "Female",
            "dob" => "2012-01-01",
            "ethnicity" => [],
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
          "is_primary_applicant" => false,
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
            "family_member_hbx_id" => "21210285",
            "first_name" => "Sarah",
            "last_name" => "PR",
            "person_hbx_id" => "21210285",
            "is_primary_family_member" => false
          },
          "person_hbx_id" => "21210285",
          "is_required_to_file_taxes" => false,
          "is_filing_as_head_of_household" => false,
          "tax_filer_kind" => "dependent",
          "is_joint_tax_filing" => false,
          "is_claimed_as_tax_dependent" => true,
          "claimed_as_tax_dependent_by" => {
            "first_name" => "Marry",
            "last_name" => "PR",
            "dob" => "1987-01-01",
            "person_hbx_id" => "21210283",
            "encrypted_ssn" => "t+JuFT1brrEwRtiqmgF+yoMEu/0HKMRIkw==\n"
          },
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
              "address_1" => "0419 ABC",
              "address_2" => nil,
              "address_3" => nil,
              "city" => "Washington",
              "county" => nil,
              "state" => "DC",
              "zip" => "20000",
              "country_name" => nil
            }
          ],
          "emails" => [],
          "phones" => [],
          "incomes" => [],
          "benefits" => [],
          "deductions" => [],
          "is_medicare_eligible" => false,
          "has_insurance" => false,
          "has_state_health_benefit" => false,
          "had_prior_insurance" => false,
          "prior_insurance_end_date" => nil,
          "age_of_applicant" => 10,
          "is_self_attested_long_term_care" => false,
          "hours_worked_per_week" => 0,
          "is_temporarily_out_of_state" => false,
          "is_claimed_as_dependent_by_non_applicant" => false,
          "benchmark_premium" => {
            "health_only_lcsp_premiums" => [
              {
                "member_identifier" => "21210282",
                "monthly_premium" => "356.32"
              },
              {
                "member_identifier" => "21210283",
                "monthly_premium" => "340.75"
              },
              {
                "member_identifier" => "21210284",
                "monthly_premium" => "254.4"
              },
              {
                "member_identifier" => "21210285",
                "monthly_premium" => "254.4"
              }
            ],
            "health_only_slcsp_premiums" => [
              {
                "member_identifier" => "21210282",
                "monthly_premium" => "360.87"
              },
              {
                "member_identifier" => "21210283",
                "monthly_premium" => "345.11"
              },
              {
                "member_identifier" => "21210284",
                "monthly_premium" => "257.65"
              },
              {
                "member_identifier" => "21210285",
                "monthly_premium" => "257.65"
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
            "adjusted_gross_income" => 0,
            "deductible_part_of_self_employment_tax" => 0,
            "ira_deduction" => 0,
            "student_loan_interest_deduction" => 0,
            "tution_and_fees" => 0,
            "other_magi_eligible_income" => 0
          },
          "mitc_relationships" => [
            {
              "other_id" => 21_210_282,
              "attest_primary_responsibility" => "N",
              "relationship_code" => "04"
            },
            {
              "other_id" => 21_210_284,
              "attest_primary_responsibility" => "N",
              "relationship_code" => "07"
            },
            {
              "other_id" => 21_210_283,
              "attest_primary_responsibility" => "N",
              "relationship_code" => "04"
            }
          ],
          "mitc_state_resident" => true,
          "mitc_is_required_to_file_taxes" => false,
          "income_evidence" => nil,
          "esi_evidence" => nil,
          "non_esi_evidence" => nil,
          "local_mec_evidence" => nil
        }
      ],
      "tax_households" => [
        {
          "max_aptc" => "0.0",
          "hbx_id" => "24384",
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
                "first_name" => "John",
                "last_name" => "PR",
                "dob" => "1985-01-01",
                "person_hbx_id" => "21210282",
                "encrypted_ssn" => "8mktCZyO/kqA5zichYun7oMKu/wHKMRIkw==\n"
              }
            },
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
                "first_name" => "nina",
                "last_name" => "PR",
                "dob" => "2005-01-01",
                "person_hbx_id" => "21210284",
                "encrypted_ssn" => "/L3aPK6cbdtvLLzkXgA6C4MLu/4EL8lKkw==\n"
              }
            }
          ],
          "annual_tax_household_income" => "0.0"
        },
        {
          "max_aptc" => "0.0",
          "hbx_id" => "24385",
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
                "first_name" => "Marry",
                "last_name" => "PR",
                "dob" => "1987-01-01",
                "person_hbx_id" => "21210283",
                "encrypted_ssn" => "t+JuFT1brrEwRtiqmgF+yoMEu/0HKMRIkw==\n"
              }
            },
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
                "first_name" => "Sarah",
                "last_name" => "PR",
                "dob" => "2012-01-01",
                "person_hbx_id" => "21210285",
                "encrypted_ssn" => "wQpQaPUZbVWebL2tK0L0eYMHvPoHKMRLkw==\n"
              }
            }
          ],
          "annual_tax_household_income" => "0.0"
        }
      ],
      "relationships" => [
        {
          "kind" => "spouse",
          "applicant_reference" => {
            "first_name" => "Marry",
            "last_name" => "PR",
            "dob" => "1987-01-01",
            "person_hbx_id" => "21210283",
            "encrypted_ssn" => "t+JuFT1brrEwRtiqmgF+yoMEu/0HKMRIkw==\n"
          },
          "relative_reference" => {
            "first_name" => "John",
            "last_name" => "PR",
            "dob" => "1985-01-01",
            "person_hbx_id" => "21210282",
            "encrypted_ssn" => "8mktCZyO/kqA5zichYun7oMKu/wHKMRIkw==\n"
          }
        },
        {
          "kind" => "spouse",
          "applicant_reference" => {
            "first_name" => "John",
            "last_name" => "PR",
            "dob" => "1985-01-01",
            "person_hbx_id" => "21210282",
            "encrypted_ssn" => "8mktCZyO/kqA5zichYun7oMKu/wHKMRIkw==\n"
          },
          "relative_reference" => {
            "first_name" => "Marry",
            "last_name" => "PR",
            "dob" => "1987-01-01",
            "person_hbx_id" => "21210283",
            "encrypted_ssn" => "t+JuFT1brrEwRtiqmgF+yoMEu/0HKMRIkw==\n"
          }
        },
        {
          "kind" => "child",
          "applicant_reference" => {
            "first_name" => "nina",
            "last_name" => "PR",
            "dob" => "2005-01-01",
            "person_hbx_id" => "21210284",
            "encrypted_ssn" => "/L3aPK6cbdtvLLzkXgA6C4MLu/4EL8lKkw==\n"
          },
          "relative_reference" => {
            "first_name" => "John",
            "last_name" => "PR",
            "dob" => "1985-01-01",
            "person_hbx_id" => "21210282",
            "encrypted_ssn" => "8mktCZyO/kqA5zichYun7oMKu/wHKMRIkw==\n"
          }
        },
        {
          "kind" => "parent",
          "applicant_reference" => {
            "first_name" => "John",
            "last_name" => "PR",
            "dob" => "1985-01-01",
            "person_hbx_id" => "21210282",
            "encrypted_ssn" => "8mktCZyO/kqA5zichYun7oMKu/wHKMRIkw==\n"
          },
          "relative_reference" => {
            "first_name" => "nina",
            "last_name" => "PR",
            "dob" => "2005-01-01",
            "person_hbx_id" => "21210284",
            "encrypted_ssn" => "/L3aPK6cbdtvLLzkXgA6C4MLu/4EL8lKkw==\n"
          }
        },
        {
          "kind" => "child",
          "applicant_reference" => {
            "first_name" => "Sarah",
            "last_name" => "PR",
            "dob" => "2012-01-01",
            "person_hbx_id" => "21210285",
            "encrypted_ssn" => "wQpQaPUZbVWebL2tK0L0eYMHvPoHKMRLkw==\n"
          },
          "relative_reference" => {
            "first_name" => "John",
            "last_name" => "PR",
            "dob" => "1985-01-01",
            "person_hbx_id" => "21210282",
            "encrypted_ssn" => "8mktCZyO/kqA5zichYun7oMKu/wHKMRIkw==\n"
          }
        },
        {
          "kind" => "parent",
          "applicant_reference" => {
            "first_name" => "John",
            "last_name" => "PR",
            "dob" => "1985-01-01",
            "person_hbx_id" => "21210282",
            "encrypted_ssn" => "8mktCZyO/kqA5zichYun7oMKu/wHKMRIkw==\n"
          },
          "relative_reference" => {
            "first_name" => "Sarah",
            "last_name" => "PR",
            "dob" => "2012-01-01",
            "person_hbx_id" => "21210285",
            "encrypted_ssn" => "wQpQaPUZbVWebL2tK0L0eYMHvPoHKMRLkw==\n"
          }
        },
        {
          "kind" => "sibling",
          "applicant_reference" => {
            "first_name" => "nina",
            "last_name" => "PR",
            "dob" => "2005-01-01",
            "person_hbx_id" => "21210284",
            "encrypted_ssn" => "/L3aPK6cbdtvLLzkXgA6C4MLu/4EL8lKkw==\n"
          },
          "relative_reference" => {
            "first_name" => "Sarah",
            "last_name" => "PR",
            "dob" => "2012-01-01",
            "person_hbx_id" => "21210285",
            "encrypted_ssn" => "wQpQaPUZbVWebL2tK0L0eYMHvPoHKMRLkw==\n"
          }
        },
        {
          "kind" => "sibling",
          "applicant_reference" => {
            "first_name" => "Sarah",
            "last_name" => "PR",
            "dob" => "2012-01-01",
            "person_hbx_id" => "21210285",
            "encrypted_ssn" => "wQpQaPUZbVWebL2tK0L0eYMHvPoHKMRLkw==\n"
          },
          "relative_reference" => {
            "first_name" => "nina",
            "last_name" => "PR",
            "dob" => "2005-01-01",
            "person_hbx_id" => "21210284",
            "encrypted_ssn" => "/L3aPK6cbdtvLLzkXgA6C4MLu/4EL8lKkw==\n"
          }
        },
        {
          "kind" => "parent",
          "applicant_reference" => {
            "first_name" => "Marry",
            "last_name" => "PR",
            "dob" => "1987-01-01",
            "person_hbx_id" => "21210283",
            "encrypted_ssn" => "t+JuFT1brrEwRtiqmgF+yoMEu/0HKMRIkw==\n"
          },
          "relative_reference" => {
            "first_name" => "nina",
            "last_name" => "PR",
            "dob" => "2005-01-01",
            "person_hbx_id" => "21210284",
            "encrypted_ssn" => "/L3aPK6cbdtvLLzkXgA6C4MLu/4EL8lKkw==\n"
          }
        },
        {
          "kind" => "child",
          "applicant_reference" => {
            "first_name" => "nina",
            "last_name" => "PR",
            "dob" => "2005-01-01",
            "person_hbx_id" => "21210284",
            "encrypted_ssn" => "/L3aPK6cbdtvLLzkXgA6C4MLu/4EL8lKkw==\n"
          },
          "relative_reference" => {
            "first_name" => "Marry",
            "last_name" => "PR",
            "dob" => "1987-01-01",
            "person_hbx_id" => "21210283",
            "encrypted_ssn" => "t+JuFT1brrEwRtiqmgF+yoMEu/0HKMRIkw==\n"
          }
        },
        {
          "kind" => "parent",
          "applicant_reference" => {
            "first_name" => "Marry",
            "last_name" => "PR",
            "dob" => "1987-01-01",
            "person_hbx_id" => "21210283",
            "encrypted_ssn" => "t+JuFT1brrEwRtiqmgF+yoMEu/0HKMRIkw==\n"
          },
          "relative_reference" => {
            "first_name" => "Sarah",
            "last_name" => "PR",
            "dob" => "2012-01-01",
            "person_hbx_id" => "21210285",
            "encrypted_ssn" => "wQpQaPUZbVWebL2tK0L0eYMHvPoHKMRLkw==\n"
          }
        },
        {
          "kind" => "child",
          "applicant_reference" => {
            "first_name" => "Sarah",
            "last_name" => "PR",
            "dob" => "2012-01-01",
            "person_hbx_id" => "21210285",
            "encrypted_ssn" => "wQpQaPUZbVWebL2tK0L0eYMHvPoHKMRLkw==\n"
          },
          "relative_reference" => {
            "first_name" => "Marry",
            "last_name" => "PR",
            "dob" => "1987-01-01",
            "person_hbx_id" => "21210283",
            "encrypted_ssn" => "t+JuFT1brrEwRtiqmgF+yoMEu/0HKMRIkw==\n"
          }
        }
      ],
      "us_state" => "DC",
      "hbx_id" => "220000369",
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
              "person_id" => 21_210_284
            }
          ]
        },
        {
          "household_id" => "2",
          "people" => [
            {
              "person_id" => 21_210_282
            },
            {
              "person_id" => 21_210_283
            },
            {
              "person_id" => 21_210_285
            }
          ]
        }
      ],
      "mitc_tax_returns" => [
        {
          "filers" => [
            {
              "person_id" => 21_210_282
            }
          ],
          "dependents" => [
            {
              "person_id" => 21_210_284
            }
          ]
        },
        {
          "filers" => [
            {
              "person_id" => 21_210_283
            }
          ],
          "dependents" => [
            {
              "person_id" => 21_210_285
            }
          ]
        }
      ],
      "submitted_at" => "2022-04-21T13:23:22.787+00:00",
      "full_medicaid_determination" => true
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
      "Determination Date" => "2022-04-21",
      "Applicants" => [
        {
          "Person ID" => 21_210_282,
          "Medicaid Household" => {
            "People" => [
              21_210_282,
              21_210_284,
              21_210_283
            ],
            "MAGI" => 76_068,
            "MAGI as Percentage of FPL" => 330,
            "Size" => 3
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
          "Category" => "Parent Caretaker Category",
          "Category Threshold" => 50_896,
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
              "Indicator" => "Y"
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
              "Indicator" => "Y"
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
            "Qualified Children List" => [
              {
                "Person ID" => 21_210_285,
                "Determinations" => {
                  "Dependent Age" => {
                    "Indicator" => "Y"
                  },
                  "Deprived Child" => {
                    "Indicator" => "X"
                  },
                  "Relationship" => {
                    "Indicator" => "Y"
                  }
                }
              },
              {
                "Person ID" => 21_210_284,
                "Determinations" => {
                  "Dependent Age" => {
                    "Indicator" => "Y"
                  },
                  "Deprived Child" => {
                    "Indicator" => "X"
                  },
                  "Relationship" => {
                    "Indicator" => "Y"
                  }
                }
              }
            ]
          }
        },
        {
          "Person ID" => 21_210_283,
          "Medicaid Household" => {
            "People" => [
              21_210_283,
              21_210_285,
              21_210_282
            ],
            "MAGI" => 51_068,
            "MAGI as Percentage of FPL" => 221,
            "Size" => 3
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
          "Category" => "Parent Caretaker Category",
          "Category Threshold" => 50_896,
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
              "Indicator" => "Y"
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
              "Indicator" => "Y"
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
            "Qualified Children List" => [
              {
                "Person ID" => 21_210_285,
                "Determinations" => {
                  "Dependent Age" => {
                    "Indicator" => "Y"
                  },
                  "Deprived Child" => {
                    "Indicator" => "X"
                  },
                  "Relationship" => {
                    "Indicator" => "Y"
                  }
                }
              }
            ]
          }
        },
        {
          "Person ID" => 21_210_284,
          "Medicaid Household" => {
            "People" => [
              21_210_284
            ],
            "MAGI" => 25_000,
            "MAGI as Percentage of FPL" => 183,
            "Size" => 1
          },
          "Medicaid Eligible" => "N",
          "CHIP Eligible" => "N",
          "Ineligibility Reason" => [
            "Applicant did not meet residency requirements"
          ],
          "Non-MAGI Referral" => "N",
          "CHIP Ineligibility Reason" => [
            "Applicant did not meet residency requirements",
            "Applicant did not meet the requirements for any CHIP category"
          ],
          "Category" => "Child Category",
          "Category Threshold" => 44_031,
          "CHIP Category" => "None",
          "CHIP Category Threshold" => 0,
          "Determinations" => {
            "Residency" => {
              "Indicator" => "N",
              "Ineligibility Code" => nil,
              "Ineligibility Reason" => nil
            },
            "Adult Group Category" => {
              "Indicator" => "N",
              "Ineligibility Code" => 123,
              "Ineligibility Reason" => "Applicant is not between the ages of 19 and 64 (inclusive)"
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
              "Indicator" => "Y"
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
              "Indicator" => "Y"
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
        },
        {
          "Person ID" => 21_210_285,
          "Medicaid Household" => {
            "People" => [
              21_210_282,
              21_210_283,
              21_210_285
            ],
            "MAGI" => 51_068,
            "MAGI as Percentage of FPL" => 221,
            "Size" => 3
          },
          "Medicaid Eligible" => "Y",
          "CHIP Eligible" => "N",
          "CHIP Ineligibility Reason" => [
            "Applicant did not meet the requirements for any CHIP category"
          ],
          "Category" => "Child Category",
          "Category Threshold" => 74_617,
          "CHIP Category" => "None",
          "CHIP Category Threshold" => 0,
          "Determinations" => {
            "Residency" => {
              "Indicator" => "Y"
            },
            "Adult Group Category" => {
              "Indicator" => "N",
              "Ineligibility Code" => 123,
              "Ineligibility Reason" => "Applicant is not between the ages of 19 and 64 (inclusive)"
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
              "Indicator" => "Y"
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
              "Indicator" => "Y"
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
              "Indicator" => "N",
              "Ineligibility Code" => 406,
              "Ineligibility Reason" => "Applicant is eligible for Medicaid"
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
