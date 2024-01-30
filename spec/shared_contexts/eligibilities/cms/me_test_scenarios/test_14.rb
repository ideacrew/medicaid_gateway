# frozen_string_literal: true

# rubocop:disable Layout/LineLength
RSpec.shared_context 'cms ME me_test_scenarios test_14', :shared_context => :metadata do
  let(:today) { Date.today }
  let(:assistance_year) { today.year.next }
  let(:oe_start_on) { today.beginning_of_month }
  let(:start_of_year) { today.beginning_of_year }
  let(:aptc_effective_date) { Date.new(assistance_year) }

  let(:app_params) do
    {
      "family_reference" => {
        "hbx_id" => "31348"
      }, "assistance_year" => assistance_year, "aptc_effective_date" => aptc_effective_date, "years_to_renew" => assistance_year + 5, "renewal_consent_through_year" => 5, "is_ridp_verified" => true, "is_renewal_authorized" => true, "applicants" => [{
        "name" => {
          "first_name" => "Ctest", "middle_name" => nil, "last_name" => "Test", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "Ge5Dk1279ExQMcbDMm8vcoQBuvgCIsJHng==\n", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Female", "dob" => "1959-10-26", "ethnicity" => ["", "White", "", "", "", "", "", ""], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false
        },
        "is_primary_applicant" => true,
        "native_american_information" => {
          "indian_tribe_member" => false, "tribal_name" => nil, "tribal_state" => nil
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
          "family_member_hbx_id" => "1039699", "first_name" => "Ctest", "last_name" => "Test", "person_hbx_id" => "1039699", "is_primary_family_member" => true
        },
        "person_hbx_id" => "1039699",
        "is_required_to_file_taxes" => true,
        "is_filing_as_head_of_household" => false,
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
          "address_1" => "64 Test",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "Test City",
          "county" => "Test",
          "state" => "ME",
          "zip" => "04614",
          "country_name" => nil
        }, {
          "kind" => "mailing",
          "address_1" => "64 Test",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "Test City",
          "county" => "Test",
          "state" => "ME",
          "zip" => "04614",
          "country_name" => nil
        }],
        "emails" => [{
          "kind" => "home",
          "address" => "test@dummy.com"
        }],
        "phones" => [{
          "kind" => "mobile",
          "country_code" => nil,
          "area_code" => "207",
          "number" => "1111111",
          "extension" => nil,
          "primary" => false,
          "full_phone_number" => "2071111111"
        }],
        "incomes" => [{
          "title" => nil,
          "kind" => "net_self_employment",
          "wage_type" => nil,
          "hours_per_week" => nil,
          "amount" => "20000.0",
          "amount_tax_exempt" => "0.0",
          "frequency_kind" => "Annually",
          "start_on" => start_of_year.to_s,
          "end_on" => nil,
          "is_projected" => false,
          "employer" => nil,
          "has_property_usage_rights" => nil,
          "submitted_at" => start_of_year.to_s
        }],
        "benefits" => [],
        "deductions" => [],
        "is_medicare_eligible" => false,
        "has_insurance" => false,
        "has_state_health_benefit" => false,
        "had_prior_insurance" => false,
        "prior_insurance_end_date" => nil,
        "age_of_applicant" => 62,
        "is_self_attested_long_term_care" => false,
        "hours_worked_per_week" => 0,
        "is_temporarily_out_of_state" => false,
        "is_claimed_as_dependent_by_non_applicant" => false,
        "benchmark_premium" => {
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1039699",
            "monthly_premium" => "1160.59"
          }, {
            "member_identifier" => "1039708",
            "monthly_premium" => "1211.9"
          }, {
            "member_identifier" => "1039721",
            "monthly_premium" => "1211.9"
          }, {
            "member_identifier" => "1039731",
            "monthly_premium" => "1211.9"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1039699",
            "monthly_premium" => "1173.61"
          }, {
            "member_identifier" => "1039708",
            "monthly_premium" => "1225.49"
          }, {
            "member_identifier" => "1039721",
            "monthly_premium" => "1225.49"
          }, {
            "member_identifier" => "1039731",
            "monthly_premium" => "1225.49"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 20_000, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 20_000, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_039_708,
          "attest_primary_responsibility" => "Y",
          "relationship_code" => "02"
        }, {
          "other_id" => 1_039_721,
          "attest_primary_responsibility" => "Y",
          "relationship_code" => "04"
        }, {
          "other_id" => 1_039_731,
          "attest_primary_responsibility" => "Y",
          "relationship_code" => "04"
        }],
        "mitc_is_required_to_file_taxes" => true,
        "income_evidence" => nil,
        "esi_evidence" => nil,
        "non_esi_evidence" => nil,
        "local_mec_evidence" => nil
      }, {
        "name" => {
          "first_name" => "Ftest", "middle_name" => nil, "last_name" => "Test", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "R1ZBG8LwhxEufTQp+EsKaIQEv/4FLcZMkA==\n", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Male", "dob" => "1957-07-23", "ethnicity" => ["White"], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false
        },
        "is_primary_applicant" => false,
        "native_american_information" => {
          "indian_tribe_member" => false, "tribal_name" => nil, "tribal_state" => nil
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
          "family_member_hbx_id" => "1039708", "first_name" => "Ftest", "last_name" => "Test", "person_hbx_id" => "1039708", "is_primary_family_member" => false
        },
        "person_hbx_id" => "1039708",
        "is_required_to_file_taxes" => true,
        "is_filing_as_head_of_household" => false,
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
          "address_1" => "64 Test",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "Test City",
          "county" => "Test",
          "state" => "ME",
          "zip" => "04614",
          "country_name" => nil
        }],
        "emails" => [],
        "phones" => [],
        "incomes" => [{
          "title" => nil,
          "kind" => "net_self_employment",
          "wage_type" => nil,
          "hours_per_week" => nil,
          "amount" => "41625.00",
          "amount_tax_exempt" => "0.0",
          "frequency_kind" => "Annually",
          "start_on" => start_of_year.to_s,
          "end_on" => nil,
          "is_projected" => false,
          "employer" => nil,
          "has_property_usage_rights" => nil,
          "submitted_at" => start_of_year.to_s
        }],
        "benefits" => [],
        "deductions" => [],
        "is_medicare_eligible" => false,
        "has_insurance" => false,
        "has_state_health_benefit" => false,
        "had_prior_insurance" => false,
        "prior_insurance_end_date" => nil,
        "age_of_applicant" => 64,
        "is_self_attested_long_term_care" => false,
        "hours_worked_per_week" => 0,
        "is_temporarily_out_of_state" => false,
        "is_claimed_as_dependent_by_non_applicant" => false,
        "benchmark_premium" => {
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1039699",
            "monthly_premium" => "1160.59"
          }, {
            "member_identifier" => "1039708",
            "monthly_premium" => "1211.9"
          }, {
            "member_identifier" => "1039721",
            "monthly_premium" => "1211.9"
          }, {
            "member_identifier" => "1039731",
            "monthly_premium" => "1211.9"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1039699",
            "monthly_premium" => "1173.61"
          }, {
            "member_identifier" => "1039708",
            "monthly_premium" => "1225.49"
          }, {
            "member_identifier" => "1039721",
            "monthly_premium" => "1225.49"
          }, {
            "member_identifier" => "1039731",
            "monthly_premium" => "1225.49"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 23_000, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 23_000, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_039_699,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "02"
        }, {
          "other_id" => 1_039_721,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "26"
        }, {
          "other_id" => 1_039_731,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "26"
        }],
        "mitc_is_required_to_file_taxes" => true,
        "income_evidence" => nil,
        "esi_evidence" => nil,
        "non_esi_evidence" => nil,
        "local_mec_evidence" => nil
      }, {
        "name" => {
          "first_name" => "Ptest", "middle_name" => nil, "last_name" => "Test", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "ftzCv1Z0az8LQpLORjAmCIQBuv8LIsNMlQ==\n", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Female", "dob" => "1931-05-30", "ethnicity" => ["White"], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false
        },
        "is_primary_applicant" => false,
        "native_american_information" => {
          "indian_tribe_member" => false, "tribal_name" => nil, "tribal_state" => nil
        },
        "citizenship_immigration_status_information" => {
          "citizen_status" => nil, "is_resident_post_092296" => false, "is_lawful_presence_self_attested" => false
        },
        "is_consumer_role" => true,
        "is_resident_role" => false,
        "is_applying_coverage" => false,
        "is_consent_applicant" => false,
        "vlp_document" => nil,
        "family_member_reference" => {
          "family_member_hbx_id" => "1039721", "first_name" => "Ptest", "last_name" => "Test", "person_hbx_id" => "1039721", "is_primary_family_member" => false
        },
        "person_hbx_id" => "1039721",
        "is_required_to_file_taxes" => false,
        "is_filing_as_head_of_household" => false,
        "tax_filer_kind" => "dependent",
        "is_joint_tax_filing" => false,
        "is_claimed_as_tax_dependent" => true,
        "claimed_as_tax_dependent_by" => {
          "first_name" => "Ctest", "last_name" => "Test", "dob" => "1959-10-26", "person_hbx_id" => "1039699", "encrypted_ssn" => "Ge5Dk1279ExQMcbDMm8vcoQBuvgCIsJHng==\n"
        },
        "student" => {
          "is_student" => false, "student_kind" => nil, "student_school_kind" => nil, "student_status_end_on" => nil
        },
        "is_refugee" => false,
        "is_trafficking_victim" => false,
        "foster_care" => {
          "is_former_foster_care" => false, "age_left_foster_care" => 0, "foster_care_us_state" => nil, "had_medicaid_during_foster_care" => false
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
          "address_1" => "1451 test road",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "Test city",
          "county" => "Test county",
          "state" => "CO",
          "zip" => "81230",
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
        "age_of_applicant" => 90,
        "is_self_attested_long_term_care" => false,
        "hours_worked_per_week" => 0,
        "is_temporarily_out_of_state" => false,
        "is_claimed_as_dependent_by_non_applicant" => false,
        "benchmark_premium" => {
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1039699",
            "monthly_premium" => "1160.59"
          }, {
            "member_identifier" => "1039708",
            "monthly_premium" => "1211.9"
          }, {
            "member_identifier" => "1039721",
            "monthly_premium" => "1211.9"
          }, {
            "member_identifier" => "1039731",
            "monthly_premium" => "1211.9"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1039699",
            "monthly_premium" => "1173.61"
          }, {
            "member_identifier" => "1039708",
            "monthly_premium" => "1225.49"
          }, {
            "member_identifier" => "1039721",
            "monthly_premium" => "1225.49"
          }, {
            "member_identifier" => "1039731",
            "monthly_premium" => "1225.49"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 0, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 0, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_039_699,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "03"
        }, {
          "other_id" => 1_039_708,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "30"
        }, {
          "other_id" => 1_039_731,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "02"
        }],
        "mitc_is_required_to_file_taxes" => false,
        "income_evidence" => nil,
        "esi_evidence" => nil,
        "non_esi_evidence" => nil,
        "local_mec_evidence" => nil
      }, {
        "name" => {
          "first_name" => "Rtest", "middle_name" => nil, "last_name" => "Test", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "OAn/C+DG6nzW9kbbMgpIAIQBvPoBLchNlw==\n", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Male", "dob" => "1930-04-04", "ethnicity" => ["White"], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false
        },
        "is_primary_applicant" => false,
        "native_american_information" => {
          "indian_tribe_member" => false, "tribal_name" => nil, "tribal_state" => nil
        },
        "citizenship_immigration_status_information" => {
          "citizen_status" => nil, "is_resident_post_092296" => false, "is_lawful_presence_self_attested" => false
        },
        "is_consumer_role" => true,
        "is_resident_role" => false,
        "is_applying_coverage" => false,
        "is_consent_applicant" => false,
        "vlp_document" => nil,
        "family_member_reference" => {
          "family_member_hbx_id" => "1039731", "first_name" => "Rtest", "last_name" => "Test", "person_hbx_id" => "1039731", "is_primary_family_member" => false
        },
        "person_hbx_id" => "1039731",
        "is_required_to_file_taxes" => false,
        "is_filing_as_head_of_household" => false,
        "tax_filer_kind" => "dependent",
        "is_joint_tax_filing" => false,
        "is_claimed_as_tax_dependent" => true,
        "claimed_as_tax_dependent_by" => {
          "first_name" => "Ctest", "last_name" => "Test", "dob" => "1959-10-26", "person_hbx_id" => "1039699", "encrypted_ssn" => "Ge5Dk1279ExQMcbDMm8vcoQBuvgCIsJHng==\n"
        },
        "student" => {
          "is_student" => false, "student_kind" => nil, "student_school_kind" => nil, "student_status_end_on" => nil
        },
        "is_refugee" => false,
        "is_trafficking_victim" => false,
        "foster_care" => {
          "is_former_foster_care" => false, "age_left_foster_care" => 0, "foster_care_us_state" => nil, "had_medicaid_during_foster_care" => false
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
          "address_1" => "1451 test road",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "Test city",
          "county" => "Test county",
          "state" => "CO",
          "zip" => "81230",
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
        "age_of_applicant" => 91,
        "is_self_attested_long_term_care" => false,
        "hours_worked_per_week" => 0,
        "is_temporarily_out_of_state" => false,
        "is_claimed_as_dependent_by_non_applicant" => false,
        "benchmark_premium" => {
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1039699",
            "monthly_premium" => "1160.59"
          }, {
            "member_identifier" => "1039708",
            "monthly_premium" => "1211.9"
          }, {
            "member_identifier" => "1039721",
            "monthly_premium" => "1211.9"
          }, {
            "member_identifier" => "1039731",
            "monthly_premium" => "1211.9"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1039699",
            "monthly_premium" => "1173.61"
          }, {
            "member_identifier" => "1039708",
            "monthly_premium" => "1225.49"
          }, {
            "member_identifier" => "1039721",
            "monthly_premium" => "1225.49"
          }, {
            "member_identifier" => "1039731",
            "monthly_premium" => "1225.49"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 0, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 0, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_039_699,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "03"
        }, {
          "other_id" => 1_039_708,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "30"
        }, {
          "other_id" => 1_039_721,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "02"
        }],
        "mitc_is_required_to_file_taxes" => false,
        "income_evidence" => nil,
        "esi_evidence" => nil,
        "non_esi_evidence" => nil,
        "local_mec_evidence" => nil
      }], "tax_households" => [{
        "max_aptc" => "0.0",
        "hbx_id" => "104784",
        "is_insurance_assistance_eligible" => "UnDetermined",
        "tax_household_members" => [{
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "Ctest", "last_name" => "Test", "dob" => "1959-10-26", "person_hbx_id" => "1039699", "encrypted_ssn" => "Ge5Dk1279ExQMcbDMm8vcoQBuvgCIsJHng==\n"
          }
        }, {
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "Ftest", "last_name" => "Test", "dob" => "1957-07-23", "person_hbx_id" => "1039708", "encrypted_ssn" => "R1ZBG8LwhxEufTQp+EsKaIQEv/4FLcZMkA==\n"
          }
        }, {
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "Ptest", "last_name" => "Test", "dob" => "1931-05-30", "person_hbx_id" => "1039721", "encrypted_ssn" => "ftzCv1Z0az8LQpLORjAmCIQBuv8LIsNMlQ==\n"
          }
        }, {
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "Rtest", "last_name" => "Test", "dob" => "1930-04-04", "person_hbx_id" => "1039731", "encrypted_ssn" => "OAn/C+DG6nzW9kbbMgpIAIQBvPoBLchNlw==\n"
          }
        }],
        "annual_tax_household_income" => "0.0"
      }], "relationships" => [{
        "kind" => "spouse",
        "applicant_reference" => {
          "first_name" => "Ftest", "last_name" => "Test", "dob" => "1957-07-23", "person_hbx_id" => "1039708", "encrypted_ssn" => "R1ZBG8LwhxEufTQp+EsKaIQEv/4FLcZMkA==\n"
        },
        "relative_reference" => {
          "first_name" => "Ctest", "last_name" => "Test", "dob" => "1959-10-26", "person_hbx_id" => "1039699", "encrypted_ssn" => "Ge5Dk1279ExQMcbDMm8vcoQBuvgCIsJHng==\n"
        }
      }, {
        "kind" => "spouse",
        "applicant_reference" => {
          "first_name" => "Ctest", "last_name" => "Test", "dob" => "1959-10-26", "person_hbx_id" => "1039699", "encrypted_ssn" => "Ge5Dk1279ExQMcbDMm8vcoQBuvgCIsJHng==\n"
        },
        "relative_reference" => {
          "first_name" => "Ftest", "last_name" => "Test", "dob" => "1957-07-23", "person_hbx_id" => "1039708", "encrypted_ssn" => "R1ZBG8LwhxEufTQp+EsKaIQEv/4FLcZMkA==\n"
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "Ptest", "last_name" => "Test", "dob" => "1931-05-30", "person_hbx_id" => "1039721", "encrypted_ssn" => "ftzCv1Z0az8LQpLORjAmCIQBuv8LIsNMlQ==\n"
        },
        "relative_reference" => {
          "first_name" => "Ctest", "last_name" => "Test", "dob" => "1959-10-26", "person_hbx_id" => "1039699", "encrypted_ssn" => "Ge5Dk1279ExQMcbDMm8vcoQBuvgCIsJHng==\n"
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "Ctest", "last_name" => "Test", "dob" => "1959-10-26", "person_hbx_id" => "1039699", "encrypted_ssn" => "Ge5Dk1279ExQMcbDMm8vcoQBuvgCIsJHng==\n"
        },
        "relative_reference" => {
          "first_name" => "Ptest", "last_name" => "Test", "dob" => "1931-05-30", "person_hbx_id" => "1039721", "encrypted_ssn" => "ftzCv1Z0az8LQpLORjAmCIQBuv8LIsNMlQ==\n"
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "Rtest", "last_name" => "Test", "dob" => "1930-04-04", "person_hbx_id" => "1039731", "encrypted_ssn" => "OAn/C+DG6nzW9kbbMgpIAIQBvPoBLchNlw==\n"
        },
        "relative_reference" => {
          "first_name" => "Ctest", "last_name" => "Test", "dob" => "1959-10-26", "person_hbx_id" => "1039699", "encrypted_ssn" => "Ge5Dk1279ExQMcbDMm8vcoQBuvgCIsJHng==\n"
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "Ctest", "last_name" => "Test", "dob" => "1959-10-26", "person_hbx_id" => "1039699", "encrypted_ssn" => "Ge5Dk1279ExQMcbDMm8vcoQBuvgCIsJHng==\n"
        },
        "relative_reference" => {
          "first_name" => "Rtest", "last_name" => "Test", "dob" => "1930-04-04", "person_hbx_id" => "1039731", "encrypted_ssn" => "OAn/C+DG6nzW9kbbMgpIAIQBvPoBLchNlw==\n"
        }
      }, {
        "kind" => "father_or_mother_in_law",
        "applicant_reference" => {
          "first_name" => "Ptest", "last_name" => "Test", "dob" => "1931-05-30", "person_hbx_id" => "1039721", "encrypted_ssn" => "ftzCv1Z0az8LQpLORjAmCIQBuv8LIsNMlQ==\n"
        },
        "relative_reference" => {
          "first_name" => "Ftest", "last_name" => "Test", "dob" => "1957-07-23", "person_hbx_id" => "1039708", "encrypted_ssn" => "R1ZBG8LwhxEufTQp+EsKaIQEv/4FLcZMkA==\n"
        }
      }, {
        "kind" => "daughter_or_son_in_law",
        "applicant_reference" => {
          "first_name" => "Ftest", "last_name" => "Test", "dob" => "1957-07-23", "person_hbx_id" => "1039708", "encrypted_ssn" => "R1ZBG8LwhxEufTQp+EsKaIQEv/4FLcZMkA==\n"
        },
        "relative_reference" => {
          "first_name" => "Ptest", "last_name" => "Test", "dob" => "1931-05-30", "person_hbx_id" => "1039721", "encrypted_ssn" => "ftzCv1Z0az8LQpLORjAmCIQBuv8LIsNMlQ==\n"
        }
      }, {
        "kind" => "father_or_mother_in_law",
        "applicant_reference" => {
          "first_name" => "Rtest", "last_name" => "Test", "dob" => "1930-04-04", "person_hbx_id" => "1039731", "encrypted_ssn" => "OAn/C+DG6nzW9kbbMgpIAIQBvPoBLchNlw==\n"
        },
        "relative_reference" => {
          "first_name" => "Ftest", "last_name" => "Test", "dob" => "1957-07-23", "person_hbx_id" => "1039708", "encrypted_ssn" => "R1ZBG8LwhxEufTQp+EsKaIQEv/4FLcZMkA==\n"
        }
      }, {
        "kind" => "daughter_or_son_in_law",
        "applicant_reference" => {
          "first_name" => "Ftest", "last_name" => "Test", "dob" => "1957-07-23", "person_hbx_id" => "1039708", "encrypted_ssn" => "R1ZBG8LwhxEufTQp+EsKaIQEv/4FLcZMkA==\n"
        },
        "relative_reference" => {
          "first_name" => "Rtest", "last_name" => "Test", "dob" => "1930-04-04", "person_hbx_id" => "1039731", "encrypted_ssn" => "OAn/C+DG6nzW9kbbMgpIAIQBvPoBLchNlw==\n"
        }
      }, {
        "kind" => "spouse",
        "applicant_reference" => {
          "first_name" => "Ptest", "last_name" => "Test", "dob" => "1931-05-30", "person_hbx_id" => "1039721", "encrypted_ssn" => "ftzCv1Z0az8LQpLORjAmCIQBuv8LIsNMlQ==\n"
        },
        "relative_reference" => {
          "first_name" => "Rtest", "last_name" => "Test", "dob" => "1930-04-04", "person_hbx_id" => "1039731", "encrypted_ssn" => "OAn/C+DG6nzW9kbbMgpIAIQBvPoBLchNlw==\n"
        }
      }, {
        "kind" => "spouse",
        "applicant_reference" => {
          "first_name" => "Rtest", "last_name" => "Test", "dob" => "1930-04-04", "person_hbx_id" => "1039731", "encrypted_ssn" => "OAn/C+DG6nzW9kbbMgpIAIQBvPoBLchNlw==\n"
        },
        "relative_reference" => {
          "first_name" => "Ptest", "last_name" => "Test", "dob" => "1931-05-30", "person_hbx_id" => "1039721", "encrypted_ssn" => "ftzCv1Z0az8LQpLORjAmCIQBuv8LIsNMlQ==\n"
        }
      }], "us_state" => "ME", "hbx_id" => "1255958", "oe_start_on" => oe_start_on, "notice_options" => {
        "send_eligibility_notices" => true, "send_open_enrollment_notices" => false, "paper_notification" => false
      }, "mitc_households" => [{
        "household_id" => "1",
        "people" => [{
          "person_id" => 1_039_699
        }, {
          "person_id" => 1_039_708
        }]
      }, {
        "household_id" => "2",
        "people" => [{
          "person_id" => 1_039_721
        }, {
          "person_id" => 1_039_731
        }]
      }], "mitc_tax_returns" => [{
        "filers" => [{
          "person_id" => 1_039_699
        }, {
          "person_id" => 1_039_708
        }],
        "dependents" => [{
          "person_id" => 1_039_721
        }, {
          "person_id" => 1_039_731
        }]
      }], "submitted_at" => start_of_year.to_s
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
      "Determination Date" => start_of_year.to_s, "Applicants" => [{
        "Person ID" => 1_039_699,
        "Medicaid Household" => {
          "People" => [1_039_699, 1_039_708, 1_039_721, 1_039_731], "MAGI" => 46_200, "MAGI as Percentage of FPL" => 154, "Size" => 4
        },
        "Medicaid Eligible" => "N",
        "CHIP Eligible" => "N",
        "Ineligibility Reason" => ["Applicant's MAGI above the threshold for category"],
        "Non-MAGI Referral" => "N",
        "CHIP Ineligibility Reason" => ["Applicant did not meet the requirements for any CHIP category"],
        "Category" => "Adult Group Category",
        "Category Threshold" => 38_295,
        "CHIP Category" => "None",
        "CHIP Category Threshold" => 0,
        "Determinations" => {
          "Residency" => {
            "Indicator" => "Y"
          }, "Adult Group Category" => {
            "Indicator" => "Y"
          }, "Parent Caretaker Category" => {
            "Indicator" => "N", "Ineligibility Code" => 146, "Ineligibility Reason" => "No child met all criteria for parent caretaker category"
          }, "Pregnancy Category" => {
            "Indicator" => "N", "Ineligibility Code" => 124, "Ineligibility Reason" => "Applicant not pregnant or within postpartum period"
          }, "Child Category" => {
            "Indicator" => "N", "Ineligibility Code" => 394, "Ineligibility Reason" => "Applicant is over the age limit for the young adult threshold in the state"
          }, "Optional Targeted Low Income Child" => {
            "Indicator" => "X"
          }, "CHIP Targeted Low Income Child" => {
            "Indicator" => "N", "Ineligibility Code" => 127, "Ineligibility Reason" => "Applicant's age is not within the allowed age range"
          }, "Unborn Child" => {
            "Indicator" => "X"
          }, "Income Medicaid Eligible" => {
            "Indicator" => "N", "Ineligibility Code" => 402, "Ineligibility Reason" => "Applicant's income is greater than the threshold for all eligible categories"
          }, "Income CHIP Eligible" => {
            "Indicator" => "N", "Ineligibility Code" => 401, "Ineligibility Reason" => "Applicant did not meet the requirements for any eligibility category"
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
            "Indicator" => "N", "Ineligibility Code" => 400, "Ineligibility Reason" => "Applicant was not formerly in foster care"
          }, "Work Quarters Override Income" => {
            "Indicator" => "N", "Ineligibility Code" => 340, "Ineligibility Reason" => "Income is greater than 100% FPL"
          }, "State Health Benefits CHIP" => {
            "Indicator" => "X"
          }, "CHIP Waiting Period Satisfied" => {
            "Indicator" => "X"
          }, "Dependent Child Covered" => {
            "Indicator" => "X"
          }, "Medicaid Non-MAGI Referral" => {
            "Indicator" => "N", "Ineligibility Code" => 108, "Ineligibility Reason" => "Applicant does not meet requirements for a non-MAGI referral"
          }, "Emergency Medicaid" => {
            "Indicator" => "N", "Ineligibility Code" => 109, "Ineligibility Reason" => "Applicant does not meet the eligibility criteria for emergency Medicaid"
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
        "Person ID" => 1_039_708,
        "Medicaid Household" => {
          "People" => [1_039_699, 1_039_708, 1_039_721, 1_039_731], "MAGI" => 46_200, "MAGI as Percentage of FPL" => 154, "Size" => 4
        },
        "Medicaid Eligible" => "N",
        "CHIP Eligible" => "N",
        "Ineligibility Reason" => ["Applicant's MAGI above the threshold for category"],
        "Non-MAGI Referral" => "N",
        "CHIP Ineligibility Reason" => ["Applicant did not meet the requirements for any CHIP category"],
        "Category" => "Adult Group Category",
        "Category Threshold" => 38_295,
        "CHIP Category" => "None",
        "CHIP Category Threshold" => 0,
        "Determinations" => {
          "Residency" => {
            "Indicator" => "Y"
          }, "Adult Group Category" => {
            "Indicator" => "Y"
          }, "Parent Caretaker Category" => {
            "Indicator" => "N", "Ineligibility Code" => 146, "Ineligibility Reason" => "No child met all criteria for parent caretaker category"
          }, "Pregnancy Category" => {
            "Indicator" => "N", "Ineligibility Code" => 124, "Ineligibility Reason" => "Applicant not pregnant or within postpartum period"
          }, "Child Category" => {
            "Indicator" => "N", "Ineligibility Code" => 394, "Ineligibility Reason" => "Applicant is over the age limit for the young adult threshold in the state"
          }, "Optional Targeted Low Income Child" => {
            "Indicator" => "X"
          }, "CHIP Targeted Low Income Child" => {
            "Indicator" => "N", "Ineligibility Code" => 127, "Ineligibility Reason" => "Applicant's age is not within the allowed age range"
          }, "Unborn Child" => {
            "Indicator" => "X"
          }, "Income Medicaid Eligible" => {
            "Indicator" => "N", "Ineligibility Code" => 402, "Ineligibility Reason" => "Applicant's income is greater than the threshold for all eligible categories"
          }, "Income CHIP Eligible" => {
            "Indicator" => "N", "Ineligibility Code" => 401, "Ineligibility Reason" => "Applicant did not meet the requirements for any eligibility category"
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
            "Indicator" => "N", "Ineligibility Code" => 400, "Ineligibility Reason" => "Applicant was not formerly in foster care"
          }, "Work Quarters Override Income" => {
            "Indicator" => "N", "Ineligibility Code" => 340, "Ineligibility Reason" => "Income is greater than 100% FPL"
          }, "State Health Benefits CHIP" => {
            "Indicator" => "X"
          }, "CHIP Waiting Period Satisfied" => {
            "Indicator" => "X"
          }, "Dependent Child Covered" => {
            "Indicator" => "X"
          }, "Medicaid Non-MAGI Referral" => {
            "Indicator" => "N", "Ineligibility Code" => 108, "Ineligibility Reason" => "Applicant does not meet requirements for a non-MAGI referral"
          }, "Emergency Medicaid" => {
            "Indicator" => "N", "Ineligibility Code" => 109, "Ineligibility Reason" => "Applicant does not meet the eligibility criteria for emergency Medicaid"
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
# rubocop:enable Layout/LineLength
