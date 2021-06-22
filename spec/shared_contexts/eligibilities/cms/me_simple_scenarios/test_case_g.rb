# frozen_string_literal: true

# Summary: In this simple scenario, a single consumer (age 22) applies for financial assistance.
# He attests to job income and to a recent Medicaid denial. The application should include follow-up
# questions about his Medicaid denial to determine whether he originally applied during open enrollment
# or after a qualifying life event as well as the date of the denial.
# Despite income below the Medicaid limit, the consumer is found QHP, APTC, CSR and
# SEP eligible due to the Medicaid denial attestation.

# rubocop:disable Layout/LineLength
RSpec.shared_context 'cms ME simple_scenarios test_case_g', :shared_context => :metadata do
  let(:app_params) do
    {
      "family_reference" => {
        "hbx_id" => "10261"
      }, "assistance_year" => 2021, "aptc_effective_date" => "2021-08-01T00:00:00.000+00:00", "years_to_renew" => nil, "renewal_consent_through_year" => 5, "is_ridp_verified" => true, "is_renewal_authorized" => true, "applicants" => [{
        "name" => {
          "first_name" => "ClaytonG", "middle_name" => nil, "last_name" => "MorganG", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw==", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Male", "dob" => "1981-01-01", "ethnicity" => ["", "", "", "", "", "",
                                                                     ""], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false
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
          "family_member_hbx_id" => "1002584", "first_name" => "ClaytonG", "last_name" => "MorganG", "person_hbx_id" => "1002584", "is_primary_family_member" => true
        },
        "person_hbx_id" => "1002584",
        "is_required_to_file_taxes" => true,
        "tax_filer_kind" => "tax_filer",
        "is_joint_tax_filing" => true,
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
          "not_eligible_in_last_90_days" => false, "denied_on" => nil, "ended_as_change_in_eligibility" => false, "hh_income_or_size_changed" => false, "medicaid_or_chip_coverage_end_date" => nil, "ineligible_due_to_immigration_in_last_5_years" => false, "immigration_status_changed_since_ineligibility" => false
        },
        "other_health_service" => {
          "has_received" => false, "is_eligible" => false
        },
        "addresses" => [{
          "kind" => "home",
          "address_1" => "1470 main street",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "palmyra",
          "county" => "Franklin",
          "state" => "ME",
          "zip" => "04225",
          "country_name" => nil
        }],
        "emails" => [],
        "phones" => [],
        "incomes" => [{
          "title" => nil,
          "kind" => "wages_and_salaries",
          "wage_type" => nil,
          "hours_per_week" => nil,
          "amount" => "63583.0",
          "amount_tax_exempt" => "0.0",
          "frequency_kind" => "Annually",
          "start_on" => "2020-10-01",
          "end_on" => nil,
          "is_projected" => false,
          "employer" => {
            "employer_name" => "clayco", "employer_id" => nil
          },
          "has_property_usage_rights" => nil,
          "submitted_at" => "2021-06-22T15:03:35.000+00:00"
        }],
        "benefits" => [],
        "deductions" => [{
          "name" => nil,
          "kind" => "alimony_paid",
          "amount" => "100.0",
          "start_on" => "2020-10-01",
          "end_on" => nil,
          "frequency_kind" => "BiWeekly",
          "submitted_at" => "2021-06-22T15:03:35.000+00:00"
        }, {
          "name" => nil,
          "kind" => "student_loan_interest",
          "amount" => "3183.0",
          "start_on" => "2020-10-01",
          "end_on" => nil,
          "frequency_kind" => "Annually",
          "submitted_at" => "2021-06-22T15:03:35.000+00:00"
        }],
        "is_medicare_eligible" => false,
        "has_insurance" => false,
        "has_state_health_benefit" => false,
        "had_prior_insurance" => false,
        "prior_insurance_end_date" => nil,
        "age_of_applicant" => 40,
        "is_self_attested_long_term_care" => false,
        "hours_worked_per_week" => 0,
        "is_temporarily_out_of_state" => false,
        "is_claimed_as_dependent_by_non_applicant" => false,
        "benchmark_premium" => {
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1002584",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002592",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002593",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002594",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002595",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002596",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002597",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002598",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002599",
            "monthly_premium" => "310.5"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1002584",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002592",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002593",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002594",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002595",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002596",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002597",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002598",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002599",
            "monthly_premium" => "310.5"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 63_583, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 2600, "adjusted_gross_income" => 57_800, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 3183, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_002_592,
          "attest_primary_responsibility" => "Y",
          "relationship_code" => "02"
        }, {
          "other_id" => 1_002_593,
          "attest_primary_responsibility" => "Y",
          "relationship_code" => "03"
        }, {
          "other_id" => 1_002_594,
          "attest_primary_responsibility" => "Y",
          "relationship_code" => "03"
        }, {
          "other_id" => 1_002_595,
          "attest_primary_responsibility" => "Y",
          "relationship_code" => "03"
        }, {
          "other_id" => 1_002_596,
          "attest_primary_responsibility" => "Y",
          "relationship_code" => "03"
        }, {
          "other_id" => 1_002_597,
          "attest_primary_responsibility" => "Y",
          "relationship_code" => "03"
        }, {
          "other_id" => 1_002_598,
          "attest_primary_responsibility" => "Y",
          "relationship_code" => "03"
        }, {
          "other_id" => 1_002_599,
          "attest_primary_responsibility" => "Y",
          "relationship_code" => "03"
        }]
      }, {
        "name" => {
          "first_name" => "AlbaG", "middle_name" => nil, "last_name" => "MorganG", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA==", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Female", "dob" => "1981-01-01", "ethnicity" => [], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false
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
          "family_member_hbx_id" => "1002592", "first_name" => "AlbaG", "last_name" => "MorganG", "person_hbx_id" => "1002592", "is_primary_family_member" => false
        },
        "person_hbx_id" => "1002592",
        "is_required_to_file_taxes" => true,
        "tax_filer_kind" => "tax_filer",
        "is_joint_tax_filing" => true,
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
        "has_job_income" => true,
        "has_self_employment_income" => false,
        "has_unemployment_income" => false,
        "has_other_income" => false,
        "has_deductions" => true,
        "has_enrolled_health_coverage" => true,
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
          "address_1" => "1470 main street",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "palmyra",
          "county" => "Franklin",
          "state" => "ME",
          "zip" => "04225",
          "country_name" => nil
        }],
        "emails" => [],
        "phones" => [],
        "incomes" => [{
          "title" => nil,
          "kind" => "wages_and_salaries",
          "wage_type" => nil,
          "hours_per_week" => nil,
          "amount" => "38675.0",
          "amount_tax_exempt" => "0.0",
          "frequency_kind" => "Annually",
          "start_on" => "2020-10-01",
          "end_on" => nil,
          "is_projected" => false,
          "employer" => {
            "employer_name" => "clayco", "employer_id" => nil
          },
          "has_property_usage_rights" => nil,
          "submitted_at" => "2021-06-22T15:03:35.000+00:00"
        }],
        "benefits" => [{
          "name" => nil,
          "kind" => "peace_corps_health_benefits",
          "status" => "is_enrolled",
          "is_employer_sponsored" => false,
          "employer" => nil,
          "esi_covered" => nil,
          "is_esi_waiting_period" => false,
          "is_esi_mec_met" => false,
          "employee_cost" => "0.0",
          "employee_cost_frequency" => nil,
          "start_on" => "2020-10-01",
          "end_on" => nil,
          "submitted_at" => "2021-06-22T15:03:35.000+00:00",
          "hra_kind" => nil
        }],
        "deductions" => [{
          "name" => nil,
          "kind" => "student_loan_interest",
          "amount" => "300.0",
          "start_on" => "2020-10-01",
          "end_on" => nil,
          "frequency_kind" => "Monthly",
          "submitted_at" => "2021-06-22T15:03:35.000+00:00"
        }],
        "is_medicare_eligible" => false,
        "has_insurance" => true,
        "has_state_health_benefit" => false,
        "had_prior_insurance" => false,
        "prior_insurance_end_date" => nil,
        "age_of_applicant" => 40,
        "is_self_attested_long_term_care" => false,
        "hours_worked_per_week" => 0,
        "is_temporarily_out_of_state" => false,
        "is_claimed_as_dependent_by_non_applicant" => false,
        "benchmark_premium" => {
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1002584",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002592",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002593",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002594",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002595",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002596",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002597",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002598",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002599",
            "monthly_premium" => "310.5"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1002584",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002592",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002593",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002594",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002595",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002596",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002597",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002598",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002599",
            "monthly_premium" => "310.5"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 38_675, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 35_075, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 3600, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_002_584,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "02"
        }, {
          "other_id" => 1_002_593,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "03"
        }, {
          "other_id" => 1_002_594,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "03"
        }, {
          "other_id" => 1_002_595,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "03"
        }, {
          "other_id" => 1_002_596,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "03"
        }, {
          "other_id" => 1_002_597,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "03"
        }, {
          "other_id" => 1_002_598,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "03"
        }, {
          "other_id" => 1_002_599,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "03"
        }]
      }, {
        "name" => {
          "first_name" => "AvyaG", "middle_name" => nil, "last_name" => "MorganG", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "QEVuQwEAa/tp2tSuacp+9l2gHOvOHQ==", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Female", "dob" => "2013-01-01", "ethnicity" => [], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => true, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false
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
          "family_member_hbx_id" => "1002593", "first_name" => "AvyaG", "last_name" => "MorganG", "person_hbx_id" => "1002593", "is_primary_family_member" => false
        },
        "person_hbx_id" => "1002593",
        "is_required_to_file_taxes" => false,
        "tax_filer_kind" => "dependent",
        "is_joint_tax_filing" => false,
        "is_claimed_as_tax_dependent" => true,
        "claimed_as_tax_dependent_by" => {
          "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
        },
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
        "has_self_employment_income" => false,
        "has_unemployment_income" => false,
        "has_other_income" => false,
        "has_deductions" => false,
        "has_enrolled_health_coverage" => false,
        "has_eligible_health_coverage" => false,
        "job_coverage_ended_in_past_3_months" => false,
        "job_coverage_end_date" => nil,
        "medicaid_and_chip" => {
          "not_eligible_in_last_90_days" => true, "denied_on" => "2021-05-31", "ended_as_change_in_eligibility" => false, "hh_income_or_size_changed" => false, "medicaid_or_chip_coverage_end_date" => nil, "ineligible_due_to_immigration_in_last_5_years" => false, "immigration_status_changed_since_ineligibility" => false
        },
        "other_health_service" => {
          "has_received" => false, "is_eligible" => false
        },
        "addresses" => [{
          "kind" => "home",
          "address_1" => "1470 main street",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "palmyra",
          "county" => "Franklin",
          "state" => "ME",
          "zip" => "04225",
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
        "age_of_applicant" => 8,
        "is_self_attested_long_term_care" => false,
        "hours_worked_per_week" => 0,
        "is_temporarily_out_of_state" => false,
        "is_claimed_as_dependent_by_non_applicant" => false,
        "benchmark_premium" => {
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1002584",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002592",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002593",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002594",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002595",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002596",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002597",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002598",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002599",
            "monthly_premium" => "310.5"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1002584",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002592",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002593",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002594",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002595",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002596",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002597",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002598",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002599",
            "monthly_premium" => "310.5"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 0, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 0, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_002_584,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }, {
          "other_id" => 1_002_594,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_595,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_596,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_597,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_598,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_599,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_592,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }]
      }, {
        "name" => {
          "first_name" => "SafiG", "middle_name" => nil, "last_name" => "MorganG", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "QEVuQwEAlhXYuv7FJmROSQdvd8DzuQ==", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Female", "dob" => "2011-01-01", "ethnicity" => [], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false
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
          "family_member_hbx_id" => "1002594", "first_name" => "SafiG", "last_name" => "MorganG", "person_hbx_id" => "1002594", "is_primary_family_member" => false
        },
        "person_hbx_id" => "1002594",
        "is_required_to_file_taxes" => false,
        "tax_filer_kind" => "dependent",
        "is_joint_tax_filing" => false,
        "is_claimed_as_tax_dependent" => true,
        "claimed_as_tax_dependent_by" => {
          "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
        },
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
        "has_self_employment_income" => false,
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
          "address_1" => "1470 main street",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "palmyra",
          "county" => "Franklin",
          "state" => "ME",
          "zip" => "04225",
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
        "age_of_applicant" => 10,
        "is_self_attested_long_term_care" => false,
        "hours_worked_per_week" => 0,
        "is_temporarily_out_of_state" => false,
        "is_claimed_as_dependent_by_non_applicant" => false,
        "benchmark_premium" => {
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1002584",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002592",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002593",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002594",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002595",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002596",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002597",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002598",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002599",
            "monthly_premium" => "310.5"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1002584",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002592",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002593",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002594",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002595",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002596",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002597",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002598",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002599",
            "monthly_premium" => "310.5"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 0, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 0, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_002_584,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }, {
          "other_id" => 1_002_593,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_595,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_596,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_597,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_598,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_599,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_592,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }]
      }, {
        "name" => {
          "first_name" => "DaphneG", "middle_name" => nil, "last_name" => "MorganG", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "QEVuQwEAyA2o6iin8v0w4q0rIHnALQ==", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Female", "dob" => "2009-01-01", "ethnicity" => [], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false
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
          "family_member_hbx_id" => "1002595", "first_name" => "DaphneG", "last_name" => "MorganG", "person_hbx_id" => "1002595", "is_primary_family_member" => false
        },
        "person_hbx_id" => "1002595",
        "is_required_to_file_taxes" => false,
        "tax_filer_kind" => "dependent",
        "is_joint_tax_filing" => false,
        "is_claimed_as_tax_dependent" => true,
        "claimed_as_tax_dependent_by" => {
          "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
        },
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
        "has_daily_living_help" => true,
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
          "not_eligible_in_last_90_days" => false, "denied_on" => nil, "ended_as_change_in_eligibility" => false, "hh_income_or_size_changed" => false, "medicaid_or_chip_coverage_end_date" => nil, "ineligible_due_to_immigration_in_last_5_years" => false, "immigration_status_changed_since_ineligibility" => false
        },
        "other_health_service" => {
          "has_received" => false, "is_eligible" => false
        },
        "addresses" => [{
          "kind" => "home",
          "address_1" => "1470 main street",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "palmyra",
          "county" => "Franklin",
          "state" => "ME",
          "zip" => "04225",
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
        "age_of_applicant" => 12,
        "is_self_attested_long_term_care" => false,
        "hours_worked_per_week" => 0,
        "is_temporarily_out_of_state" => false,
        "is_claimed_as_dependent_by_non_applicant" => false,
        "benchmark_premium" => {
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1002584",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002592",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002593",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002594",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002595",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002596",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002597",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002598",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002599",
            "monthly_premium" => "310.5"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1002584",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002592",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002593",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002594",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002595",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002596",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002597",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002598",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002599",
            "monthly_premium" => "310.5"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 0, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 0, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_002_584,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }, {
          "other_id" => 1_002_593,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_594,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_596,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_597,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_598,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_599,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_592,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }]
      }, {
        "name" => {
          "first_name" => "HareemG", "middle_name" => nil, "last_name" => "MorganG", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "QEVuQwEAZc6FWGr6C0IROr4+yJMJTw==", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Female", "dob" => "2007-01-01", "ethnicity" => [], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false
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
          "family_member_hbx_id" => "1002596", "first_name" => "HareemG", "last_name" => "MorganG", "person_hbx_id" => "1002596", "is_primary_family_member" => false
        },
        "person_hbx_id" => "1002596",
        "is_required_to_file_taxes" => false,
        "tax_filer_kind" => "dependent",
        "is_joint_tax_filing" => false,
        "is_claimed_as_tax_dependent" => true,
        "claimed_as_tax_dependent_by" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        },
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
        "has_self_employment_income" => false,
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
          "address_1" => "1470 main street",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "palmyra",
          "county" => "Franklin",
          "state" => "ME",
          "zip" => "04225",
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
        "age_of_applicant" => 14,
        "is_self_attested_long_term_care" => false,
        "hours_worked_per_week" => 0,
        "is_temporarily_out_of_state" => false,
        "is_claimed_as_dependent_by_non_applicant" => false,
        "benchmark_premium" => {
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1002584",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002592",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002593",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002594",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002595",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002596",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002597",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002598",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002599",
            "monthly_premium" => "310.5"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1002584",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002592",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002593",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002594",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002595",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002596",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002597",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002598",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002599",
            "monthly_premium" => "310.5"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 0, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 0, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_002_584,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }, {
          "other_id" => 1_002_593,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_594,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_595,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_597,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_598,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_599,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_592,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }]
      }, {
        "name" => {
          "first_name" => "TheoG", "middle_name" => nil, "last_name" => "MorganG", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "QEVuQwEA5zFJVnmzWsCYpa5WejlkZg==", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Male", "dob" => "2005-01-01", "ethnicity" => [], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false
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
          "family_member_hbx_id" => "1002597", "first_name" => "TheoG", "last_name" => "MorganG", "person_hbx_id" => "1002597", "is_primary_family_member" => false
        },
        "person_hbx_id" => "1002597",
        "is_required_to_file_taxes" => false,
        "tax_filer_kind" => "dependent",
        "is_joint_tax_filing" => false,
        "is_claimed_as_tax_dependent" => true,
        "claimed_as_tax_dependent_by" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        },
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
          "address_1" => "1470 main street",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "palmyra",
          "county" => "Franklin",
          "state" => "ME",
          "zip" => "04225",
          "country_name" => nil
        }],
        "emails" => [],
        "phones" => [],
        "incomes" => [{
          "title" => nil,
          "kind" => "net_self_employment",
          "wage_type" => nil,
          "hours_per_week" => nil,
          "amount" => "50.0",
          "amount_tax_exempt" => "0.0",
          "frequency_kind" => "Monthly",
          "start_on" => "2021-04-01",
          "end_on" => "2021-09-30",
          "is_projected" => false,
          "employer" => nil,
          "has_property_usage_rights" => nil,
          "submitted_at" => "2021-06-22T15:03:36.000+00:00"
        }],
        "benefits" => [],
        "deductions" => [],
        "is_medicare_eligible" => false,
        "has_insurance" => false,
        "has_state_health_benefit" => false,
        "had_prior_insurance" => false,
        "prior_insurance_end_date" => nil,
        "age_of_applicant" => 16,
        "is_self_attested_long_term_care" => false,
        "hours_worked_per_week" => 0,
        "is_temporarily_out_of_state" => false,
        "is_claimed_as_dependent_by_non_applicant" => false,
        "benchmark_premium" => {
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1002584",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002592",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002593",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002594",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002595",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002596",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002597",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002598",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002599",
            "monthly_premium" => "310.5"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1002584",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002592",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002593",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002594",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002595",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002596",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002597",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002598",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002599",
            "monthly_premium" => "310.5"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 600, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 300, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_002_584,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }, {
          "other_id" => 1_002_593,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_594,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_595,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_596,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_598,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_599,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_592,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }]
      }, {
        "name" => {
          "first_name" => "MichG", "middle_name" => nil, "last_name" => "MorganG", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "QEVuQwEAMAuMlqnCrW9SY9UdoAudZg==", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Male", "dob" => "2005-01-01", "ethnicity" => [], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false
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
          "family_member_hbx_id" => "1002598", "first_name" => "MichG", "last_name" => "MorganG", "person_hbx_id" => "1002598", "is_primary_family_member" => false
        },
        "person_hbx_id" => "1002598",
        "is_required_to_file_taxes" => false,
        "tax_filer_kind" => "dependent",
        "is_joint_tax_filing" => false,
        "is_claimed_as_tax_dependent" => true,
        "claimed_as_tax_dependent_by" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        },
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
        "has_self_employment_income" => false,
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
          "address_1" => "1470 main street",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "palmyra",
          "county" => "Franklin",
          "state" => "ME",
          "zip" => "04225",
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
        "age_of_applicant" => 16,
        "is_self_attested_long_term_care" => false,
        "hours_worked_per_week" => 0,
        "is_temporarily_out_of_state" => false,
        "is_claimed_as_dependent_by_non_applicant" => false,
        "benchmark_premium" => {
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1002584",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002592",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002593",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002594",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002595",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002596",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002597",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002598",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002599",
            "monthly_premium" => "310.5"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1002584",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002592",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002593",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002594",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002595",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002596",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002597",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002598",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002599",
            "monthly_premium" => "310.5"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 0, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 0, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_002_584,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }, {
          "other_id" => 1_002_593,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_594,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_595,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_596,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_597,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_599,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_592,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }]
      }, {
        "name" => {
          "first_name" => "HughG", "middle_name" => nil, "last_name" => "MorganG", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "QEVuQwEAqRFJWhvn+8NUysxJJiOorA==", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Male", "dob" => "2003-01-01", "ethnicity" => [], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false
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
          "family_member_hbx_id" => "1002599", "first_name" => "HughG", "last_name" => "MorganG", "person_hbx_id" => "1002599", "is_primary_family_member" => false
        },
        "person_hbx_id" => "1002599",
        "is_required_to_file_taxes" => false,
        "tax_filer_kind" => "dependent",
        "is_joint_tax_filing" => false,
        "is_claimed_as_tax_dependent" => true,
        "claimed_as_tax_dependent_by" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        },
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
        "has_self_employment_income" => false,
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
          "address_1" => "1470 main street",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "palmyra",
          "county" => "Franklin",
          "state" => "ME",
          "zip" => "04225",
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
        "age_of_applicant" => 18,
        "is_self_attested_long_term_care" => false,
        "hours_worked_per_week" => 0,
        "is_temporarily_out_of_state" => false,
        "is_claimed_as_dependent_by_non_applicant" => false,
        "benchmark_premium" => {
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1002584",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002592",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002593",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002594",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002595",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002596",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002597",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002598",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002599",
            "monthly_premium" => "310.5"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1002584",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002592",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002593",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002594",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002595",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002596",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002597",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002598",
            "monthly_premium" => "310.5"
          }, {
            "member_identifier" => "1002599",
            "monthly_premium" => "310.5"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 0, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 0, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_002_584,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }, {
          "other_id" => 1_002_593,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_594,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_595,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_596,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_597,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_598,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_002_592,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }]
      }], "tax_households" => [{
        "max_aptc" => "0.0",
        "hbx_id" => "10306",
        "is_insurance_assistance_eligible" => nil,
        "tax_household_members" => [{
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
          }
        }, {
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
          }
        }, {
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "AvyaG", "last_name" => "MorganG", "dob" => "2013-01-01", "person_hbx_id" => "1002593", "encrypted_ssn" => "QEVuQwEAa/tp2tSuacp+9l2gHOvOHQ=="
          }
        }, {
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "SafiG", "last_name" => "MorganG", "dob" => "2011-01-01", "person_hbx_id" => "1002594", "encrypted_ssn" => "QEVuQwEAlhXYuv7FJmROSQdvd8DzuQ=="
          }
        }, {
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "DaphneG", "last_name" => "MorganG", "dob" => "2009-01-01", "person_hbx_id" => "1002595", "encrypted_ssn" => "QEVuQwEAyA2o6iin8v0w4q0rIHnALQ=="
          }
        }, {
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "HareemG", "last_name" => "MorganG", "dob" => "2007-01-01", "person_hbx_id" => "1002596", "encrypted_ssn" => "QEVuQwEAZc6FWGr6C0IROr4+yJMJTw=="
          }
        }, {
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "TheoG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002597", "encrypted_ssn" => "QEVuQwEA5zFJVnmzWsCYpa5WejlkZg=="
          }
        }, {
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "MichG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002598", "encrypted_ssn" => "QEVuQwEAMAuMlqnCrW9SY9UdoAudZg=="
          }
        }, {
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "HughG", "last_name" => "MorganG", "dob" => "2003-01-01", "person_hbx_id" => "1002599", "encrypted_ssn" => "QEVuQwEAqRFJWhvn+8NUysxJJiOorA=="
          }
        }],
        "annual_tax_household_income" => "0.0"
      }], "relationships" => [{
        "kind" => "spouse",
        "applicant_reference" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        },
        "relative_reference" => {
          "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
        }
      }, {
        "kind" => "spouse",
        "applicant_reference" => {
          "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
        },
        "relative_reference" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "AvyaG", "last_name" => "MorganG", "dob" => "2013-01-01", "person_hbx_id" => "1002593", "encrypted_ssn" => "QEVuQwEAa/tp2tSuacp+9l2gHOvOHQ=="
        },
        "relative_reference" => {
          "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
        },
        "relative_reference" => {
          "first_name" => "AvyaG", "last_name" => "MorganG", "dob" => "2013-01-01", "person_hbx_id" => "1002593", "encrypted_ssn" => "QEVuQwEAa/tp2tSuacp+9l2gHOvOHQ=="
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "SafiG", "last_name" => "MorganG", "dob" => "2011-01-01", "person_hbx_id" => "1002594", "encrypted_ssn" => "QEVuQwEAlhXYuv7FJmROSQdvd8DzuQ=="
        },
        "relative_reference" => {
          "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
        },
        "relative_reference" => {
          "first_name" => "SafiG", "last_name" => "MorganG", "dob" => "2011-01-01", "person_hbx_id" => "1002594", "encrypted_ssn" => "QEVuQwEAlhXYuv7FJmROSQdvd8DzuQ=="
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "DaphneG", "last_name" => "MorganG", "dob" => "2009-01-01", "person_hbx_id" => "1002595", "encrypted_ssn" => "QEVuQwEAyA2o6iin8v0w4q0rIHnALQ=="
        },
        "relative_reference" => {
          "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
        },
        "relative_reference" => {
          "first_name" => "DaphneG", "last_name" => "MorganG", "dob" => "2009-01-01", "person_hbx_id" => "1002595", "encrypted_ssn" => "QEVuQwEAyA2o6iin8v0w4q0rIHnALQ=="
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "HareemG", "last_name" => "MorganG", "dob" => "2007-01-01", "person_hbx_id" => "1002596", "encrypted_ssn" => "QEVuQwEAZc6FWGr6C0IROr4+yJMJTw=="
        },
        "relative_reference" => {
          "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
        },
        "relative_reference" => {
          "first_name" => "HareemG", "last_name" => "MorganG", "dob" => "2007-01-01", "person_hbx_id" => "1002596", "encrypted_ssn" => "QEVuQwEAZc6FWGr6C0IROr4+yJMJTw=="
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "TheoG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002597", "encrypted_ssn" => "QEVuQwEA5zFJVnmzWsCYpa5WejlkZg=="
        },
        "relative_reference" => {
          "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
        },
        "relative_reference" => {
          "first_name" => "TheoG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002597", "encrypted_ssn" => "QEVuQwEA5zFJVnmzWsCYpa5WejlkZg=="
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "MichG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002598", "encrypted_ssn" => "QEVuQwEAMAuMlqnCrW9SY9UdoAudZg=="
        },
        "relative_reference" => {
          "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
        },
        "relative_reference" => {
          "first_name" => "MichG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002598", "encrypted_ssn" => "QEVuQwEAMAuMlqnCrW9SY9UdoAudZg=="
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "HughG", "last_name" => "MorganG", "dob" => "2003-01-01", "person_hbx_id" => "1002599", "encrypted_ssn" => "QEVuQwEAqRFJWhvn+8NUysxJJiOorA=="
        },
        "relative_reference" => {
          "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "ClaytonG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002584", "encrypted_ssn" => "QEVuQwEAA+DGLRuFsWQtI/eUxhltLw=="
        },
        "relative_reference" => {
          "first_name" => "HughG", "last_name" => "MorganG", "dob" => "2003-01-01", "person_hbx_id" => "1002599", "encrypted_ssn" => "QEVuQwEAqRFJWhvn+8NUysxJJiOorA=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "AvyaG", "last_name" => "MorganG", "dob" => "2013-01-01", "person_hbx_id" => "1002593", "encrypted_ssn" => "QEVuQwEAa/tp2tSuacp+9l2gHOvOHQ=="
        },
        "relative_reference" => {
          "first_name" => "SafiG", "last_name" => "MorganG", "dob" => "2011-01-01", "person_hbx_id" => "1002594", "encrypted_ssn" => "QEVuQwEAlhXYuv7FJmROSQdvd8DzuQ=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "SafiG", "last_name" => "MorganG", "dob" => "2011-01-01", "person_hbx_id" => "1002594", "encrypted_ssn" => "QEVuQwEAlhXYuv7FJmROSQdvd8DzuQ=="
        },
        "relative_reference" => {
          "first_name" => "AvyaG", "last_name" => "MorganG", "dob" => "2013-01-01", "person_hbx_id" => "1002593", "encrypted_ssn" => "QEVuQwEAa/tp2tSuacp+9l2gHOvOHQ=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "AvyaG", "last_name" => "MorganG", "dob" => "2013-01-01", "person_hbx_id" => "1002593", "encrypted_ssn" => "QEVuQwEAa/tp2tSuacp+9l2gHOvOHQ=="
        },
        "relative_reference" => {
          "first_name" => "DaphneG", "last_name" => "MorganG", "dob" => "2009-01-01", "person_hbx_id" => "1002595", "encrypted_ssn" => "QEVuQwEAyA2o6iin8v0w4q0rIHnALQ=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "DaphneG", "last_name" => "MorganG", "dob" => "2009-01-01", "person_hbx_id" => "1002595", "encrypted_ssn" => "QEVuQwEAyA2o6iin8v0w4q0rIHnALQ=="
        },
        "relative_reference" => {
          "first_name" => "AvyaG", "last_name" => "MorganG", "dob" => "2013-01-01", "person_hbx_id" => "1002593", "encrypted_ssn" => "QEVuQwEAa/tp2tSuacp+9l2gHOvOHQ=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "SafiG", "last_name" => "MorganG", "dob" => "2011-01-01", "person_hbx_id" => "1002594", "encrypted_ssn" => "QEVuQwEAlhXYuv7FJmROSQdvd8DzuQ=="
        },
        "relative_reference" => {
          "first_name" => "DaphneG", "last_name" => "MorganG", "dob" => "2009-01-01", "person_hbx_id" => "1002595", "encrypted_ssn" => "QEVuQwEAyA2o6iin8v0w4q0rIHnALQ=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "DaphneG", "last_name" => "MorganG", "dob" => "2009-01-01", "person_hbx_id" => "1002595", "encrypted_ssn" => "QEVuQwEAyA2o6iin8v0w4q0rIHnALQ=="
        },
        "relative_reference" => {
          "first_name" => "SafiG", "last_name" => "MorganG", "dob" => "2011-01-01", "person_hbx_id" => "1002594", "encrypted_ssn" => "QEVuQwEAlhXYuv7FJmROSQdvd8DzuQ=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "AvyaG", "last_name" => "MorganG", "dob" => "2013-01-01", "person_hbx_id" => "1002593", "encrypted_ssn" => "QEVuQwEAa/tp2tSuacp+9l2gHOvOHQ=="
        },
        "relative_reference" => {
          "first_name" => "HareemG", "last_name" => "MorganG", "dob" => "2007-01-01", "person_hbx_id" => "1002596", "encrypted_ssn" => "QEVuQwEAZc6FWGr6C0IROr4+yJMJTw=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "HareemG", "last_name" => "MorganG", "dob" => "2007-01-01", "person_hbx_id" => "1002596", "encrypted_ssn" => "QEVuQwEAZc6FWGr6C0IROr4+yJMJTw=="
        },
        "relative_reference" => {
          "first_name" => "AvyaG", "last_name" => "MorganG", "dob" => "2013-01-01", "person_hbx_id" => "1002593", "encrypted_ssn" => "QEVuQwEAa/tp2tSuacp+9l2gHOvOHQ=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "SafiG", "last_name" => "MorganG", "dob" => "2011-01-01", "person_hbx_id" => "1002594", "encrypted_ssn" => "QEVuQwEAlhXYuv7FJmROSQdvd8DzuQ=="
        },
        "relative_reference" => {
          "first_name" => "HareemG", "last_name" => "MorganG", "dob" => "2007-01-01", "person_hbx_id" => "1002596", "encrypted_ssn" => "QEVuQwEAZc6FWGr6C0IROr4+yJMJTw=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "HareemG", "last_name" => "MorganG", "dob" => "2007-01-01", "person_hbx_id" => "1002596", "encrypted_ssn" => "QEVuQwEAZc6FWGr6C0IROr4+yJMJTw=="
        },
        "relative_reference" => {
          "first_name" => "SafiG", "last_name" => "MorganG", "dob" => "2011-01-01", "person_hbx_id" => "1002594", "encrypted_ssn" => "QEVuQwEAlhXYuv7FJmROSQdvd8DzuQ=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "DaphneG", "last_name" => "MorganG", "dob" => "2009-01-01", "person_hbx_id" => "1002595", "encrypted_ssn" => "QEVuQwEAyA2o6iin8v0w4q0rIHnALQ=="
        },
        "relative_reference" => {
          "first_name" => "HareemG", "last_name" => "MorganG", "dob" => "2007-01-01", "person_hbx_id" => "1002596", "encrypted_ssn" => "QEVuQwEAZc6FWGr6C0IROr4+yJMJTw=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "HareemG", "last_name" => "MorganG", "dob" => "2007-01-01", "person_hbx_id" => "1002596", "encrypted_ssn" => "QEVuQwEAZc6FWGr6C0IROr4+yJMJTw=="
        },
        "relative_reference" => {
          "first_name" => "DaphneG", "last_name" => "MorganG", "dob" => "2009-01-01", "person_hbx_id" => "1002595", "encrypted_ssn" => "QEVuQwEAyA2o6iin8v0w4q0rIHnALQ=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "AvyaG", "last_name" => "MorganG", "dob" => "2013-01-01", "person_hbx_id" => "1002593", "encrypted_ssn" => "QEVuQwEAa/tp2tSuacp+9l2gHOvOHQ=="
        },
        "relative_reference" => {
          "first_name" => "TheoG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002597", "encrypted_ssn" => "QEVuQwEA5zFJVnmzWsCYpa5WejlkZg=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "TheoG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002597", "encrypted_ssn" => "QEVuQwEA5zFJVnmzWsCYpa5WejlkZg=="
        },
        "relative_reference" => {
          "first_name" => "AvyaG", "last_name" => "MorganG", "dob" => "2013-01-01", "person_hbx_id" => "1002593", "encrypted_ssn" => "QEVuQwEAa/tp2tSuacp+9l2gHOvOHQ=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "SafiG", "last_name" => "MorganG", "dob" => "2011-01-01", "person_hbx_id" => "1002594", "encrypted_ssn" => "QEVuQwEAlhXYuv7FJmROSQdvd8DzuQ=="
        },
        "relative_reference" => {
          "first_name" => "TheoG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002597", "encrypted_ssn" => "QEVuQwEA5zFJVnmzWsCYpa5WejlkZg=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "TheoG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002597", "encrypted_ssn" => "QEVuQwEA5zFJVnmzWsCYpa5WejlkZg=="
        },
        "relative_reference" => {
          "first_name" => "SafiG", "last_name" => "MorganG", "dob" => "2011-01-01", "person_hbx_id" => "1002594", "encrypted_ssn" => "QEVuQwEAlhXYuv7FJmROSQdvd8DzuQ=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "DaphneG", "last_name" => "MorganG", "dob" => "2009-01-01", "person_hbx_id" => "1002595", "encrypted_ssn" => "QEVuQwEAyA2o6iin8v0w4q0rIHnALQ=="
        },
        "relative_reference" => {
          "first_name" => "TheoG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002597", "encrypted_ssn" => "QEVuQwEA5zFJVnmzWsCYpa5WejlkZg=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "TheoG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002597", "encrypted_ssn" => "QEVuQwEA5zFJVnmzWsCYpa5WejlkZg=="
        },
        "relative_reference" => {
          "first_name" => "DaphneG", "last_name" => "MorganG", "dob" => "2009-01-01", "person_hbx_id" => "1002595", "encrypted_ssn" => "QEVuQwEAyA2o6iin8v0w4q0rIHnALQ=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "HareemG", "last_name" => "MorganG", "dob" => "2007-01-01", "person_hbx_id" => "1002596", "encrypted_ssn" => "QEVuQwEAZc6FWGr6C0IROr4+yJMJTw=="
        },
        "relative_reference" => {
          "first_name" => "TheoG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002597", "encrypted_ssn" => "QEVuQwEA5zFJVnmzWsCYpa5WejlkZg=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "TheoG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002597", "encrypted_ssn" => "QEVuQwEA5zFJVnmzWsCYpa5WejlkZg=="
        },
        "relative_reference" => {
          "first_name" => "HareemG", "last_name" => "MorganG", "dob" => "2007-01-01", "person_hbx_id" => "1002596", "encrypted_ssn" => "QEVuQwEAZc6FWGr6C0IROr4+yJMJTw=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "AvyaG", "last_name" => "MorganG", "dob" => "2013-01-01", "person_hbx_id" => "1002593", "encrypted_ssn" => "QEVuQwEAa/tp2tSuacp+9l2gHOvOHQ=="
        },
        "relative_reference" => {
          "first_name" => "MichG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002598", "encrypted_ssn" => "QEVuQwEAMAuMlqnCrW9SY9UdoAudZg=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "MichG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002598", "encrypted_ssn" => "QEVuQwEAMAuMlqnCrW9SY9UdoAudZg=="
        },
        "relative_reference" => {
          "first_name" => "AvyaG", "last_name" => "MorganG", "dob" => "2013-01-01", "person_hbx_id" => "1002593", "encrypted_ssn" => "QEVuQwEAa/tp2tSuacp+9l2gHOvOHQ=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "SafiG", "last_name" => "MorganG", "dob" => "2011-01-01", "person_hbx_id" => "1002594", "encrypted_ssn" => "QEVuQwEAlhXYuv7FJmROSQdvd8DzuQ=="
        },
        "relative_reference" => {
          "first_name" => "MichG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002598", "encrypted_ssn" => "QEVuQwEAMAuMlqnCrW9SY9UdoAudZg=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "MichG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002598", "encrypted_ssn" => "QEVuQwEAMAuMlqnCrW9SY9UdoAudZg=="
        },
        "relative_reference" => {
          "first_name" => "SafiG", "last_name" => "MorganG", "dob" => "2011-01-01", "person_hbx_id" => "1002594", "encrypted_ssn" => "QEVuQwEAlhXYuv7FJmROSQdvd8DzuQ=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "DaphneG", "last_name" => "MorganG", "dob" => "2009-01-01", "person_hbx_id" => "1002595", "encrypted_ssn" => "QEVuQwEAyA2o6iin8v0w4q0rIHnALQ=="
        },
        "relative_reference" => {
          "first_name" => "MichG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002598", "encrypted_ssn" => "QEVuQwEAMAuMlqnCrW9SY9UdoAudZg=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "MichG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002598", "encrypted_ssn" => "QEVuQwEAMAuMlqnCrW9SY9UdoAudZg=="
        },
        "relative_reference" => {
          "first_name" => "DaphneG", "last_name" => "MorganG", "dob" => "2009-01-01", "person_hbx_id" => "1002595", "encrypted_ssn" => "QEVuQwEAyA2o6iin8v0w4q0rIHnALQ=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "HareemG", "last_name" => "MorganG", "dob" => "2007-01-01", "person_hbx_id" => "1002596", "encrypted_ssn" => "QEVuQwEAZc6FWGr6C0IROr4+yJMJTw=="
        },
        "relative_reference" => {
          "first_name" => "MichG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002598", "encrypted_ssn" => "QEVuQwEAMAuMlqnCrW9SY9UdoAudZg=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "MichG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002598", "encrypted_ssn" => "QEVuQwEAMAuMlqnCrW9SY9UdoAudZg=="
        },
        "relative_reference" => {
          "first_name" => "HareemG", "last_name" => "MorganG", "dob" => "2007-01-01", "person_hbx_id" => "1002596", "encrypted_ssn" => "QEVuQwEAZc6FWGr6C0IROr4+yJMJTw=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "TheoG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002597", "encrypted_ssn" => "QEVuQwEA5zFJVnmzWsCYpa5WejlkZg=="
        },
        "relative_reference" => {
          "first_name" => "MichG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002598", "encrypted_ssn" => "QEVuQwEAMAuMlqnCrW9SY9UdoAudZg=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "MichG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002598", "encrypted_ssn" => "QEVuQwEAMAuMlqnCrW9SY9UdoAudZg=="
        },
        "relative_reference" => {
          "first_name" => "TheoG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002597", "encrypted_ssn" => "QEVuQwEA5zFJVnmzWsCYpa5WejlkZg=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "AvyaG", "last_name" => "MorganG", "dob" => "2013-01-01", "person_hbx_id" => "1002593", "encrypted_ssn" => "QEVuQwEAa/tp2tSuacp+9l2gHOvOHQ=="
        },
        "relative_reference" => {
          "first_name" => "HughG", "last_name" => "MorganG", "dob" => "2003-01-01", "person_hbx_id" => "1002599", "encrypted_ssn" => "QEVuQwEAqRFJWhvn+8NUysxJJiOorA=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "HughG", "last_name" => "MorganG", "dob" => "2003-01-01", "person_hbx_id" => "1002599", "encrypted_ssn" => "QEVuQwEAqRFJWhvn+8NUysxJJiOorA=="
        },
        "relative_reference" => {
          "first_name" => "AvyaG", "last_name" => "MorganG", "dob" => "2013-01-01", "person_hbx_id" => "1002593", "encrypted_ssn" => "QEVuQwEAa/tp2tSuacp+9l2gHOvOHQ=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "SafiG", "last_name" => "MorganG", "dob" => "2011-01-01", "person_hbx_id" => "1002594", "encrypted_ssn" => "QEVuQwEAlhXYuv7FJmROSQdvd8DzuQ=="
        },
        "relative_reference" => {
          "first_name" => "HughG", "last_name" => "MorganG", "dob" => "2003-01-01", "person_hbx_id" => "1002599", "encrypted_ssn" => "QEVuQwEAqRFJWhvn+8NUysxJJiOorA=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "HughG", "last_name" => "MorganG", "dob" => "2003-01-01", "person_hbx_id" => "1002599", "encrypted_ssn" => "QEVuQwEAqRFJWhvn+8NUysxJJiOorA=="
        },
        "relative_reference" => {
          "first_name" => "SafiG", "last_name" => "MorganG", "dob" => "2011-01-01", "person_hbx_id" => "1002594", "encrypted_ssn" => "QEVuQwEAlhXYuv7FJmROSQdvd8DzuQ=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "DaphneG", "last_name" => "MorganG", "dob" => "2009-01-01", "person_hbx_id" => "1002595", "encrypted_ssn" => "QEVuQwEAyA2o6iin8v0w4q0rIHnALQ=="
        },
        "relative_reference" => {
          "first_name" => "HughG", "last_name" => "MorganG", "dob" => "2003-01-01", "person_hbx_id" => "1002599", "encrypted_ssn" => "QEVuQwEAqRFJWhvn+8NUysxJJiOorA=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "HughG", "last_name" => "MorganG", "dob" => "2003-01-01", "person_hbx_id" => "1002599", "encrypted_ssn" => "QEVuQwEAqRFJWhvn+8NUysxJJiOorA=="
        },
        "relative_reference" => {
          "first_name" => "DaphneG", "last_name" => "MorganG", "dob" => "2009-01-01", "person_hbx_id" => "1002595", "encrypted_ssn" => "QEVuQwEAyA2o6iin8v0w4q0rIHnALQ=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "HareemG", "last_name" => "MorganG", "dob" => "2007-01-01", "person_hbx_id" => "1002596", "encrypted_ssn" => "QEVuQwEAZc6FWGr6C0IROr4+yJMJTw=="
        },
        "relative_reference" => {
          "first_name" => "HughG", "last_name" => "MorganG", "dob" => "2003-01-01", "person_hbx_id" => "1002599", "encrypted_ssn" => "QEVuQwEAqRFJWhvn+8NUysxJJiOorA=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "HughG", "last_name" => "MorganG", "dob" => "2003-01-01", "person_hbx_id" => "1002599", "encrypted_ssn" => "QEVuQwEAqRFJWhvn+8NUysxJJiOorA=="
        },
        "relative_reference" => {
          "first_name" => "HareemG", "last_name" => "MorganG", "dob" => "2007-01-01", "person_hbx_id" => "1002596", "encrypted_ssn" => "QEVuQwEAZc6FWGr6C0IROr4+yJMJTw=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "TheoG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002597", "encrypted_ssn" => "QEVuQwEA5zFJVnmzWsCYpa5WejlkZg=="
        },
        "relative_reference" => {
          "first_name" => "HughG", "last_name" => "MorganG", "dob" => "2003-01-01", "person_hbx_id" => "1002599", "encrypted_ssn" => "QEVuQwEAqRFJWhvn+8NUysxJJiOorA=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "HughG", "last_name" => "MorganG", "dob" => "2003-01-01", "person_hbx_id" => "1002599", "encrypted_ssn" => "QEVuQwEAqRFJWhvn+8NUysxJJiOorA=="
        },
        "relative_reference" => {
          "first_name" => "TheoG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002597", "encrypted_ssn" => "QEVuQwEA5zFJVnmzWsCYpa5WejlkZg=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "MichG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002598", "encrypted_ssn" => "QEVuQwEAMAuMlqnCrW9SY9UdoAudZg=="
        },
        "relative_reference" => {
          "first_name" => "HughG", "last_name" => "MorganG", "dob" => "2003-01-01", "person_hbx_id" => "1002599", "encrypted_ssn" => "QEVuQwEAqRFJWhvn+8NUysxJJiOorA=="
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "HughG", "last_name" => "MorganG", "dob" => "2003-01-01", "person_hbx_id" => "1002599", "encrypted_ssn" => "QEVuQwEAqRFJWhvn+8NUysxJJiOorA=="
        },
        "relative_reference" => {
          "first_name" => "MichG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002598", "encrypted_ssn" => "QEVuQwEAMAuMlqnCrW9SY9UdoAudZg=="
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        },
        "relative_reference" => {
          "first_name" => "AvyaG", "last_name" => "MorganG", "dob" => "2013-01-01", "person_hbx_id" => "1002593", "encrypted_ssn" => "QEVuQwEAa/tp2tSuacp+9l2gHOvOHQ=="
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "AvyaG", "last_name" => "MorganG", "dob" => "2013-01-01", "person_hbx_id" => "1002593", "encrypted_ssn" => "QEVuQwEAa/tp2tSuacp+9l2gHOvOHQ=="
        },
        "relative_reference" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        },
        "relative_reference" => {
          "first_name" => "SafiG", "last_name" => "MorganG", "dob" => "2011-01-01", "person_hbx_id" => "1002594", "encrypted_ssn" => "QEVuQwEAlhXYuv7FJmROSQdvd8DzuQ=="
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "SafiG", "last_name" => "MorganG", "dob" => "2011-01-01", "person_hbx_id" => "1002594", "encrypted_ssn" => "QEVuQwEAlhXYuv7FJmROSQdvd8DzuQ=="
        },
        "relative_reference" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        },
        "relative_reference" => {
          "first_name" => "DaphneG", "last_name" => "MorganG", "dob" => "2009-01-01", "person_hbx_id" => "1002595", "encrypted_ssn" => "QEVuQwEAyA2o6iin8v0w4q0rIHnALQ=="
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "DaphneG", "last_name" => "MorganG", "dob" => "2009-01-01", "person_hbx_id" => "1002595", "encrypted_ssn" => "QEVuQwEAyA2o6iin8v0w4q0rIHnALQ=="
        },
        "relative_reference" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        },
        "relative_reference" => {
          "first_name" => "HareemG", "last_name" => "MorganG", "dob" => "2007-01-01", "person_hbx_id" => "1002596", "encrypted_ssn" => "QEVuQwEAZc6FWGr6C0IROr4+yJMJTw=="
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "HareemG", "last_name" => "MorganG", "dob" => "2007-01-01", "person_hbx_id" => "1002596", "encrypted_ssn" => "QEVuQwEAZc6FWGr6C0IROr4+yJMJTw=="
        },
        "relative_reference" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        },
        "relative_reference" => {
          "first_name" => "TheoG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002597", "encrypted_ssn" => "QEVuQwEA5zFJVnmzWsCYpa5WejlkZg=="
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "TheoG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002597", "encrypted_ssn" => "QEVuQwEA5zFJVnmzWsCYpa5WejlkZg=="
        },
        "relative_reference" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        },
        "relative_reference" => {
          "first_name" => "MichG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002598", "encrypted_ssn" => "QEVuQwEAMAuMlqnCrW9SY9UdoAudZg=="
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "MichG", "last_name" => "MorganG", "dob" => "2005-01-01", "person_hbx_id" => "1002598", "encrypted_ssn" => "QEVuQwEAMAuMlqnCrW9SY9UdoAudZg=="
        },
        "relative_reference" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        },
        "relative_reference" => {
          "first_name" => "HughG", "last_name" => "MorganG", "dob" => "2003-01-01", "person_hbx_id" => "1002599", "encrypted_ssn" => "QEVuQwEAqRFJWhvn+8NUysxJJiOorA=="
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "HughG", "last_name" => "MorganG", "dob" => "2003-01-01", "person_hbx_id" => "1002599", "encrypted_ssn" => "QEVuQwEAqRFJWhvn+8NUysxJJiOorA=="
        },
        "relative_reference" => {
          "first_name" => "AlbaG", "last_name" => "MorganG", "dob" => "1981-01-01", "person_hbx_id" => "1002592", "encrypted_ssn" => "QEVuQwEAhYXbOlomSO8L66BG9/gkTA=="
        }
      }], "us_state" => "ME", "hbx_id" => "1000396", "oe_start_on" => "2020-11-01", "mitc_households" => [{
        "household_id" => "1000396",
        "people" => [{
          "person_id" => 1_002_584
        }, {
          "person_id" => 1_002_592
        }, {
          "person_id" => 1_002_593
        }, {
          "person_id" => 1_002_594
        }, {
          "person_id" => 1_002_595
        }, {
          "person_id" => 1_002_596
        }, {
          "person_id" => 1_002_597
        }, {
          "person_id" => 1_002_598
        }, {
          "person_id" => 1_002_599
        }]
      }], "mitc_tax_returns" => [{
        "filers" => [{
          "person_id" => 1_002_584
        }, {
          "person_id" => 1_002_592
        }],
        "dependents" => [{
          "person_id" => 1_002_593
        }, {
          "person_id" => 1_002_594
        }, {
          "person_id" => 1_002_595
        }, {
          "person_id" => 1_002_596
        }, {
          "person_id" => 1_002_597
        }, {
          "person_id" => 1_002_598
        }, {
          "person_id" => 1_002_599
        }]
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
    "{\"medicaid_application_id\":\"1000396\",\"medicaid_response_payload\":{\"Determination Date\":\"2021-06-22\",\"Applicants\":[{\"Person ID\":1002584,\"Medicaid Household\":{\"People\":[1002584,1002592,1002593,1002594,1002595,1002596,1002597,1002598,1002599],\"MAGI\":99658,\"MAGI as Percentage of FPL\":202,\"Size\":9},\"Medicaid Eligible\":\"N\",\"CHIP Eligible\":\"N\",\"Ineligibility Reason\":[\"Applicant's MAGI above the threshold for category\"],\"Non-MAGI Referral\":\"N\",\"CHIP Ineligibility Reason\":[\"Applicant did not meet the requirements for any CHIP category\"],\"Category\":\"Parent Caretaker Category\",\"Category Threshold\":51660,\"CHIP Category\":\"None\",\"CHIP Category Threshold\":0,\"Determinations\":{\"Residency\":{\"Indicator\":\"Y\"},\"Adult Group Category\":{\"Indicator\":\"X\"},\"Parent Caretaker Category\":{\"Indicator\":\"Y\"},\"Pregnancy Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":124,\"Ineligibility Reason\":\"Applicant not pregnant or within postpartum period\"},\"Child Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":394,\"Ineligibility Reason\":\"Applicant is over the age limit for the young adult threshold in the state\"},\"Optional Targeted Low Income Child\":{\"Indicator\":\"X\"},\"CHIP Targeted Low Income Child\":{\"Indicator\":\"N\",\"Ineligibility Code\":127,\"Ineligibility Reason\":\"Applicant's age is not within the allowed age range\"},\"Unborn Child\":{\"Indicator\":\"X\"},\"Income Medicaid Eligible\":{\"Indicator\":\"N\",\"Ineligibility Code\":402,\"Ineligibility Reason\":\"Applicant's income is greater than the threshold for all eligible categories\"},\"Income CHIP Eligible\":{\"Indicator\":\"N\",\"Ineligibility Code\":401,\"Ineligibility Reason\":\"Applicant did not meet the requirements for any eligibility category\"},\"Medicaid CHIPRA 214\":{\"Indicator\":\"X\"},\"CHIP CHIPRA 214\":{\"Indicator\":\"X\"},\"Trafficking Victim\":{\"Indicator\":\"X\"},\"Seven Year Limit\":{\"Indicator\":\"X\"},\"Five Year Bar\":{\"Indicator\":\"X\"},\"Title II Work Quarters Met\":{\"Indicator\":\"X\"},\"Medicaid Citizen Or Immigrant\":{\"Indicator\":\"Y\"},\"CHIP Citizen Or Immigrant\":{\"Indicator\":\"Y\"},\"Former Foster Care Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":400,\"Ineligibility Reason\":\"Applicant was not formerly in foster care\"},\"Work Quarters Override Income\":{\"Indicator\":\"N\",\"Ineligibility Code\":340,\"Ineligibility Reason\":\"Income is greater than 100% FPL\"},\"State Health Benefits CHIP\":{\"Indicator\":\"X\"},\"CHIP Waiting Period Satisfied\":{\"Indicator\":\"X\"},\"Dependent Child Covered\":{\"Indicator\":\"Y\"},\"Medicaid Non-MAGI Referral\":{\"Indicator\":\"N\",\"Ineligibility Code\":108,\"Ineligibility Reason\":\"Applicant does not meet requirements for a non-MAGI referral\"},\"Emergency Medicaid\":{\"Indicator\":\"N\",\"Ineligibility Code\":109,\"Ineligibility Reason\":\"Applicant does not meet the eligibility criteria for emergency Medicaid\"},\"Refugee Medical Assistance\":{\"Indicator\":\"X\"},\"APTC Referral\":{\"Indicator\":\"Y\"}},\"Other Outputs\":{\"Qualified Children List\":[{\"Person ID\":1002593,\"Determinations\":{\"Dependent Age\":{\"Indicator\":\"Y\"},\"Deprived Child\":{\"Indicator\":\"X\"},\"Relationship\":{\"Indicator\":\"Y\"}}},{\"Person ID\":1002594,\"Determinations\":{\"Dependent Age\":{\"Indicator\":\"Y\"},\"Deprived Child\":{\"Indicator\":\"X\"},\"Relationship\":{\"Indicator\":\"Y\"}}},{\"Person ID\":1002595,\"Determinations\":{\"Dependent Age\":{\"Indicator\":\"Y\"},\"Deprived Child\":{\"Indicator\":\"X\"},\"Relationship\":{\"Indicator\":\"Y\"}}},{\"Person ID\":1002596,\"Determinations\":{\"Dependent Age\":{\"Indicator\":\"Y\"},\"Deprived Child\":{\"Indicator\":\"X\"},\"Relationship\":{\"Indicator\":\"Y\"}}},{\"Person ID\":1002597,\"Determinations\":{\"Dependent Age\":{\"Indicator\":\"Y\"},\"Deprived Child\":{\"Indicator\":\"X\"},\"Relationship\":{\"Indicator\":\"Y\"}}},{\"Person ID\":1002598,\"Determinations\":{\"Dependent Age\":{\"Indicator\":\"Y\"},\"Deprived Child\":{\"Indicator\":\"X\"},\"Relationship\":{\"Indicator\":\"Y\"}}}]}},{\"Person ID\":1002592,\"Medicaid Household\":{\"People\":[1002584,1002592,1002593,1002594,1002595,1002596,1002597,1002598,1002599],\"MAGI\":99658,\"MAGI as Percentage of FPL\":202,\"Size\":9},\"Medicaid Eligible\":\"N\",\"CHIP Eligible\":\"N\",\"Ineligibility Reason\":[\"Applicant's MAGI above the threshold for category\"],\"Non-MAGI Referral\":\"N\",\"CHIP Ineligibility Reason\":[\"Applicant did not meet the requirements for any CHIP category\"],\"Category\":\"Parent Caretaker Category\",\"Category Threshold\":51660,\"CHIP Category\":\"None\",\"CHIP Category Threshold\":0,\"Determinations\":{\"Residency\":{\"Indicator\":\"Y\"},\"Adult Group Category\":{\"Indicator\":\"X\"},\"Parent Caretaker Category\":{\"Indicator\":\"Y\"},\"Pregnancy Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":124,\"Ineligibility Reason\":\"Applicant not pregnant or within postpartum period\"},\"Child Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":394,\"Ineligibility Reason\":\"Applicant is over the age limit for the young adult threshold in the state\"},\"Optional Targeted Low Income Child\":{\"Indicator\":\"X\"},\"CHIP Targeted Low Income Child\":{\"Indicator\":\"N\",\"Ineligibility Code\":127,\"Ineligibility Reason\":\"Applicant's age is not within the allowed age range\"},\"Unborn Child\":{\"Indicator\":\"X\"},\"Income Medicaid Eligible\":{\"Indicator\":\"N\",\"Ineligibility Code\":402,\"Ineligibility Reason\":\"Applicant's income is greater than the threshold for all eligible categories\"},\"Income CHIP Eligible\":{\"Indicator\":\"N\",\"Ineligibility Code\":401,\"Ineligibility Reason\":\"Applicant did not meet the requirements for any eligibility category\"},\"Medicaid CHIPRA 214\":{\"Indicator\":\"X\"},\"CHIP CHIPRA 214\":{\"Indicator\":\"X\"},\"Trafficking Victim\":{\"Indicator\":\"X\"},\"Seven Year Limit\":{\"Indicator\":\"X\"},\"Five Year Bar\":{\"Indicator\":\"X\"},\"Title II Work Quarters Met\":{\"Indicator\":\"X\"},\"Medicaid Citizen Or Immigrant\":{\"Indicator\":\"Y\"},\"CHIP Citizen Or Immigrant\":{\"Indicator\":\"Y\"},\"Former Foster Care Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":400,\"Ineligibility Reason\":\"Applicant was not formerly in foster care\"},\"Work Quarters Override Income\":{\"Indicator\":\"N\",\"Ineligibility Code\":340,\"Ineligibility Reason\":\"Income is greater than 100% FPL\"},\"State Health Benefits CHIP\":{\"Indicator\":\"X\"},\"CHIP Waiting Period Satisfied\":{\"Indicator\":\"X\"},\"Dependent Child Covered\":{\"Indicator\":\"Y\"},\"Medicaid Non-MAGI Referral\":{\"Indicator\":\"N\",\"Ineligibility Code\":108,\"Ineligibility Reason\":\"Applicant does not meet requirements for a non-MAGI referral\"},\"Emergency Medicaid\":{\"Indicator\":\"N\",\"Ineligibility Code\":109,\"Ineligibility Reason\":\"Applicant does not meet the eligibility criteria for emergency Medicaid\"},\"Refugee Medical Assistance\":{\"Indicator\":\"X\"},\"APTC Referral\":{\"Indicator\":\"Y\"}},\"Other Outputs\":{\"Qualified Children List\":[{\"Person ID\":1002593,\"Determinations\":{\"Dependent Age\":{\"Indicator\":\"Y\"},\"Deprived Child\":{\"Indicator\":\"X\"},\"Relationship\":{\"Indicator\":\"Y\"}}},{\"Person ID\":1002594,\"Determinations\":{\"Dependent Age\":{\"Indicator\":\"Y\"},\"Deprived Child\":{\"Indicator\":\"X\"},\"Relationship\":{\"Indicator\":\"Y\"}}},{\"Person ID\":1002595,\"Determinations\":{\"Dependent Age\":{\"Indicator\":\"Y\"},\"Deprived Child\":{\"Indicator\":\"X\"},\"Relationship\":{\"Indicator\":\"Y\"}}},{\"Person ID\":1002596,\"Determinations\":{\"Dependent Age\":{\"Indicator\":\"Y\"},\"Deprived Child\":{\"Indicator\":\"X\"},\"Relationship\":{\"Indicator\":\"Y\"}}},{\"Person ID\":1002597,\"Determinations\":{\"Dependent Age\":{\"Indicator\":\"Y\"},\"Deprived Child\":{\"Indicator\":\"X\"},\"Relationship\":{\"Indicator\":\"Y\"}}},{\"Person ID\":1002598,\"Determinations\":{\"Dependent Age\":{\"Indicator\":\"Y\"},\"Deprived Child\":{\"Indicator\":\"X\"},\"Relationship\":{\"Indicator\":\"Y\"}}}]}},{\"Person ID\":1002593,\"Medicaid Household\":{\"People\":[1002584,1002592,1002593,1002594,1002595,1002596,1002597,1002598,1002599],\"MAGI\":99658,\"MAGI as Percentage of FPL\":202,\"Size\":9},\"Medicaid Eligible\":\"N\",\"CHIP Eligible\":\"Y\",\"Ineligibility Reason\":[\"Applicant's MAGI above the threshold for category\"],\"Non-MAGI Referral\":\"Y\",\"Category\":\"Child Category\",\"Category Threshold\":79704,\"CHIP Category\":\"CHIP Targeted Low Income Child\",\"CHIP Category Threshold\":104796,\"Determinations\":{\"Residency\":{\"Indicator\":\"Y\"},\"Adult Group Category\":{\"Indicator\":\"X\"},\"Parent Caretaker Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":146,\"Ineligibility Reason\":\"No child met all criteria for parent caretaker category\"},\"Pregnancy Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":124,\"Ineligibility Reason\":\"Applicant not pregnant or within postpartum period\"},\"Child Category\":{\"Indicator\":\"Y\"},\"Optional Targeted Low Income Child\":{\"Indicator\":\"X\"},\"CHIP Targeted Low Income Child\":{\"Indicator\":\"Y\"},\"Unborn Child\":{\"Indicator\":\"X\"},\"Income Medicaid Eligible\":{\"Indicator\":\"N\",\"Ineligibility Code\":402,\"Ineligibility Reason\":\"Applicant's income is greater than the threshold for all eligible categories\"},\"Income CHIP Eligible\":{\"Indicator\":\"Y\"},\"Medicaid CHIPRA 214\":{\"Indicator\":\"X\"},\"CHIP CHIPRA 214\":{\"Indicator\":\"X\"},\"Trafficking Victim\":{\"Indicator\":\"X\"},\"Seven Year Limit\":{\"Indicator\":\"X\"},\"Five Year Bar\":{\"Indicator\":\"X\"},\"Title II Work Quarters Met\":{\"Indicator\":\"X\"},\"Medicaid Citizen Or Immigrant\":{\"Indicator\":\"Y\"},\"CHIP Citizen Or Immigrant\":{\"Indicator\":\"Y\"},\"Former Foster Care Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":400,\"Ineligibility Reason\":\"Applicant was not formerly in foster care\"},\"Work Quarters Override Income\":{\"Indicator\":\"N\",\"Ineligibility Code\":340,\"Ineligibility Reason\":\"Income is greater than 100% FPL\"},\"State Health Benefits CHIP\":{\"Indicator\":\"X\"},\"CHIP Waiting Period Satisfied\":{\"Indicator\":\"X\"},\"Dependent Child Covered\":{\"Indicator\":\"X\"},\"Medicaid Non-MAGI Referral\":{\"Indicator\":\"Y\"},\"Emergency Medicaid\":{\"Indicator\":\"N\",\"Ineligibility Code\":109,\"Ineligibility Reason\":\"Applicant does not meet the eligibility criteria for emergency Medicaid\"},\"Refugee Medical Assistance\":{\"Indicator\":\"X\"},\"APTC Referral\":{\"Indicator\":\"Y\"}},\"Other Outputs\":{\"Qualified Children List\":[]}},{\"Person ID\":1002594,\"Medicaid Household\":{\"People\":[1002584,1002592,1002593,1002594,1002595,1002596,1002597,1002598,1002599],\"MAGI\":99658,\"MAGI as Percentage of FPL\":202,\"Size\":9},\"Medicaid Eligible\":\"N\",\"CHIP Eligible\":\"Y\",\"Ineligibility Reason\":[\"Applicant's MAGI above the threshold for category\"],\"Non-MAGI Referral\":\"N\",\"Category\":\"Child Category\",\"Category Threshold\":79704,\"CHIP Category\":\"CHIP Targeted Low Income Child\",\"CHIP Category Threshold\":104796,\"Determinations\":{\"Residency\":{\"Indicator\":\"Y\"},\"Adult Group Category\":{\"Indicator\":\"X\"},\"Parent Caretaker Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":146,\"Ineligibility Reason\":\"No child met all criteria for parent caretaker category\"},\"Pregnancy Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":124,\"Ineligibility Reason\":\"Applicant not pregnant or within postpartum period\"},\"Child Category\":{\"Indicator\":\"Y\"},\"Optional Targeted Low Income Child\":{\"Indicator\":\"X\"},\"CHIP Targeted Low Income Child\":{\"Indicator\":\"Y\"},\"Unborn Child\":{\"Indicator\":\"X\"},\"Income Medicaid Eligible\":{\"Indicator\":\"N\",\"Ineligibility Code\":402,\"Ineligibility Reason\":\"Applicant's income is greater than the threshold for all eligible categories\"},\"Income CHIP Eligible\":{\"Indicator\":\"Y\"},\"Medicaid CHIPRA 214\":{\"Indicator\":\"X\"},\"CHIP CHIPRA 214\":{\"Indicator\":\"X\"},\"Trafficking Victim\":{\"Indicator\":\"X\"},\"Seven Year Limit\":{\"Indicator\":\"X\"},\"Five Year Bar\":{\"Indicator\":\"X\"},\"Title II Work Quarters Met\":{\"Indicator\":\"X\"},\"Medicaid Citizen Or Immigrant\":{\"Indicator\":\"Y\"},\"CHIP Citizen Or Immigrant\":{\"Indicator\":\"Y\"},\"Former Foster Care Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":400,\"Ineligibility Reason\":\"Applicant was not formerly in foster care\"},\"Work Quarters Override Income\":{\"Indicator\":\"N\",\"Ineligibility Code\":340,\"Ineligibility Reason\":\"Income is greater than 100% FPL\"},\"State Health Benefits CHIP\":{\"Indicator\":\"X\"},\"CHIP Waiting Period Satisfied\":{\"Indicator\":\"X\"},\"Dependent Child Covered\":{\"Indicator\":\"X\"},\"Medicaid Non-MAGI Referral\":{\"Indicator\":\"N\",\"Ineligibility Code\":108,\"Ineligibility Reason\":\"Applicant does not meet requirements for a non-MAGI referral\"},\"Emergency Medicaid\":{\"Indicator\":\"N\",\"Ineligibility Code\":109,\"Ineligibility Reason\":\"Applicant does not meet the eligibility criteria for emergency Medicaid\"},\"Refugee Medical Assistance\":{\"Indicator\":\"X\"},\"APTC Referral\":{\"Indicator\":\"Y\"}},\"Other Outputs\":{\"Qualified Children List\":[]}},{\"Person ID\":1002595,\"Medicaid Household\":{\"People\":[1002584,1002592,1002593,1002594,1002595,1002596,1002597,1002598,1002599],\"MAGI\":99658,\"MAGI as Percentage of FPL\":202,\"Size\":9},\"Medicaid Eligible\":\"N\",\"CHIP Eligible\":\"Y\",\"Ineligibility Reason\":[\"Applicant's MAGI above the threshold for category\"],\"Non-MAGI Referral\":\"N\",\"Category\":\"Child Category\",\"Category Threshold\":79704,\"CHIP Category\":\"CHIP Targeted Low Income Child\",\"CHIP Category Threshold\":104796,\"Determinations\":{\"Residency\":{\"Indicator\":\"Y\"},\"Adult Group Category\":{\"Indicator\":\"X\"},\"Parent Caretaker Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":146,\"Ineligibility Reason\":\"No child met all criteria for parent caretaker category\"},\"Pregnancy Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":124,\"Ineligibility Reason\":\"Applicant not pregnant or within postpartum period\"},\"Child Category\":{\"Indicator\":\"Y\"},\"Optional Targeted Low Income Child\":{\"Indicator\":\"X\"},\"CHIP Targeted Low Income Child\":{\"Indicator\":\"Y\"},\"Unborn Child\":{\"Indicator\":\"X\"},\"Income Medicaid Eligible\":{\"Indicator\":\"N\",\"Ineligibility Code\":402,\"Ineligibility Reason\":\"Applicant's income is greater than the threshold for all eligible categories\"},\"Income CHIP Eligible\":{\"Indicator\":\"Y\"},\"Medicaid CHIPRA 214\":{\"Indicator\":\"X\"},\"CHIP CHIPRA 214\":{\"Indicator\":\"X\"},\"Trafficking Victim\":{\"Indicator\":\"X\"},\"Seven Year Limit\":{\"Indicator\":\"X\"},\"Five Year Bar\":{\"Indicator\":\"X\"},\"Title II Work Quarters Met\":{\"Indicator\":\"X\"},\"Medicaid Citizen Or Immigrant\":{\"Indicator\":\"Y\"},\"CHIP Citizen Or Immigrant\":{\"Indicator\":\"Y\"},\"Former Foster Care Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":400,\"Ineligibility Reason\":\"Applicant was not formerly in foster care\"},\"Work Quarters Override Income\":{\"Indicator\":\"N\",\"Ineligibility Code\":340,\"Ineligibility Reason\":\"Income is greater than 100% FPL\"},\"State Health Benefits CHIP\":{\"Indicator\":\"X\"},\"CHIP Waiting Period Satisfied\":{\"Indicator\":\"X\"},\"Dependent Child Covered\":{\"Indicator\":\"X\"},\"Medicaid Non-MAGI Referral\":{\"Indicator\":\"N\",\"Ineligibility Code\":108,\"Ineligibility Reason\":\"Applicant does not meet requirements for a non-MAGI referral\"},\"Emergency Medicaid\":{\"Indicator\":\"N\",\"Ineligibility Code\":109,\"Ineligibility Reason\":\"Applicant does not meet the eligibility criteria for emergency Medicaid\"},\"Refugee Medical Assistance\":{\"Indicator\":\"X\"},\"APTC Referral\":{\"Indicator\":\"Y\"}},\"Other Outputs\":{\"Qualified Children List\":[]}},{\"Person ID\":1002596,\"Medicaid Household\":{\"People\":[1002584,1002592,1002593,1002594,1002595,1002596,1002597,1002598,1002599],\"MAGI\":99658,\"MAGI as Percentage of FPL\":202,\"Size\":9},\"Medicaid Eligible\":\"N\",\"CHIP Eligible\":\"Y\",\"Ineligibility Reason\":[\"Applicant's MAGI above the threshold for category\"],\"Non-MAGI Referral\":\"N\",\"Category\":\"Child Category\",\"Category Threshold\":79704,\"CHIP Category\":\"CHIP Targeted Low Income Child\",\"CHIP Category Threshold\":104796,\"Determinations\":{\"Residency\":{\"Indicator\":\"Y\"},\"Adult Group Category\":{\"Indicator\":\"X\"},\"Parent Caretaker Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":146,\"Ineligibility Reason\":\"No child met all criteria for parent caretaker category\"},\"Pregnancy Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":124,\"Ineligibility Reason\":\"Applicant not pregnant or within postpartum period\"},\"Child Category\":{\"Indicator\":\"Y\"},\"Optional Targeted Low Income Child\":{\"Indicator\":\"X\"},\"CHIP Targeted Low Income Child\":{\"Indicator\":\"Y\"},\"Unborn Child\":{\"Indicator\":\"X\"},\"Income Medicaid Eligible\":{\"Indicator\":\"N\",\"Ineligibility Code\":402,\"Ineligibility Reason\":\"Applicant's income is greater than the threshold for all eligible categories\"},\"Income CHIP Eligible\":{\"Indicator\":\"Y\"},\"Medicaid CHIPRA 214\":{\"Indicator\":\"X\"},\"CHIP CHIPRA 214\":{\"Indicator\":\"X\"},\"Trafficking Victim\":{\"Indicator\":\"X\"},\"Seven Year Limit\":{\"Indicator\":\"X\"},\"Five Year Bar\":{\"Indicator\":\"X\"},\"Title II Work Quarters Met\":{\"Indicator\":\"X\"},\"Medicaid Citizen Or Immigrant\":{\"Indicator\":\"Y\"},\"CHIP Citizen Or Immigrant\":{\"Indicator\":\"Y\"},\"Former Foster Care Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":400,\"Ineligibility Reason\":\"Applicant was not formerly in foster care\"},\"Work Quarters Override Income\":{\"Indicator\":\"N\",\"Ineligibility Code\":340,\"Ineligibility Reason\":\"Income is greater than 100% FPL\"},\"State Health Benefits CHIP\":{\"Indicator\":\"X\"},\"CHIP Waiting Period Satisfied\":{\"Indicator\":\"X\"},\"Dependent Child Covered\":{\"Indicator\":\"X\"},\"Medicaid Non-MAGI Referral\":{\"Indicator\":\"N\",\"Ineligibility Code\":108,\"Ineligibility Reason\":\"Applicant does not meet requirements for a non-MAGI referral\"},\"Emergency Medicaid\":{\"Indicator\":\"N\",\"Ineligibility Code\":109,\"Ineligibility Reason\":\"Applicant does not meet the eligibility criteria for emergency Medicaid\"},\"Refugee Medical Assistance\":{\"Indicator\":\"X\"},\"APTC Referral\":{\"Indicator\":\"Y\"}},\"Other Outputs\":{\"Qualified Children List\":[]}},{\"Person ID\":1002597,\"Medicaid Household\":{\"People\":[1002584,1002592,1002593,1002594,1002595,1002596,1002597,1002598,1002599],\"MAGI\":99658,\"MAGI as Percentage of FPL\":202,\"Size\":9},\"Medicaid Eligible\":\"N\",\"CHIP Eligible\":\"Y\",\"Ineligibility Reason\":[\"Applicant's MAGI above the threshold for category\"],\"Non-MAGI Referral\":\"N\",\"Category\":\"Child Category\",\"Category Threshold\":79704,\"CHIP Category\":\"CHIP Targeted Low Income Child\",\"CHIP Category Threshold\":104796,\"Determinations\":{\"Residency\":{\"Indicator\":\"Y\"},\"Adult Group Category\":{\"Indicator\":\"X\"},\"Parent Caretaker Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":146,\"Ineligibility Reason\":\"No child met all criteria for parent caretaker category\"},\"Pregnancy Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":124,\"Ineligibility Reason\":\"Applicant not pregnant or within postpartum period\"},\"Child Category\":{\"Indicator\":\"Y\"},\"Optional Targeted Low Income Child\":{\"Indicator\":\"X\"},\"CHIP Targeted Low Income Child\":{\"Indicator\":\"Y\"},\"Unborn Child\":{\"Indicator\":\"X\"},\"Income Medicaid Eligible\":{\"Indicator\":\"N\",\"Ineligibility Code\":402,\"Ineligibility Reason\":\"Applicant's income is greater than the threshold for all eligible categories\"},\"Income CHIP Eligible\":{\"Indicator\":\"Y\"},\"Medicaid CHIPRA 214\":{\"Indicator\":\"X\"},\"CHIP CHIPRA 214\":{\"Indicator\":\"X\"},\"Trafficking Victim\":{\"Indicator\":\"X\"},\"Seven Year Limit\":{\"Indicator\":\"X\"},\"Five Year Bar\":{\"Indicator\":\"X\"},\"Title II Work Quarters Met\":{\"Indicator\":\"X\"},\"Medicaid Citizen Or Immigrant\":{\"Indicator\":\"Y\"},\"CHIP Citizen Or Immigrant\":{\"Indicator\":\"Y\"},\"Former Foster Care Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":400,\"Ineligibility Reason\":\"Applicant was not formerly in foster care\"},\"Work Quarters Override Income\":{\"Indicator\":\"N\",\"Ineligibility Code\":340,\"Ineligibility Reason\":\"Income is greater than 100% FPL\"},\"State Health Benefits CHIP\":{\"Indicator\":\"X\"},\"CHIP Waiting Period Satisfied\":{\"Indicator\":\"X\"},\"Dependent Child Covered\":{\"Indicator\":\"X\"},\"Medicaid Non-MAGI Referral\":{\"Indicator\":\"N\",\"Ineligibility Code\":108,\"Ineligibility Reason\":\"Applicant does not meet requirements for a non-MAGI referral\"},\"Emergency Medicaid\":{\"Indicator\":\"N\",\"Ineligibility Code\":109,\"Ineligibility Reason\":\"Applicant does not meet the eligibility criteria for emergency Medicaid\"},\"Refugee Medical Assistance\":{\"Indicator\":\"X\"},\"APTC Referral\":{\"Indicator\":\"Y\"}},\"Other Outputs\":{\"Qualified Children List\":[]}},{\"Person ID\":1002598,\"Medicaid Household\":{\"People\":[1002584,1002592,1002593,1002594,1002595,1002596,1002597,1002598,1002599],\"MAGI\":99658,\"MAGI as Percentage of FPL\":202,\"Size\":9},\"Medicaid Eligible\":\"N\",\"CHIP Eligible\":\"Y\",\"Ineligibility Reason\":[\"Applicant's MAGI above the threshold for category\"],\"Non-MAGI Referral\":\"N\",\"Category\":\"Child Category\",\"Category Threshold\":79704,\"CHIP Category\":\"CHIP Targeted Low Income Child\",\"CHIP Category Threshold\":104796,\"Determinations\":{\"Residency\":{\"Indicator\":\"Y\"},\"Adult Group Category\":{\"Indicator\":\"X\"},\"Parent Caretaker Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":146,\"Ineligibility Reason\":\"No child met all criteria for parent caretaker category\"},\"Pregnancy Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":124,\"Ineligibility Reason\":\"Applicant not pregnant or within postpartum period\"},\"Child Category\":{\"Indicator\":\"Y\"},\"Optional Targeted Low Income Child\":{\"Indicator\":\"X\"},\"CHIP Targeted Low Income Child\":{\"Indicator\":\"Y\"},\"Unborn Child\":{\"Indicator\":\"X\"},\"Income Medicaid Eligible\":{\"Indicator\":\"N\",\"Ineligibility Code\":402,\"Ineligibility Reason\":\"Applicant's income is greater than the threshold for all eligible categories\"},\"Income CHIP Eligible\":{\"Indicator\":\"Y\"},\"Medicaid CHIPRA 214\":{\"Indicator\":\"X\"},\"CHIP CHIPRA 214\":{\"Indicator\":\"X\"},\"Trafficking Victim\":{\"Indicator\":\"X\"},\"Seven Year Limit\":{\"Indicator\":\"X\"},\"Five Year Bar\":{\"Indicator\":\"X\"},\"Title II Work Quarters Met\":{\"Indicator\":\"X\"},\"Medicaid Citizen Or Immigrant\":{\"Indicator\":\"Y\"},\"CHIP Citizen Or Immigrant\":{\"Indicator\":\"Y\"},\"Former Foster Care Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":400,\"Ineligibility Reason\":\"Applicant was not formerly in foster care\"},\"Work Quarters Override Income\":{\"Indicator\":\"N\",\"Ineligibility Code\":340,\"Ineligibility Reason\":\"Income is greater than 100% FPL\"},\"State Health Benefits CHIP\":{\"Indicator\":\"X\"},\"CHIP Waiting Period Satisfied\":{\"Indicator\":\"X\"},\"Dependent Child Covered\":{\"Indicator\":\"X\"},\"Medicaid Non-MAGI Referral\":{\"Indicator\":\"N\",\"Ineligibility Code\":108,\"Ineligibility Reason\":\"Applicant does not meet requirements for a non-MAGI referral\"},\"Emergency Medicaid\":{\"Indicator\":\"N\",\"Ineligibility Code\":109,\"Ineligibility Reason\":\"Applicant does not meet the eligibility criteria for emergency Medicaid\"},\"Refugee Medical Assistance\":{\"Indicator\":\"X\"},\"APTC Referral\":{\"Indicator\":\"Y\"}},\"Other Outputs\":{\"Qualified Children List\":[]}},{\"Person ID\":1002599,\"Medicaid Household\":{\"People\":[1002584,1002592,1002593,1002594,1002595,1002596,1002597,1002598,1002599],\"MAGI\":99658,\"MAGI as Percentage of FPL\":202,\"Size\":9},\"Medicaid Eligible\":\"N\",\"CHIP Eligible\":\"Y\",\"Ineligibility Reason\":[\"Applicant's MAGI above the threshold for category\"],\"Non-MAGI Referral\":\"N\",\"Category\":\"Child Category\",\"Category Threshold\":79704,\"CHIP Category\":\"CHIP Targeted Low Income Child\",\"CHIP Category Threshold\":104796,\"Determinations\":{\"Residency\":{\"Indicator\":\"Y\"},\"Adult Group Category\":{\"Indicator\":\"X\"},\"Parent Caretaker Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":146,\"Ineligibility Reason\":\"No child met all criteria for parent caretaker category\"},\"Pregnancy Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":124,\"Ineligibility Reason\":\"Applicant not pregnant or within postpartum period\"},\"Child Category\":{\"Indicator\":\"Y\"},\"Optional Targeted Low Income Child\":{\"Indicator\":\"X\"},\"CHIP Targeted Low Income Child\":{\"Indicator\":\"Y\"},\"Unborn Child\":{\"Indicator\":\"X\"},\"Income Medicaid Eligible\":{\"Indicator\":\"N\",\"Ineligibility Code\":402,\"Ineligibility Reason\":\"Applicant's income is greater than the threshold for all eligible categories\"},\"Income CHIP Eligible\":{\"Indicator\":\"Y\"},\"Medicaid CHIPRA 214\":{\"Indicator\":\"X\"},\"CHIP CHIPRA 214\":{\"Indicator\":\"X\"},\"Trafficking Victim\":{\"Indicator\":\"X\"},\"Seven Year Limit\":{\"Indicator\":\"X\"},\"Five Year Bar\":{\"Indicator\":\"X\"},\"Title II Work Quarters Met\":{\"Indicator\":\"X\"},\"Medicaid Citizen Or Immigrant\":{\"Indicator\":\"Y\"},\"CHIP Citizen Or Immigrant\":{\"Indicator\":\"Y\"},\"Former Foster Care Category\":{\"Indicator\":\"N\",\"Ineligibility Code\":400,\"Ineligibility Reason\":\"Applicant was not formerly in foster care\"},\"Work Quarters Override Income\":{\"Indicator\":\"N\",\"Ineligibility Code\":340,\"Ineligibility Reason\":\"Income is greater than 100% FPL\"},\"State Health Benefits CHIP\":{\"Indicator\":\"X\"},\"CHIP Waiting Period Satisfied\":{\"Indicator\":\"X\"},\"Dependent Child Covered\":{\"Indicator\":\"X\"},\"Medicaid Non-MAGI Referral\":{\"Indicator\":\"N\",\"Ineligibility Code\":108,\"Ineligibility Reason\":\"Applicant does not meet requirements for a non-MAGI referral\"},\"Emergency Medicaid\":{\"Indicator\":\"N\",\"Ineligibility Code\":109,\"Ineligibility Reason\":\"Applicant does not meet the eligibility criteria for emergency Medicaid\"},\"Refugee Medical Assistance\":{\"Indicator\":\"X\"},\"APTC Referral\":{\"Indicator\":\"Y\"}},\"Other Outputs\":{\"Qualified Children List\":[]}}]}}"
  end

  let(:mitc_response) do
    JSON.parse(mitc_string_response, :symbolize_names => true)[:medicaid_response_payload]
  end
end
# rubocop:enable Layout/LineLength
