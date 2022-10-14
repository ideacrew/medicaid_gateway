# frozen_string_literal: true

RSpec.shared_context 'cms ME me_test_scenarios test_four', :shared_context => :metadata do
  let(:app_params) do
    {
      "family_reference" => {
        "hbx_id" => "10233"
      }, "assistance_year" => 2021, "aptc_effective_date" => "2021-08-01T00:00:00.000+00:00",
      "years_to_renew" => nil, "renewal_consent_through_year" => 5, "is_ridp_verified" => true, "is_renewal_authorized" => true,
      "applicants" => [{
        "name" => {
          "first_name" => "Jane", "middle_name" => nil, "last_name" => "Test", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "QEVuQwEAhKM5BRq9Z65qbCYSlhHZLw==", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Female", "dob" => "1984-01-01", "ethnicity" => [], "race" => nil,
          "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false,
          "is_self_attested_long_term_care" => false
        },
        "is_primary_applicant" => true,
        "native_american_information" => {
          "indian_tribe_member" => false, "tribal_id" => nil
        },
        "citizenship_immigration_status_information" => {
          "citizen_status" => "us_citizen", "is_resident_post_092296" => false, "is_lawful_presence_self_attested" => false
        },
        "is_consumer_role" => true,
        "is_resident_role" => false,
        "is_applying_coverage" => true,
        "is_consent_applicant" => false,
        "vlp_document" => nil,
        "family_member_reference" => {
          "family_member_hbx_id" => "1002507", "first_name" => "Jane", "last_name" => "Test",
          "person_hbx_id" => "1002507", "is_primary_family_member" => true
        },
        "person_hbx_id" => "1002507",
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
          "is_former_foster_care" => false, "age_left_foster_care" => nil, "foster_care_us_state" => nil,
          "had_medicaid_during_foster_care" => false
        },
        "pregnancy_information" => {
          "is_pregnant" => false, "is_enrolled_on_medicaid" => false, "is_post_partum_period" => false,
          "expected_children_count" => nil, "pregnancy_due_on" => nil, "pregnancy_end_on" => nil
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
        "has_self_employment_income" => true,
        "has_unemployment_income" => false,
        "has_other_income" => false,
        "has_deductions" => false,
        "has_enrolled_health_coverage" => false,
        "has_eligible_health_coverage" => true,
        "job_coverage_ended_in_past_3_months" => false,
        "job_coverage_end_date" => nil,
        "medicaid_and_chip" => {
          "not_eligible_in_last_90_days" => false, "denied_on" => nil, "ended_as_change_in_eligibility" => false,
          "hh_income_or_size_changed" => false, "medicaid_or_chip_coverage_end_date" => nil,
          "ineligible_due_to_immigration_in_last_5_years" => false, "immigration_status_changed_since_ineligibility" => false
        },
        "other_health_service" => {
          "has_received" => false, "is_eligible" => false
        },
        "addresses" => [{
          "kind" => "home",
          "address_1" => "1573 testing street",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "Palmyra",
          "county" => "Testing",
          "state" => "ME",
          "zip" => "04965",
          "country_name" => nil
        }],
        "emails" => [],
        "phones" => [],
        "incomes" => [{
          "title" => nil,
          "kind" => "wages_and_salaries",
          "wage_type" => nil,
          "hours_per_week" => nil,
          "amount" => "680.0",
          "amount_tax_exempt" => "0.0",
          "frequency_kind" => "Weekly",
          "start_on" => "2020-06-01",
          "end_on" => nil,
          "is_projected" => false,
          "employer" => {
            "employer_name" => "Sattest", "employer_id" => "12"
          },
          "has_property_usage_rights" => nil,
          "submitted_at" => "2021-07-09T20:22:47.000+00:00"
        }, {
          "title" => nil,
          "kind" => "net_self_employment",
          "wage_type" => nil,
          "hours_per_week" => nil,
          "amount" => "4453.33",
          "amount_tax_exempt" => "0.0",
          "frequency_kind" => "Monthly",
          "start_on" => "2021-08-18",
          "end_on" => "2021-11-06",
          "is_projected" => false,
          "employer" => nil,
          "has_property_usage_rights" => nil,
          "submitted_at" => "2021-07-09T20:22:47.000+00:00"
        }],
        "benefits" => [{
          "name" => nil,
          "kind" => "employer_sponsored_insurance",
          "status" => "is_eligible",
          "is_employer_sponsored" => false,
          "employer" => {
            "employer_name" => "Acme", "employer_id" => "012481099"
          },
          "esi_covered" => "self",
          "is_esi_waiting_period" => false,
          "is_esi_mec_met" => true,
          "employee_cost" => "500.0",
          "employee_cost_frequency" => "Monthly",
          "start_on" => "2021-08-01",
          "end_on" => nil,
          "submitted_at" => "2021-07-09T20:22:47.000+00:00",
          "hra_kind" => nil,
          "health_plan_meets_mvs_and_affordable" => false
        }],
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
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1002507",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002536",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002537",
            "monthly_premium" => "310.5"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1002507",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002536",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002537",
            "monthly_premium" => "310.5"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 35_360, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0,
          "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0,
          "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 47_219,
          "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0,
          "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_002_536,
          "attest_primary_responsibility" => "Y",
          "relationship_code" => "88"
        }, {
          "other_id" => 1_002_537,
          "attest_primary_responsibility" => "Y",
          "relationship_code" => "03"
        }],
        "mitc_is_required_to_file_taxes" => true
      }, {
        "name" => {
          "first_name" => "jim", "middle_name" => nil, "last_name" => "Test", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "QEVuQwEAACeT5eonN4iXy870F+RNsQ==", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Male", "dob" => "1984-01-01", "ethnicity" => [], "race" => nil,
          "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false,
          "is_self_attested_long_term_care" => false
        },
        "is_primary_applicant" => false,
        "native_american_information" => {
          "indian_tribe_member" => false, "tribal_id" => nil
        },
        "citizenship_immigration_status_information" => {
          "citizen_status" => "us_citizen", "is_resident_post_092296" => false, "is_lawful_presence_self_attested" => false
        },
        "is_consumer_role" => true,
        "is_resident_role" => false,
        "is_applying_coverage" => true,
        "is_consent_applicant" => false,
        "vlp_document" => nil,
        "family_member_reference" => {
          "family_member_hbx_id" => "1002536", "first_name" => "jim", "last_name" => "Test",
          "person_hbx_id" => "1002536", "is_primary_family_member" => false
        },
        "person_hbx_id" => "1002536",
        "is_required_to_file_taxes" => false,
        "tax_filer_kind" => "non_filer",
        "is_joint_tax_filing" => false,
        "is_claimed_as_tax_dependent" => false,
        "claimed_as_tax_dependent_by" => nil,
        "student" => {
          "is_student" => false, "student_kind" => nil, "student_school_kind" => nil, "student_status_end_on" => nil
        },
        "is_refugee" => false,
        "is_trafficking_victim" => false,
        "foster_care" => {
          "is_former_foster_care" => false, "age_left_foster_care" => nil, "foster_care_us_state" => nil,
          "had_medicaid_during_foster_care" => false
        },
        "pregnancy_information" => {
          "is_pregnant" => false, "is_enrolled_on_medicaid" => false, "is_post_partum_period" => false,
          "expected_children_count" => nil, "pregnancy_due_on" => nil, "pregnancy_end_on" => nil
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
        "has_deductions" => true,
        "has_enrolled_health_coverage" => false,
        "has_eligible_health_coverage" => false,
        "job_coverage_ended_in_past_3_months" => false,
        "job_coverage_end_date" => nil,
        "medicaid_and_chip" => {
          "not_eligible_in_last_90_days" => false, "denied_on" => nil, "ended_as_change_in_eligibility" => false,
          "hh_income_or_size_changed" => false, "medicaid_or_chip_coverage_end_date" => nil,
          "ineligible_due_to_immigration_in_last_5_years" => false, "immigration_status_changed_since_ineligibility" => false
        },
        "other_health_service" => {
          "has_received" => false, "is_eligible" => false
        },
        "addresses" => [{
          "kind" => "home",
          "address_1" => "1573 testing street",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "Palmyra",
          "county" => "Testing",
          "state" => "ME",
          "zip" => "04965",
          "country_name" => nil
        }],
        "emails" => [],
        "phones" => [],
        "incomes" => [{
          "title" => nil,
          "kind" => "wages_and_salaries",
          "wage_type" => nil,
          "hours_per_week" => nil,
          "amount" => "440.0",
          "amount_tax_exempt" => "0.0",
          "frequency_kind" => "Weekly",
          "start_on" => "2020-11-01",
          "end_on" => nil,
          "is_projected" => false,
          "employer" => {
            "employer_name" => "empname", "employer_id" => "123456"
          },
          "has_property_usage_rights" => nil,
          "submitted_at" => "2021-07-09T20:22:47.000+00:00"
        }],
        "benefits" => [],
        "deductions" => [{
          "name" => nil,
          "kind" => "student_loan_interest",
          "amount" => "5100.0",
          "start_on" => "2021-01-01",
          "end_on" => nil,
          "frequency_kind" => "Annually",
          "submitted_at" => "2021-07-09T20:22:48.000+00:00"
        }],
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
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1002507",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002536",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002537",
            "monthly_premium" => "310.5"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1002507",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002536",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002537",
            "monthly_premium" => "310.5"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 22_880, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0,
          "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0,
          "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 17_780,
          "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 5100,
          "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_002_507,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "88"
        }, {
          "other_id" => 1_002_537,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "88"
        }],
        "mitc_is_required_to_file_taxes" => true
      }, {
        "name" => {
          "first_name" => "Baby", "middle_name" => nil, "last_name" => "Test", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "QEVuQwEAm0+YMFpFBbMfyrxLe/u+eQ==", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Female", "dob" => "2014-01-01", "ethnicity" => [], "race" => nil,
          "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false,
          "is_self_attested_long_term_care" => false
        },
        "is_primary_applicant" => false,
        "native_american_information" => {
          "indian_tribe_member" => false, "tribal_id" => nil
        },
        "citizenship_immigration_status_information" => {
          "citizen_status" => "us_citizen", "is_resident_post_092296" => false, "is_lawful_presence_self_attested" => false
        },
        "is_consumer_role" => true,
        "is_resident_role" => false,
        "is_applying_coverage" => true,
        "is_consent_applicant" => false,
        "vlp_document" => nil,
        "family_member_reference" => {
          "family_member_hbx_id" => "1002537", "first_name" => "Baby", "last_name" => "Test",
          "person_hbx_id" => "1002537", "is_primary_family_member" => false
        },
        "person_hbx_id" => "1002537",
        "is_required_to_file_taxes" => false,
        "tax_filer_kind" => "dependent",
        "is_joint_tax_filing" => false,
        "is_claimed_as_tax_dependent" => true,
        "claimed_as_tax_dependent_by" => {
          "first_name" => "Jane", "last_name" => "Test", "dob" => "1984-01-01",
          "person_hbx_id" => "1002507", "encrypted_ssn" => "QEVuQwEAhKM5BRq9Z65qbCYSlhHZLw=="
        },
        "student" => {
          "is_student" => false, "student_kind" => nil, "student_school_kind" => nil, "student_status_end_on" => nil
        },
        "is_refugee" => false,
        "is_trafficking_victim" => false,
        "foster_care" => {
          "is_former_foster_care" => false, "age_left_foster_care" => nil, "foster_care_us_state" => nil,
          "had_medicaid_during_foster_care" => false
        },
        "pregnancy_information" => {
          "is_pregnant" => false, "is_enrolled_on_medicaid" => false, "is_post_partum_period" => false,
          "expected_children_count" => nil, "pregnancy_due_on" => nil, "pregnancy_end_on" => nil
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
          "not_eligible_in_last_90_days" => false, "denied_on" => nil, "ended_as_change_in_eligibility" => false,
          "hh_income_or_size_changed" => false, "medicaid_or_chip_coverage_end_date" => nil,
          "ineligible_due_to_immigration_in_last_5_years" => false, "immigration_status_changed_since_ineligibility" => false
        },
        "other_health_service" => {
          "has_received" => false, "is_eligible" => false
        },
        "addresses" => [{
          "kind" => "home",
          "address_1" => "1573 testing street",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "Palmyra",
          "county" => "Testing",
          "state" => "ME",
          "zip" => "04965",
          "country_name" => nil
        }],
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
        "age_of_applicant" => 7,
        "is_self_attested_long_term_care" => false,
        "hours_worked_per_week" => 0,
        "is_temporarily_out_of_state" => false,
        "is_claimed_as_dependent_by_non_applicant" => false,
        "benchmark_premium" => {
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1002507",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002536",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002537",
            "monthly_premium" => "310.5"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1002507",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002536",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002537",
            "monthly_premium" => "310.5"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 0, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0,
          "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0,
          "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 0,
          "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0,
          "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_002_507,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }, {
          "other_id" => 1_002_536,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "88"
        }],
        "mitc_is_required_to_file_taxes" => false
      }], "tax_households" => [{
        "max_aptc" => "0.0",
        "hbx_id" => "10729",
        "is_insurance_assistance_eligible" => nil,
        "tax_household_members" => [{
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false,
            "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0",
            "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0",
            "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "Jane", "last_name" => "Test", "dob" => "1984-01-01",
            "person_hbx_id" => "1002507", "encrypted_ssn" => "QEVuQwEAhKM5BRq9Z65qbCYSlhHZLw=="
          }
        }, {
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false,
            "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0",
            "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0",
            "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "Baby", "last_name" => "Test", "dob" => "2014-01-01",
            "person_hbx_id" => "1002537", "encrypted_ssn" => "QEVuQwEAm0+YMFpFBbMfyrxLe/u+eQ=="
          }
        }],
        "annual_tax_household_income" => "0.0"
      }, {
        "max_aptc" => "0.0",
        "hbx_id" => "10730",
        "is_insurance_assistance_eligible" => nil,
        "tax_household_members" => [{
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false,
            "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0",
            "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0",
            "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "jim", "last_name" => "Test", "dob" => "1984-01-01",
            "person_hbx_id" => "1002536", "encrypted_ssn" => "QEVuQwEAACeT5eonN4iXy870F+RNsQ=="
          }
        }],
        "annual_tax_household_income" => "0.0"
      }], "relationships" => [{
        "kind" => "domestic_partner",
        "applicant_reference" => {
          "first_name" => "jim", "last_name" => "Test", "dob" => "1984-01-01",
          "person_hbx_id" => "1002536", "encrypted_ssn" => "QEVuQwEAACeT5eonN4iXy870F+RNsQ=="
        },
        "relative_reference" => {
          "first_name" => "Jane", "last_name" => "Test", "dob" => "1984-01-01",
          "person_hbx_id" => "1002507", "encrypted_ssn" => "QEVuQwEAhKM5BRq9Z65qbCYSlhHZLw=="
        }
      }, {
        "kind" => "domestic_partner",
        "applicant_reference" => {
          "first_name" => "Jane", "last_name" => "Test", "dob" => "1984-01-01",
          "person_hbx_id" => "1002507", "encrypted_ssn" => "QEVuQwEAhKM5BRq9Z65qbCYSlhHZLw=="
        },
        "relative_reference" => {
          "first_name" => "jim", "last_name" => "Test", "dob" => "1984-01-01",
          "person_hbx_id" => "1002536", "encrypted_ssn" => "QEVuQwEAACeT5eonN4iXy870F+RNsQ=="
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "Baby", "last_name" => "Test", "dob" => "2014-01-01",
          "person_hbx_id" => "1002537", "encrypted_ssn" => "QEVuQwEAm0+YMFpFBbMfyrxLe/u+eQ=="
        },
        "relative_reference" => {
          "first_name" => "Jane", "last_name" => "Test", "dob" => "1984-01-01",
          "person_hbx_id" => "1002507", "encrypted_ssn" => "QEVuQwEAhKM5BRq9Z65qbCYSlhHZLw=="
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "Jane", "last_name" => "Test", "dob" => "1984-01-01",
          "person_hbx_id" => "1002507", "encrypted_ssn" => "QEVuQwEAhKM5BRq9Z65qbCYSlhHZLw=="
        },
        "relative_reference" => {
          "first_name" => "Baby", "last_name" => "Test", "dob" => "2014-01-01",
          "person_hbx_id" => "1002537", "encrypted_ssn" => "QEVuQwEAm0+YMFpFBbMfyrxLe/u+eQ=="
        }
      }, {
        "kind" => "unrelated",
        "applicant_reference" => {
          "first_name" => "jim", "last_name" => "Test", "dob" => "1984-01-01",
          "person_hbx_id" => "1002536", "encrypted_ssn" => "QEVuQwEAACeT5eonN4iXy870F+RNsQ=="
        },
        "relative_reference" => {
          "first_name" => "Baby", "last_name" => "Test", "dob" => "2014-01-01",
          "person_hbx_id" => "1002537", "encrypted_ssn" => "QEVuQwEAm0+YMFpFBbMfyrxLe/u+eQ=="
        }
      }, {
        "kind" => "unrelated",
        "applicant_reference" => {
          "first_name" => "Baby", "last_name" => "Test", "dob" => "2014-01-01",
          "person_hbx_id" => "1002537", "encrypted_ssn" => "QEVuQwEAm0+YMFpFBbMfyrxLe/u+eQ=="
        },
        "relative_reference" => {
          "first_name" => "jim", "last_name" => "Test", "dob" => "1984-01-01",
          "person_hbx_id" => "1002536", "encrypted_ssn" => "QEVuQwEAACeT5eonN4iXy870F+RNsQ=="
        }
      }], "us_state" => "ME", notice_options: {
        send_eligibility_notices: true,
        send_open_enrollment_notices: false
      }, "hbx_id" => "270000195", "oe_start_on" => "2020-11-01", "mitc_households" => [{
        "household_id" => "1",
        "people" => [{
          "person_id" => 1_002_507
        }, {
          "person_id" => 1_002_536
        }, {
          "person_id" => 1_002_537
        }]
      }], "mitc_tax_returns" => [{
        "filers" => [{
          "person_id" => 1_002_507
        }],
        "dependents" => [{
          "person_id" => 1_002_537
        }]
      }, {
        "filers" => [{
          "person_id" => 1_002_536
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
    {
      "Determination Date" => "2021-07-10",
      "Applicants" => [{
        "Person ID" => 1_002_507,
        "Medicaid Household" => {
          "People" => [1_002_507, 1_002_537], "MAGI" => 35_360, "MAGI as Percentage of FPL" => 202, "Size" => 2
        },
        "Medicaid Eligible" => "N",
        "CHIP Eligible" => "N",
        "Ineligibility Reason" => ["Applicant's MAGI above the threshold for category"],
        "Non-MAGI Referral" => "N",
        "CHIP Ineligibility Reason" => ["Applicant did not meet the requirements for any CHIP category"],
        "Category" => "Adult Group Category",
        "Category Threshold" => 24_039,
        "CHIP Category" => "None",
        "CHIP Category Threshold" => 0,
        "Determinations" => {
          "Residency" => {
            "Indicator" => "Y"
          }, "Adult Group Category" => {
            "Indicator" => "Y"
          }, "Parent Caretaker Category" => {
            "Indicator" => "Y"
          }, "Pregnancy Category" => {
            "Indicator" => "N", "Ineligibility Code" => 124,
            "Ineligibility Reason" => "Applicant not pregnant or within postpartum period"
          }, "Child Category" => {
            "Indicator" => "N", "Ineligibility Code" => 394,
            "Ineligibility Reason" => "Applicant is over the age limit for the young adult threshold in the state"
          }, "Optional Targeted Low Income Child" => {
            "Indicator" => "X"
          }, "CHIP Targeted Low Income Child" => {
            "Indicator" => "N", "Ineligibility Code" => 127,
            "Ineligibility Reason" => "Applicant's age is not within the allowed age range"
          }, "Unborn Child" => {
            "Indicator" => "X"
          }, "Income Medicaid Eligible" => {
            "Indicator" => "N", "Ineligibility Code" => 402,
            "Ineligibility Reason" => "Applicant's income is greater than the threshold for all eligible categories"
          }, "Income CHIP Eligible" => {
            "Indicator" => "N", "Ineligibility Code" => 401,
            "Ineligibility Reason" => "Applicant did not meet the requirements for any eligibility category"
          }, "Medicaid CHIPRA 214" => {
            "Indicator" => "X"
          }, "CHIP CHIPRA 214" => {
            "Indicator" => "X"
          }, "Trafficking Victim" => {
            "Indicator" => "X"
          }, "Seven Year Limit" => {
            "Indicator" => "X"
          }, "Five Year Bar" => {
            "Indicator" => "X"
          }, "Title II Work Quarters Met" => {
            "Indicator" => "X"
          }, "Medicaid Citizen Or Immigrant" => {
            "Indicator" => "Y"
          }, "CHIP Citizen Or Immigrant" => {
            "Indicator" => "Y"
          }, "Former Foster Care Category" => {
            "Indicator" => "N", "Ineligibility Code" => 400,
            "Ineligibility Reason" => "Applicant was not formerly in foster care"
          }, "Work Quarters Override Income" => {
            "Indicator" => "N", "Ineligibility Code" => 340,
            "Ineligibility Reason" => "Income is greater than 100% FPL"
          }, "State Health Benefits CHIP" => {
            "Indicator" => "X"
          }, "CHIP Waiting Period Satisfied" => {
            "Indicator" => "X"
          }, "Dependent Child Covered" => {
            "Indicator" => "Y"
          }, "Medicaid Non-MAGI Referral" => {
            "Indicator" => "N", "Ineligibility Code" => 108,
            "Ineligibility Reason" => "Applicant does not meet requirements for a non-MAGI referral"
          }, "Emergency Medicaid" => {
            "Indicator" => "N", "Ineligibility Code" => 109,
            "Ineligibility Reason" => "Applicant does not meet the eligibility criteria for emergency Medicaid"
          }, "Refugee Medical Assistance" => {
            "Indicator" => "X"
          }, "APTC Referral" => {
            "Indicator" => "Y"
          }
        },
        "Other Outputs" => {
          "Qualified Children List" => [{
            "Person ID" => 1_002_537,
            "Determinations" => {
              "Dependent Age" => {
                "Indicator" => "Y"
              }, "Deprived Child" => {
                "Indicator" => "X"
              }, "Relationship" => {
                "Indicator" => "Y"
              }
            }
          }]
        }
      }, {
        "Person ID" => 1_002_536,
        "Medicaid Household" => {
          "People" => [1_002_536], "MAGI" => 22_880, "MAGI as Percentage of FPL" => 177, "Size" => 1
        },
        "Medicaid Eligible" => "N",
        "CHIP Eligible" => "N",
        "Ineligibility Reason" => ["Applicant's MAGI above the threshold for category"],
        "Non-MAGI Referral" => "N",
        "CHIP Ineligibility Reason" => ["Applicant did not meet the requirements for any CHIP category"],
        "Category" => "Adult Group Category",
        "Category Threshold" => 17_774,
        "CHIP Category" => "None",
        "CHIP Category Threshold" => 0,
        "Determinations" => {
          "Residency" => {
            "Indicator" => "Y"
          }, "Adult Group Category" => {
            "Indicator" => "Y"
          }, "Parent Caretaker Category" => {
            "Indicator" => "N", "Ineligibility Code" => 146,
            "Ineligibility Reason" => "No child met all criteria for parent caretaker category"
          }, "Pregnancy Category" => {
            "Indicator" => "N", "Ineligibility Code" => 124,
            "Ineligibility Reason" => "Applicant not pregnant or within postpartum period"
          }, "Child Category" => {
            "Indicator" => "N", "Ineligibility Code" => 394,
            "Ineligibility Reason" => "Applicant is over the age limit for the young adult threshold in the state"
          }, "Optional Targeted Low Income Child" => {
            "Indicator" => "X"
          }, "CHIP Targeted Low Income Child" => {
            "Indicator" => "N", "Ineligibility Code" => 127,
            "Ineligibility Reason" => "Applicant's age is not within the allowed age range"
          }, "Unborn Child" => {
            "Indicator" => "X"
          }, "Income Medicaid Eligible" => {
            "Indicator" => "N", "Ineligibility Code" => 402,
            "Ineligibility Reason" => "Applicant's income is greater than the threshold for all eligible categories"
          }, "Income CHIP Eligible" => {
            "Indicator" => "N", "Ineligibility Code" => 401,
            "Ineligibility Reason" => "Applicant did not meet the requirements for any eligibility category"
          }, "Medicaid CHIPRA 214" => {
            "Indicator" => "X"
          }, "CHIP CHIPRA 214" => {
            "Indicator" => "X"
          }, "Trafficking Victim" => {
            "Indicator" => "X"
          }, "Seven Year Limit" => {
            "Indicator" => "X"
          }, "Five Year Bar" => {
            "Indicator" => "X"
          }, "Title II Work Quarters Met" => {
            "Indicator" => "X"
          }, "Medicaid Citizen Or Immigrant" => {
            "Indicator" => "Y"
          }, "CHIP Citizen Or Immigrant" => {
            "Indicator" => "Y"
          }, "Former Foster Care Category" => {
            "Indicator" => "N", "Ineligibility Code" => 400,
            "Ineligibility Reason" => "Applicant was not formerly in foster care"
          }, "Work Quarters Override Income" => {
            "Indicator" => "N", "Ineligibility Code" => 340,
            "Ineligibility Reason" => "Income is greater than 100% FPL"
          }, "State Health Benefits CHIP" => {
            "Indicator" => "X"
          }, "CHIP Waiting Period Satisfied" => {
            "Indicator" => "X"
          }, "Dependent Child Covered" => {
            "Indicator" => "X"
          }, "Medicaid Non-MAGI Referral" => {
            "Indicator" => "N", "Ineligibility Code" => 108,
            "Ineligibility Reason" => "Applicant does not meet requirements for a non-MAGI referral"
          }, "Emergency Medicaid" => {
            "Indicator" => "N", "Ineligibility Code" => 109,
            "Ineligibility Reason" => "Applicant does not meet the eligibility criteria for emergency Medicaid"
          }, "Refugee Medical Assistance" => {
            "Indicator" => "X"
          }, "APTC Referral" => {
            "Indicator" => "Y"
          }
        },
        "Other Outputs" => {
          "Qualified Children List" => []
        }
      }, {
        "Person ID" => 1_002_537,
        "Medicaid Household" => {
          "People" => [1_002_507, 1_002_537], "MAGI" => 35_360, "MAGI as Percentage of FPL" => 202, "Size" => 2
        },
        "Medicaid Eligible" => "N",
        "CHIP Eligible" => "Y",
        "Ineligibility Reason" => ["Applicant's MAGI above the threshold for category"],
        "Non-MAGI Referral" => "N",
        "Category" => "Child Category",
        "Category Threshold" => 28_220,
        "CHIP Category" => "CHIP Targeted Low Income Child",
        "CHIP Category Threshold" => 37_104,
        "Determinations" => {
          "Residency" => {
            "Indicator" => "Y"
          }, "Adult Group Category" => {
            "Indicator" => "N", "Ineligibility Code" => 123,
            "Ineligibility Reason" => "Applicant is not between the ages of 19 and 64 (inclusive)"
          }, "Parent Caretaker Category" => {
            "Indicator" => "N", "Ineligibility Code" => 146,
            "Ineligibility Reason" => "No child met all criteria for parent caretaker category"
          }, "Pregnancy Category" => {
            "Indicator" => "N", "Ineligibility Code" => 124,
            "Ineligibility Reason" => "Applicant not pregnant or within postpartum period"
          }, "Child Category" => {
            "Indicator" => "Y"
          }, "Optional Targeted Low Income Child" => {
            "Indicator" => "X"
          }, "CHIP Targeted Low Income Child" => {
            "Indicator" => "Y"
          }, "Unborn Child" => {
            "Indicator" => "X"
          }, "Income Medicaid Eligible" => {
            "Indicator" => "N", "Ineligibility Code" => 402,
            "Ineligibility Reason" => "Applicant's income is greater than the threshold for all eligible categories"
          }, "Income CHIP Eligible" => {
            "Indicator" => "Y"
          }, "Medicaid CHIPRA 214" => {
            "Indicator" => "X"
          }, "CHIP CHIPRA 214" => {
            "Indicator" => "X"
          }, "Trafficking Victim" => {
            "Indicator" => "X"
          }, "Seven Year Limit" => {
            "Indicator" => "X"
          }, "Five Year Bar" => {
            "Indicator" => "X"
          }, "Title II Work Quarters Met" => {
            "Indicator" => "X"
          }, "Medicaid Citizen Or Immigrant" => {
            "Indicator" => "Y"
          }, "CHIP Citizen Or Immigrant" => {
            "Indicator" => "Y"
          }, "Former Foster Care Category" => {
            "Indicator" => "N", "Ineligibility Code" => 400,
            "Ineligibility Reason" => "Applicant was not formerly in foster care"
          }, "Work Quarters Override Income" => {
            "Indicator" => "N", "Ineligibility Code" => 340,
            "Ineligibility Reason" => "Income is greater than 100% FPL"
          }, "State Health Benefits CHIP" => {
            "Indicator" => "X"
          }, "CHIP Waiting Period Satisfied" => {
            "Indicator" => "X"
          }, "Dependent Child Covered" => {
            "Indicator" => "X"
          }, "Medicaid Non-MAGI Referral" => {
            "Indicator" => "N", "Ineligibility Code" => 108,
            "Ineligibility Reason" => "Applicant does not meet requirements for a non-MAGI referral"
          }, "Emergency Medicaid" => {
            "Indicator" => "N", "Ineligibility Code" => 109,
            "Ineligibility Reason" => "Applicant does not meet the eligibility criteria for emergency Medicaid"
          }, "Refugee Medical Assistance" => {
            "Indicator" => "X"
          }, "APTC Referral" => {
            "Indicator" => "Y"
          }
        },
        "Other Outputs" => {
          "Qualified Children List" => []
        }
      }]
    }
  end

  let(:mitc_response) do
    mitc_string_response.deep_symbolize_keys
  end
end
