# frozen_string_literal: true

RSpec.shared_context 'dc_test_scenarios qa_core_3_magi_020', :shared_context => :metadata do
  let(:today) { Date.today }
  let(:assistance_year) { today.year.next }
  let(:oe_start_on) { today.beginning_of_month }
  let(:start_of_year) { today.beginning_of_year }
  let(:aptc_effective_date) { Date.new(assistance_year) }

  let(:app_params) do
    {
      "family_reference" => {
        "hbx_id" => "291072"
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
            "first_name" => "Ben",
            "middle_name" => nil,
            "last_name" => "Luna",
            "name_sfx" => nil,
            "name_pfx" => nil
          },
          "identifying_information" => {
            "encrypted_ssn" => "RSf2HKNQpe5Zu25sdrQFoIEAuvAHK8NKlA==\n",
            "has_ssn" => false
          },
          "demographic" => {
            "gender" => "Male",
            "dob" => "1969-12-01",
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
            "family_member_hbx_id" => "21210142",
            "first_name" => "Ben",
            "last_name" => "Luna",
            "person_hbx_id" => "21210142",
            "is_primary_family_member" => true
          },
          "person_hbx_id" => "21210142",
          "is_required_to_file_taxes" => true,
          "is_filing_as_head_of_household" => false,
          "tax_filer_kind" => "tax_filer",
          "is_joint_tax_filing" => true,
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
          "has_unemployment_income" => true,
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
              "address_1" => "1225 I ST NW",
              "address_2" => nil,
              "address_3" => nil,
              "city" => "Washington",
              "county" => nil,
              "state" => "DC",
              "zip" => "20005",
              "country_name" => nil
            }
          ],
          "emails" => [],
          "phones" => [],
          "incomes" => [
            {
              "title" => nil,
              "kind" => "unemployment_income",
              "wage_type" => nil,
              "hours_per_week" => nil,
              "amount" => "5845.2",
              "amount_tax_exempt" => "0.0",
              "frequency_kind" => "Annually",
              "start_on" => "2019-01-01",
              "end_on" => nil,
              "is_projected" => false,
              "employer" => nil,
              "has_property_usage_rights" => nil,
              "submitted_at" => "2022-03-24T17:50:00.000+00:00"
            }
          ],
          "benefits" => [],
          "deductions" => [],
          "is_medicare_eligible" => false,
          "has_insurance" => false,
          "has_state_health_benefit" => false,
          "had_prior_insurance" => false,
          "prior_insurance_end_date" => nil,
          "age_of_applicant" => 52,
          "is_self_attested_long_term_care" => false,
          "hours_worked_per_week" => 0,
          "is_temporarily_out_of_state" => false,
          "is_claimed_as_dependent_by_non_applicant" => false,
          "benchmark_premium" => {
            "health_only_lcsp_premiums" => [
              {
                "member_identifier" => "21210142",
                "monthly_premium" => "600.99"
              },
              {
                "member_identifier" => "21210143",
                "monthly_premium" => "515.41"
              },
              {
                "member_identifier" => "21210144",
                "monthly_premium" => "254.4"
              }
            ],
            "health_only_slcsp_premiums" => [
              {
                "member_identifier" => "21210142",
                "monthly_premium" => "608.68"
              },
              {
                "member_identifier" => "21210143",
                "monthly_premium" => "522.01"
              },
              {
                "member_identifier" => "21210144",
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
            "unemployment_compensation" => 5845,
            "other_income" => 0,
            "magi_deductions" => 0,
            "adjusted_gross_income" => 5845,
            "deductible_part_of_self_employment_tax" => 0,
            "ira_deduction" => 0,
            "student_loan_interest_deduction" => 0,
            "tution_and_fees" => 0,
            "other_magi_eligible_income" => 0
          },
          "mitc_relationships" => [
            {
              "other_id" => 21_210_143,
              "attest_primary_responsibility" => "Y",
              "relationship_code" => "02"
            },
            {
              "other_id" => 21_210_144,
              "attest_primary_responsibility" => "Y",
              "relationship_code" => "03"
            }
          ],
          "mitc_is_required_to_file_taxes" => true,
          "mitc_state_resident" => true,
          "income_evidence" => nil,
          "esi_evidence" => nil,
          "non_esi_evidence" => nil,
          "local_mec_evidence" => nil
        },
        {
          "name" => {
            "first_name" => "Sol",
            "middle_name" => nil,
            "last_name" => "Luna",
            "name_sfx" => nil,
            "name_pfx" => nil
          },
          "identifying_information" => {
            "encrypted_ssn" => "ntaJx9+9rIinq2ZvzxRbW4kKufoLL8JMng==\n",
            "has_ssn" => false
          },
          "demographic" => {
            "gender" => "Female",
            "dob" => "1973-12-01",
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
            "family_member_hbx_id" => "21210143",
            "first_name" => "Sol",
            "last_name" => "Luna",
            "person_hbx_id" => "21210143",
            "is_primary_family_member" => false
          },
          "person_hbx_id" => "21210143",
          "is_required_to_file_taxes" => true,
          "is_filing_as_head_of_household" => false,
          "tax_filer_kind" => "tax_filer",
          "is_joint_tax_filing" => true,
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
              "address_1" => "1225 I ST NW",
              "address_2" => nil,
              "address_3" => nil,
              "city" => "Washington",
              "county" => nil,
              "state" => "DC",
              "zip" => "20005",
              "country_name" => nil
            }
          ],
          "emails" => [],
          "phones" => [],
          "incomes" => [
            {
              "title" => nil,
              "kind" => "rental_and_royalty",
              "wage_type" => nil,
              "hours_per_week" => nil,
              "amount" => "1520.9",
              "amount_tax_exempt" => "0.0",
              "frequency_kind" => "Annually",
              "start_on" => "2019-01-01",
              "end_on" => nil,
              "is_projected" => false,
              "employer" => nil,
              "has_property_usage_rights" => nil,
              "submitted_at" => "2022-03-24T17:51:05.000+00:00"
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
          "is_temporarily_out_of_state" => false,
          "is_claimed_as_dependent_by_non_applicant" => false,
          "benchmark_premium" => {
            "health_only_lcsp_premiums" => [
              {
                "member_identifier" => "21210142",
                "monthly_premium" => "600.99"
              },
              {
                "member_identifier" => "21210143",
                "monthly_premium" => "515.41"
              },
              {
                "member_identifier" => "21210144",
                "monthly_premium" => "254.4"
              }
            ],
            "health_only_slcsp_premiums" => [
              {
                "member_identifier" => "21210142",
                "monthly_premium" => "608.68"
              },
              {
                "member_identifier" => "21210143",
                "monthly_premium" => "522.01"
              },
              {
                "member_identifier" => "21210144",
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
            "other_income" => 1520,
            "magi_deductions" => 0,
            "adjusted_gross_income" => 1520,
            "deductible_part_of_self_employment_tax" => 0,
            "ira_deduction" => 0,
            "student_loan_interest_deduction" => 0,
            "tution_and_fees" => 0,
            "other_magi_eligible_income" => 0
          },
          "mitc_relationships" => [
            {
              "other_id" => 21_210_142,
              "attest_primary_responsibility" => "N",
              "relationship_code" => "02"
            },
            {
              "other_id" => 21_210_144,
              "attest_primary_responsibility" => "N",
              "relationship_code" => "03"
            }
          ],
          "mitc_is_required_to_file_taxes" => true,
          "mitc_state_resident" => true,
          "income_evidence" => nil,
          "esi_evidence" => nil,
          "non_esi_evidence" => nil,
          "local_mec_evidence" => nil
        },
        {
          "name" => {
            "first_name" => "Star",
            "middle_name" => nil,
            "last_name" => "Luna",
            "name_sfx" => nil,
            "name_pfx" => nil
          },
          "identifying_information" => {
            "encrypted_ssn" => "zUzTW36dm10FQ5shc7as1IECsfsAIsBOlA==\n",
            "has_ssn" => false
          },
          "demographic" => {
            "gender" => "Female",
            "dob" => "2002-12-01",
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
            "family_member_hbx_id" => "21210144",
            "first_name" => "Star",
            "last_name" => "Luna",
            "person_hbx_id" => "21210144",
            "is_primary_family_member" => false
          },
          "person_hbx_id" => "21210144",
          "is_required_to_file_taxes" => false,
          "is_filing_as_head_of_household" => false,
          "tax_filer_kind" => "dependent",
          "is_joint_tax_filing" => false,
          "is_claimed_as_tax_dependent" => true,
          "claimed_as_tax_dependent_by" => {
            "first_name" => "Ben",
            "last_name" => "Luna",
            "dob" => "1969-12-01",
            "person_hbx_id" => "21210142",
            "encrypted_ssn" => "RSf2HKNQpe5Zu25sdrQFoIEAuvAHK8NKlA==\n"
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
              "address_1" => "1321 Oates ST",
              "address_2" => nil,
              "address_3" => nil,
              "city" => "Capitol Heights",
              "county" => nil,
              "state" => "MD",
              "zip" => "20743",
              "country_name" => nil
            }
          ],
          "emails" => [],
          "phones" => [],
          "incomes" => [
            {
              "title" => nil,
              "kind" => "wages_and_salaries",
              "wage_type" => nil,
              "hours_per_week" => nil,
              "amount" => "8887.0",
              "amount_tax_exempt" => "0.0",
              "frequency_kind" => "Annually",
              "start_on" => "2019-01-01",
              "end_on" => nil,
              "is_projected" => false,
              "employer" => {
                "employer_name" => "starburst",
                "employer_id" => nil
              },
              "has_property_usage_rights" => nil,
              "submitted_at" => "2022-03-24T18:00:53.000+00:00"
            }
          ],
          "benefits" => [],
          "deductions" => [],
          "is_medicare_eligible" => false,
          "has_insurance" => false,
          "has_state_health_benefit" => false,
          "had_prior_insurance" => false,
          "prior_insurance_end_date" => nil,
          "age_of_applicant" => 19,
          "is_self_attested_long_term_care" => false,
          "hours_worked_per_week" => 0,
          "is_temporarily_out_of_state" => false,
          "is_claimed_as_dependent_by_non_applicant" => false,
          "benchmark_premium" => {
            "health_only_lcsp_premiums" => [
              {
                "member_identifier" => "21210142",
                "monthly_premium" => "600.99"
              },
              {
                "member_identifier" => "21210143",
                "monthly_premium" => "515.41"
              },
              {
                "member_identifier" => "21210144",
                "monthly_premium" => "254.4"
              }
            ],
            "health_only_slcsp_premiums" => [
              {
                "member_identifier" => "21210142",
                "monthly_premium" => "608.68"
              },
              {
                "member_identifier" => "21210143",
                "monthly_premium" => "522.01"
              },
              {
                "member_identifier" => "21210144",
                "monthly_premium" => "257.65"
              }
            ]
          },
          "is_homeless" => false,
          "mitc_income" => {
            "amount" => 8887,
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
            "adjusted_gross_income" => 8887,
            "deductible_part_of_self_employment_tax" => 0,
            "ira_deduction" => 0,
            "student_loan_interest_deduction" => 0,
            "tution_and_fees" => 0,
            "other_magi_eligible_income" => 0
          },
          "mitc_relationships" => [
            {
              "other_id" => 21_210_142,
              "attest_primary_responsibility" => "N",
              "relationship_code" => "04"
            },
            {
              "other_id" => 21_210_143,
              "attest_primary_responsibility" => "N",
              "relationship_code" => "04"
            }
          ],
          "mitc_is_required_to_file_taxes" => false,
          "mitc_state_resident" => false,
          "income_evidence" => nil,
          "esi_evidence" => nil,
          "non_esi_evidence" => nil,
          "local_mec_evidence" => nil
        }
      ],
      "tax_households" => [
        {
          "max_aptc" => "0.0",
          "hbx_id" => "24212",
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
                "first_name" => "Ben",
                "last_name" => "Luna",
                "dob" => "1969-12-01",
                "person_hbx_id" => "21210142",
                "encrypted_ssn" => "RSf2HKNQpe5Zu25sdrQFoIEAuvAHK8NKlA==\n"
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
                "first_name" => "Sol",
                "last_name" => "Luna",
                "dob" => "1973-12-01",
                "person_hbx_id" => "21210143",
                "encrypted_ssn" => "ntaJx9+9rIinq2ZvzxRbW4kKufoLL8JMng==\n"
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
                "first_name" => "Star",
                "last_name" => "Luna",
                "dob" => "2002-12-01",
                "person_hbx_id" => "21210144",
                "encrypted_ssn" => "zUzTW36dm10FQ5shc7as1IECsfsAIsBOlA==\n"
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
            "first_name" => "Sol",
            "last_name" => "Luna",
            "dob" => "1973-12-01",
            "person_hbx_id" => "21210143",
            "encrypted_ssn" => "ntaJx9+9rIinq2ZvzxRbW4kKufoLL8JMng==\n"
          },
          "relative_reference" => {
            "first_name" => "Ben",
            "last_name" => "Luna",
            "dob" => "1969-12-01",
            "person_hbx_id" => "21210142",
            "encrypted_ssn" => "RSf2HKNQpe5Zu25sdrQFoIEAuvAHK8NKlA==\n"
          }
        },
        {
          "kind" => "spouse",
          "applicant_reference" => {
            "first_name" => "Ben",
            "last_name" => "Luna",
            "dob" => "1969-12-01",
            "person_hbx_id" => "21210142",
            "encrypted_ssn" => "RSf2HKNQpe5Zu25sdrQFoIEAuvAHK8NKlA==\n"
          },
          "relative_reference" => {
            "first_name" => "Sol",
            "last_name" => "Luna",
            "dob" => "1973-12-01",
            "person_hbx_id" => "21210143",
            "encrypted_ssn" => "ntaJx9+9rIinq2ZvzxRbW4kKufoLL8JMng==\n"
          }
        },
        {
          "kind" => "child",
          "applicant_reference" => {
            "first_name" => "Star",
            "last_name" => "Luna",
            "dob" => "2002-12-01",
            "person_hbx_id" => "21210144",
            "encrypted_ssn" => "zUzTW36dm10FQ5shc7as1IECsfsAIsBOlA==\n"
          },
          "relative_reference" => {
            "first_name" => "Ben",
            "last_name" => "Luna",
            "dob" => "1969-12-01",
            "person_hbx_id" => "21210142",
            "encrypted_ssn" => "RSf2HKNQpe5Zu25sdrQFoIEAuvAHK8NKlA==\n"
          }
        },
        {
          "kind" => "parent",
          "applicant_reference" => {
            "first_name" => "Ben",
            "last_name" => "Luna",
            "dob" => "1969-12-01",
            "person_hbx_id" => "21210142",
            "encrypted_ssn" => "RSf2HKNQpe5Zu25sdrQFoIEAuvAHK8NKlA==\n"
          },
          "relative_reference" => {
            "first_name" => "Star",
            "last_name" => "Luna",
            "dob" => "2002-12-01",
            "person_hbx_id" => "21210144",
            "encrypted_ssn" => "zUzTW36dm10FQ5shc7as1IECsfsAIsBOlA==\n"
          }
        },
        {
          "kind" => "parent",
          "applicant_reference" => {
            "first_name" => "Sol",
            "last_name" => "Luna",
            "dob" => "1973-12-01",
            "person_hbx_id" => "21210143",
            "encrypted_ssn" => "ntaJx9+9rIinq2ZvzxRbW4kKufoLL8JMng==\n"
          },
          "relative_reference" => {
            "first_name" => "Star",
            "last_name" => "Luna",
            "dob" => "2002-12-01",
            "person_hbx_id" => "21210144",
            "encrypted_ssn" => "zUzTW36dm10FQ5shc7as1IECsfsAIsBOlA==\n"
          }
        },
        {
          "kind" => "child",
          "applicant_reference" => {
            "first_name" => "Star",
            "last_name" => "Luna",
            "dob" => "2002-12-01",
            "person_hbx_id" => "21210144",
            "encrypted_ssn" => "zUzTW36dm10FQ5shc7as1IECsfsAIsBOlA==\n"
          },
          "relative_reference" => {
            "first_name" => "Sol",
            "last_name" => "Luna",
            "dob" => "1973-12-01",
            "person_hbx_id" => "21210143",
            "encrypted_ssn" => "ntaJx9+9rIinq2ZvzxRbW4kKufoLL8JMng==\n"
          }
        }
      ],
      "us_state" => "DC",
      "hbx_id" => "220000216",
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
              "person_id" => 21_210_142
            },
            {
              "person_id" => 21_210_143
            }
          ]
        },
        {
          "household_id" => "2",
          "people" => [
            {
              "person_id" => 21_210_144
            }
          ]
        }
      ],
      "mitc_tax_returns" => [
        {
          "filers" => [
            {
              "person_id" => 21_210_142
            },
            {
              "person_id" => 21_210_143
            }
          ],
          "dependents" => [
            {
              "person_id" => 21_210_144
            }
          ]
        }
      ],
      "submitted_at" => "2022-03-24T18:01:58.149+00:00",
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
      'Determination Date': "2022-04-12",
      Applicants: [
        {
          'Person ID': 21_210_142,
          'Medicaid Household': {
            People: [
              21_210_142,
              21_210_143,
              21_210_144
            ],
            MAGI: 7365,
            'MAGI as Percentage of FPL': 31,
            Size: 3
          },
          'Medicaid Eligible': "Y",
          'CHIP Eligible': "N",
          'CHIP Ineligibility Reason': [
            "Applicant did not meet the requirements for any CHIP category"
          ],
          Category: "Adult Group Category",
          'Category Threshold': 49_514,
          'CHIP Category': "None",
          'CHIP Category Threshold': 0,
          Determinations: {
            Residency: {
              Indicator: "Y"
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
              Indicator: "N",
              'Ineligibility Code': 406,
              'Ineligibility Reason': "Applicant is eligible for Medicaid"
            }
          },
          'Other Outputs': {
            'Qualified Children List': []
          }
        },
        {
          'Person ID': 21_210_143,
          'Medicaid Household': {
            People: [
              21_210_142,
              21_210_143,
              21_210_144
            ],
            MAGI: 7365,
            'MAGI as Percentage of FPL': 31,
            Size: 3
          },
          'Medicaid Eligible': "Y",
          'CHIP Eligible': "N",
          'CHIP Ineligibility Reason': [
            "Applicant did not meet the requirements for any CHIP category"
          ],
          Category: "Adult Group Category",
          'Category Threshold': 49_514,
          'CHIP Category': "None",
          'CHIP Category Threshold': 0,
          Determinations: {
            Residency: {
              Indicator: "Y"
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
              Indicator: "N",
              'Ineligibility Code': 406,
              'Ineligibility Reason': "Applicant is eligible for Medicaid"
            }
          },
          'Other Outputs': {
            'Qualified Children List': []
          }
        },
        {
          'Person ID': 21_210_144,
          'Medicaid Household': {
            People: [
              21_210_142,
              21_210_143,
              21_210_144
            ],
            MAGI: 7365,
            'MAGI as Percentage of FPL': 31,
            Size: 3
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
          Category: "Child Category",
          'Category Threshold': 50_896,
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
              Indicator: "Y"
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
