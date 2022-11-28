# frozen_string_literal: true

RSpec.shared_context 'gap_filling test_1321470', :shared_context => :metadata do
  let(:today) { Date.today }
  let(:assistance_year) { today.year.next }
  let(:oe_start_on) { today.beginning_of_month }
  let(:start_of_year) { today.beginning_of_year }
  let(:aptc_effective_date) { Date.new(assistance_year) }

  let(:app_params) do
    {
      "family_reference" => {
        "hbx_id" => "1195478"
      },
      "assistance_year" => assistance_year, "aptc_effective_date" => aptc_effective_date.to_s, "years_to_renew" => assistance_year + 5,
      "renewal_consent_through_year" => 5, "is_ridp_verified" => true, "is_renewal_authorized" => true,
      "applicants" => [{
        "name" => {
          "first_name" => "Primary", "middle_name" => "De", "last_name" => "Test", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "YwTVJEpqyW+qHgLUNH3mNoYAvf4LLsRMlg==\n", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Female", "dob" => "1984-08-29", "ethnicity" => ["Black or African American"],
          "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false,
          "is_self_attested_long_term_care" => false
        },
        "is_primary_applicant" => true,
        "native_american_information" => {
          "indian_tribe_member" => false, "tribal_name" => nil, "tribal_state" => nil
        },
        "citizenship_immigration_status_information" => {
          "citizen_status" => "alien_lawfully_present", "is_resident_post_092296" => true, "is_lawful_presence_self_attested" => true
        },
        "is_consumer_role" => true,
        "is_resident_role" => false,
        "is_applying_coverage" => true,
        "five_year_bar_applies" => true,
        "five_year_bar_met" => false,
        "qualified_non_citizen" => true,
        "is_consent_applicant" => false,
        "vlp_document" => {
          "subject" => "I-551 (Permanent Resident Card)", "alien_number" => "067725410", "i94_number" => nil,
          "visa_number" => nil, "passport_number" => nil, "sevis_id" => nil, "naturalization_number" => nil,
          "receipt_number" => nil, "citizenship_number" => nil, "card_number" => "ioe0473694285",
          "country_of_citizenship" => nil, "expiration_date" => "2032-06-06T00:00:00.000+00:00", "issuing_country" => nil
        },
        "family_member_reference" => {
          "family_member_hbx_id" => "1195475", "first_name" => "Primary", "last_name" => "Test",
          "person_hbx_id" => "1195475", "is_primary_family_member" => true
        },
        "person_hbx_id" => "1195475",
        "is_required_to_file_taxes" => true,
        "is_filing_as_head_of_household" => true,
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
          "is_pregnant" => false, "is_enrolled_on_medicaid" => false, "is_post_partum_period" => false,
          "expected_children_count" => nil, "pregnancy_due_on" => nil, "pregnancy_end_on" => nil
        },
        "is_primary_caregiver" => true,
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
          "not_eligible_in_last_90_days" => true, "denied_on" => today.to_s, "ended_as_change_in_eligibility" => false,
          "hh_income_or_size_changed" => false, "medicaid_or_chip_coverage_end_date" => nil,
          "ineligible_due_to_immigration_in_last_5_years" => true, "immigration_status_changed_since_ineligibility" => false
        },
        "other_health_service" => {
          "has_received" => false, "is_eligible" => false
        },
        "addresses" => [{
          "kind" => "home",
          "address_1" => "200 Address Street",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "Cityyy",
          "county" => "Waldo",
          "state" => "ME",
          "zip" => "04915",
          "country_name" => nil
        }, {
          "kind" => "mailing",
          "address_1" => "100 Dummy Ave",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "Cityyy",
          "county" => "Waldo",
          "state" => "ME",
          "zip" => "04915",
          "country_name" => nil
        }],
        "emails" => [{
          "kind" => "home",
          "address" => "primary@gmail.com"
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
          "kind" => "wages_and_salaries",
          "wage_type" => nil,
          "hours_per_week" => nil,
          "amount" => "12775.0",
          "amount_tax_exempt" => nil,
          "frequency_kind" => "SemiAnnually",
          "start_on" => aptc_effective_date.to_s,
          "end_on" => nil,
          "is_projected" => false,
          "employer" => {
            "employer_name" => "Front Street Pub (Crusty Crab LLC)", "employer_id" => nil
          },
          "has_property_usage_rights" => nil,
          "ssi_type" => nil,
          "submitted_at" => start_of_year.to_s
        }],
        "benefits" => [],
        "deductions" => [],
        "is_medicare_eligible" => false,
        "has_insurance" => false,
        "has_state_health_benefit" => false,
        "had_prior_insurance" => false,
        "prior_insurance_end_date" => nil,
        "age_of_applicant" => 38,
        "is_self_attested_long_term_care" => false,
        "hours_worked_per_week" => 0,
        "is_temporarily_out_of_state" => false,
        "is_claimed_as_dependent_by_non_applicant" => false,
        "benchmark_premium" => {
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1195475",
            "monthly_premium" => "420.36"
          }, {
            "member_identifier" => "1195479",
            "monthly_premium" => "487.16"
          }, {
            "member_identifier" => "1195480",
            "monthly_premium" => "258.09"
          }, {
            "member_identifier" => "1195481",
            "monthly_premium" => "258.09"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1195475",
            "monthly_premium" => "424.19"
          }, {
            "member_identifier" => "1195479",
            "monthly_premium" => "491.6"
          }, {
            "member_identifier" => "1195480",
            "monthly_premium" => "260.44"
          }, {
            "member_identifier" => "1195481",
            "monthly_premium" => "260.44"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 25_550, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0,
          "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0,
          "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0,
          "magi_deductions" => 0, "adjusted_gross_income" => 12_880, "deductible_part_of_self_employment_tax" => 0,
          "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_195_479,
          "attest_primary_responsibility" => "Y",
          "relationship_code" => "02"
        }, {
          "other_id" => 1_195_480,
          "attest_primary_responsibility" => "Y",
          "relationship_code" => "03"
        }, {
          "other_id" => 1_195_481,
          "attest_primary_responsibility" => "Y",
          "relationship_code" => "03"
        }],
        "mitc_state_resident" => true,
        "mitc_is_required_to_file_taxes" => true,
        "income_evidence" => {
          "key" => "income", "title" => "Income", "aasm_state" => "review", "description" => nil,
          "received_at" => start_of_year.to_s, "is_satisfied" => false, "verification_outstanding" => true,
          "update_reason" => "document uploaded", "due_on" => aptc_effective_date.to_s,
          "external_service" => nil, "updated_by" => "dummy@test.com",
          "verification_histories" => [{
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }, {
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }, {
            "action" => "Upload Primary Test pay stub - 1 (1).jpg",
            "modifier" => nil,
            "update_reason" => nil,
            "updated_by" => "dummy@test.com",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }, {
            "action" => "Upload Primary Test pay stub - 2 (1).jpg",
            "modifier" => nil,
            "update_reason" => nil,
            "updated_by" => "dummy@test.com",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }], "request_results" => [{
            "result" => "outstanding",
            "source" => "FDSH IFSV",
            "source_transaction_id" => "1317882",
            "code" => nil,
            "code_description" => nil,
            "raw_payload" => "{\"request_id\":\"1317882\",\"is_ifsv_eligible\":false,\"max_dollar_cap\":12000.0,\"max_percentage_factor\":50}"
          }, {
            "result" => "outstanding",
            "source" => "FDSH IFSV",
            "source_transaction_id" => "1317920",
            "code" => nil,
            "code_description" => nil,
            "raw_payload" => "{\"request_id\":\"1317920\",\"is_ifsv_eligible\":false,\"max_dollar_cap\":12000.0,\"max_percentage_factor\":50}"
          }]
        },
        "esi_evidence" => {
          "key" => "esi_mec", "title" => "ESI MEC", "aasm_state" => "unverified", "description" => nil,
          "received_at" => start_of_year.to_s, "is_satisfied" => true, "verification_outstanding" => false,
          "update_reason" => nil, "due_on" => nil,
          "external_service" => nil, "updated_by" => nil,
          "verification_histories" => [{
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }, {
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }]
        },
        "non_esi_evidence" => {
          "key" => "non_esi_mec", "title" => "Non ESI MEC", "aasm_state" => "unverified", "description" => nil,
          "received_at" => start_of_year.to_s, "is_satisfied" => true, "verification_outstanding" => false,
          "update_reason" => nil, "due_on" => nil,
          "external_service" => nil, "updated_by" => nil,
          "verification_histories" => [{
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }, {
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }]
        },
        "local_mec_evidence" => {
          "key" => "local_mec", "title" => "Local MEC", "aasm_state" => "unverified", "description" => nil,
          "received_at" => start_of_year.to_s, "is_satisfied" => true, "verification_outstanding" => false,
          "update_reason" => nil, "due_on" => nil,
          "external_service" => nil, "updated_by" => nil,
          "verification_histories" => [{
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }, {
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }]
        }
      }, {
        "name" => {
          "first_name" => "Dependent1", "middle_name" => "Fitzgerald", "last_name" => "Test", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "dZdnL0R2pT0tKXA3pAPNd4EDvvkHI8NMng==\n", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Male", "dob" => "1977-07-16", "ethnicity" => [], "race" => nil,
          "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false,
          "is_self_attested_long_term_care" => false
        },
        "is_primary_applicant" => false,
        "native_american_information" => {
          "indian_tribe_member" => false, "tribal_name" => nil, "tribal_state" => nil
        },
        "citizenship_immigration_status_information" => {
          "citizen_status" => "alien_lawfully_present", "is_resident_post_092296" => true, "is_lawful_presence_self_attested" => true
        },
        "is_consumer_role" => true,
        "is_resident_role" => false,
        "is_applying_coverage" => true,
        "five_year_bar_applies" => true,
        "five_year_bar_met" => false,
        "qualified_non_citizen" => true,
        "is_consent_applicant" => false,
        "vlp_document" => {
          "subject" => "I-551 (Permanent Resident Card)", "alien_number" => "067725409", "i94_number" => nil,
          "visa_number" => nil, "passport_number" => nil, "sevis_id" => nil, "naturalization_number" => nil,
          "receipt_number" => nil, "citizenship_number" => nil, "card_number" => "ioe0468714126",
          "country_of_citizenship" => nil, "expiration_date" => "2032-06-06T00:00:00.000+00:00", "issuing_country" => nil
        },
        "family_member_reference" => {
          "family_member_hbx_id" => "1195479", "first_name" => "Dependent1", "last_name" => "Test",
          "person_hbx_id" => "1195479", "is_primary_family_member" => false
        },
        "person_hbx_id" => "1195479",
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
          "is_pregnant" => false, "is_enrolled_on_medicaid" => false, "is_post_partum_period" => false,
          "expected_children_count" => nil, "pregnancy_due_on" => nil, "pregnancy_end_on" => nil
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
        "need_help_paying_bills" => true,
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
          "not_eligible_in_last_90_days" => true, "denied_on" => today.to_s, "ended_as_change_in_eligibility" => false,
          "hh_income_or_size_changed" => false, "medicaid_or_chip_coverage_end_date" => nil,
          "ineligible_due_to_immigration_in_last_5_years" => true, "immigration_status_changed_since_ineligibility" => false
        },
        "other_health_service" => {
          "has_received" => false, "is_eligible" => false
        },
        "addresses" => [{
          "kind" => "mailing",
          "address_1" => "100 Dummy Ave",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "Cityyy",
          "county" => "Waldo",
          "state" => "ME",
          "zip" => "04915",
          "country_name" => nil
        }, {
          "kind" => "home",
          "address_1" => "200 Address Street",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "Cityyy",
          "county" => "Waldo",
          "state" => "ME",
          "zip" => "04915",
          "country_name" => nil
        }],
        "emails" => [],
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
          "kind" => "wages_and_salaries",
          "wage_type" => nil,
          "hours_per_week" => nil,
          "amount" => "11271.0",
          "amount_tax_exempt" => nil,
          "frequency_kind" => "SemiAnnually",
          "start_on" => aptc_effective_date.to_s,
          "end_on" => nil,
          "is_projected" => false,
          "employer" => {
            "employer_name" => "Front Street Pub (Crusty Crab LLC)", "employer_id" => nil
          },
          "has_property_usage_rights" => nil,
          "ssi_type" => nil,
          "submitted_at" => start_of_year.to_s
        }],
        "benefits" => [],
        "deductions" => [],
        "is_medicare_eligible" => false,
        "has_insurance" => false,
        "has_state_health_benefit" => false,
        "had_prior_insurance" => false,
        "prior_insurance_end_date" => nil,
        "age_of_applicant" => 45,
        "is_self_attested_long_term_care" => false,
        "hours_worked_per_week" => 0,
        "is_temporarily_out_of_state" => false,
        "is_claimed_as_dependent_by_non_applicant" => false,
        "benchmark_premium" => {
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1195475",
            "monthly_premium" => "420.36"
          }, {
            "member_identifier" => "1195479",
            "monthly_premium" => "487.16"
          }, {
            "member_identifier" => "1195480",
            "monthly_premium" => "258.09"
          }, {
            "member_identifier" => "1195481",
            "monthly_premium" => "258.09"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1195475",
            "monthly_premium" => "424.19"
          }, {
            "member_identifier" => "1195479",
            "monthly_premium" => "491.6"
          }, {
            "member_identifier" => "1195480",
            "monthly_premium" => "260.44"
          }, {
            "member_identifier" => "1195481",
            "monthly_premium" => "260.44"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 22_542, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0,
          "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0,
          "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0,
          "magi_deductions" => 0, "adjusted_gross_income" => 11_363, "deductible_part_of_self_employment_tax" => 0,
          "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_195_475,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "02"
        }, {
          "other_id" => 1_195_480,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "03"
        }, {
          "other_id" => 1_195_481,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "03"
        }],
        "mitc_state_resident" => true,
        "mitc_is_required_to_file_taxes" => true,
        "income_evidence" => {
          "key" => "income", "title" => "Income", "aasm_state" => "review", "description" => nil,
          "received_at" => start_of_year.to_s, "is_satisfied" => false, "verification_outstanding" => true,
          "update_reason" => "document uploaded", "due_on" => aptc_effective_date.to_s,
          "external_service" => nil, "updated_by" => "dummy@test.com",
          "verification_histories" => [{
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }, {
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }, {
            "action" => "Upload Dependent1 Test pay stub (1).jpg",
            "modifier" => nil,
            "update_reason" => nil,
            "updated_by" => "dummy@test.com",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }], "request_results" => [{
            "result" => "outstanding",
            "source" => "FDSH IFSV",
            "source_transaction_id" => "1317882",
            "code" => nil,
            "code_description" => nil,
            "raw_payload" => "{\"request_id\":\"1317882\",\"is_ifsv_eligible\":false,\"max_dollar_cap\":12000.0,\"max_percentage_factor\":50}"
          }, {
            "result" => "outstanding",
            "source" => "FDSH IFSV",
            "source_transaction_id" => "1317920",
            "code" => nil,
            "code_description" => nil,
            "raw_payload" => "{\"request_id\":\"1317920\",\"is_ifsv_eligible\":false,\"max_dollar_cap\":12000.0,\"max_percentage_factor\":50}"
          }]
        },
        "esi_evidence" => {
          "key" => "esi_mec", "title" => "ESI MEC", "aasm_state" => "unverified", "description" => nil,
          "received_at" => start_of_year.to_s, "is_satisfied" => true, "verification_outstanding" => false,
          "update_reason" => nil, "due_on" => nil,
          "external_service" => nil, "updated_by" => nil,
          "verification_histories" => [{
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }, {
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }]
        },
        "non_esi_evidence" => {
          "key" => "non_esi_mec", "title" => "Non ESI MEC", "aasm_state" => "unverified", "description" => nil,
          "received_at" => start_of_year.to_s, "is_satisfied" => true, "verification_outstanding" => false,
          "update_reason" => nil, "due_on" => nil,
          "external_service" => nil, "updated_by" => nil,
          "verification_histories" => [{
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }, {
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }]
        },
        "local_mec_evidence" => {
          "key" => "local_mec", "title" => "Local MEC", "aasm_state" => "unverified", "description" => nil,
          "received_at" => start_of_year.to_s, "is_satisfied" => true, "verification_outstanding" => false,
          "update_reason" => nil, "due_on" => nil,
          "external_service" => nil, "updated_by" => nil,
          "verification_histories" => [{
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }, {
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }]
        }
      }, {
        "name" => {
          "first_name" => "Dependent2", "middle_name" => nil, "last_name" => "Test", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "ejusjjbdu5uvVz9jX5xNyoULvv8AI8VHlw==\n", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Female", "dob" => "2019-04-03", "ethnicity" => [''], "race" => nil,
          "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false,
          "is_self_attested_long_term_care" => false
        },
        "is_primary_applicant" => false,
        "native_american_information" => {
          "indian_tribe_member" => false, "tribal_name" => nil, "tribal_state" => nil
        },
        "citizenship_immigration_status_information" => {
          "citizen_status" => "alien_lawfully_present", "is_resident_post_092296" => true, "is_lawful_presence_self_attested" => true
        },
        "is_consumer_role" => true,
        "is_resident_role" => false,
        "is_applying_coverage" => true,
        "five_year_bar_applies" => true,
        "five_year_bar_met" => true,
        "qualified_non_citizen" => true,
        "is_consent_applicant" => false,
        "vlp_document" => {
          "subject" => "I-551 (Permanent Resident Card)", "alien_number" => "067725412", "i94_number" => nil,
          "visa_number" => nil, "passport_number" => nil, "sevis_id" => nil, "naturalization_number" => nil,
          "receipt_number" => nil, "citizenship_number" => nil, "card_number" => "ioe0710003549",
          "country_of_citizenship" => nil, "expiration_date" => "2032-06-06T00:00:00.000+00:00", "issuing_country" => nil
        },
        "family_member_reference" => {
          "family_member_hbx_id" => "1195480", "first_name" => "Dependent2", "last_name" => "Test",
          "person_hbx_id" => "1195480", "is_primary_family_member" => false
        },
        "person_hbx_id" => "1195480",
        "is_required_to_file_taxes" => false,
        "is_filing_as_head_of_household" => false,
        "tax_filer_kind" => "dependent",
        "is_joint_tax_filing" => false,
        "is_claimed_as_tax_dependent" => true,
        "claimed_as_tax_dependent_by" => {
          "first_name" => "Primary", "last_name" => "Test", "dob" => "1984-08-29",
          "person_hbx_id" => "1195475", "encrypted_ssn" => "YwTVJEpqyW+qHgLUNH3mNoYAvf4LLsRMlg==\n"
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
          "is_pregnant" => false, "is_enrolled_on_medicaid" => false, "is_post_partum_period" => false,
          "expected_children_count" => nil, "pregnancy_due_on" => nil, "pregnancy_end_on" => nil
        },
        "is_primary_caregiver" => nil,
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
          "not_eligible_in_last_90_days" => true, "denied_on" => today.to_s, "ended_as_change_in_eligibility" => false,
          "hh_income_or_size_changed" => false, "medicaid_or_chip_coverage_end_date" => nil,
          "ineligible_due_to_immigration_in_last_5_years" => true, "immigration_status_changed_since_ineligibility" => false
        },
        "other_health_service" => {
          "has_received" => false, "is_eligible" => false
        },
        "addresses" => [{
          "kind" => "mailing",
          "address_1" => "100 Dummy Ave",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "Cityyy",
          "county" => "Waldo",
          "state" => "ME",
          "zip" => "04915",
          "country_name" => nil
        }, {
          "kind" => "home",
          "address_1" => "200 Address Street",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "Cityyy",
          "county" => "Waldo",
          "state" => "ME",
          "zip" => "04915",
          "country_name" => nil
        }],
        "emails" => [],
        "phones" => [{
          "kind" => "mobile",
          "country_code" => nil,
          "area_code" => "207",
          "number" => "1111111",
          "extension" => nil,
          "primary" => false,
          "full_phone_number" => "2071111111"
        }],
        "incomes" => [],
        "benefits" => [],
        "deductions" => [],
        "is_medicare_eligible" => false,
        "has_insurance" => false,
        "has_state_health_benefit" => false,
        "had_prior_insurance" => false,
        "prior_insurance_end_date" => nil,
        "age_of_applicant" => 3,
        "is_self_attested_long_term_care" => false,
        "hours_worked_per_week" => 0,
        "is_temporarily_out_of_state" => false,
        "is_claimed_as_dependent_by_non_applicant" => false,
        "benchmark_premium" => {
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "1195475",
            "monthly_premium" => "420.36"
          }, {
            "member_identifier" => "1195479",
            "monthly_premium" => "487.16"
          }, {
            "member_identifier" => "1195480",
            "monthly_premium" => "258.09"
          }, {
            "member_identifier" => "1195481",
            "monthly_premium" => "258.09"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1195475",
            "monthly_premium" => "424.19"
          }, {
            "member_identifier" => "1195479",
            "monthly_premium" => "491.6"
          }, {
            "member_identifier" => "1195480",
            "monthly_premium" => "260.44"
          }, {
            "member_identifier" => "1195481",
            "monthly_premium" => "260.44"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 0, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0,
          "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0,
          "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0,
          "magi_deductions" => 0, "adjusted_gross_income" => 0, "deductible_part_of_self_employment_tax" => 0,
          "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_195_475,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }, {
          "other_id" => 1_195_481,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_195_479,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }],
        "mitc_state_resident" => true,
        "mitc_is_required_to_file_taxes" => false,
        "income_evidence" => {
          "key" => "income", "title" => "Income", "aasm_state" => "outstanding", "description" => nil,
          "received_at" => start_of_year.to_s, "is_satisfied" => false, "verification_outstanding" => true,
          "update_reason" => nil, "due_on" => aptc_effective_date.to_s,
          "external_service" => nil, "updated_by" => nil,
          "verification_histories" => [{
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }, {
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }], "request_results" => [{
            "result" => "outstanding",
            "source" => "FDSH IFSV",
            "source_transaction_id" => "1317882",
            "code" => nil,
            "code_description" => nil,
            "raw_payload" => "{\"request_id\":\"1317882\",\"is_ifsv_eligible\":false,\"max_dollar_cap\":12000.0,\"max_percentage_factor\":50}"
          }, {
            "result" => "outstanding",
            "source" => "FDSH IFSV",
            "source_transaction_id" => "1317920",
            "code" => nil,
            "code_description" => nil,
            "raw_payload" => "{\"request_id\":\"1317920\",\"is_ifsv_eligible\":false,\"max_dollar_cap\":12000.0,\"max_percentage_factor\":50}"
          }]
        },
        "esi_evidence" => {
          "key" => "esi_mec", "title" => "ESI MEC", "aasm_state" => "unverified", "description" => nil,
          "received_at" => start_of_year.to_s, "is_satisfied" => true, "verification_outstanding" => false,
          "update_reason" => nil, "due_on" => nil,
          "external_service" => nil, "updated_by" => nil,
          "verification_histories" => [{
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }, {
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }]
        },
        "non_esi_evidence" => {
          "key" => "non_esi_mec", "title" => "Non ESI MEC", "aasm_state" => "unverified", "description" => nil,
          "received_at" => start_of_year.to_s, "is_satisfied" => true, "verification_outstanding" => false,
          "update_reason" => nil, "due_on" => nil,
          "external_service" => nil, "updated_by" => nil,
          "verification_histories" => [{
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }, {
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }]
        },
        "local_mec_evidence" => {
          "key" => "local_mec", "title" => "Local MEC", "aasm_state" => "unverified", "description" => nil,
          "received_at" => start_of_year.to_s, "is_satisfied" => true, "verification_outstanding" => false,
          "update_reason" => nil, "due_on" => nil,
          "external_service" => nil, "updated_by" => nil,
          "verification_histories" => [{
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }, {
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }]
        }
      }, {
        "name" => {
          "first_name" => "Dependent3", "middle_name" => nil, "last_name" => "Test", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => nil, "has_ssn" => true
        },
        "demographic" => {
          "gender" => "Male", "dob" => "2009-12-10", "ethnicity" => [''],
          "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false,
          "is_self_attested_long_term_care" => false
        },
        "is_primary_applicant" => false,
        "native_american_information" => {
          "indian_tribe_member" => false, "tribal_name" => nil, "tribal_state" => nil
        },
        "citizenship_immigration_status_information" => {
          "citizen_status" => "alien_lawfully_present", "is_resident_post_092296" => true, "is_lawful_presence_self_attested" => true
        },
        "is_consumer_role" => true,
        "is_resident_role" => false,
        "is_applying_coverage" => true,
        "five_year_bar_applies" => true,
        "five_year_bar_met" => false,
        "qualified_non_citizen" => true,
        "is_consent_applicant" => false,
        "vlp_document" => {
          "subject" => "I-551 (Permanent Resident Card)", "alien_number" => "067725411", "i94_number" => nil,
          "visa_number" => nil, "passport_number" => nil, "sevis_id" => nil, "naturalization_number" => nil,
          "receipt_number" => nil, "citizenship_number" => nil, "card_number" => "oeo0705962818",
          "country_of_citizenship" => nil, "expiration_date" => "2032-06-06T00:00:00.000+00:00", "issuing_country" => nil
        },
        "family_member_reference" => {
          "family_member_hbx_id" => "1195481", "first_name" => "Dependent3", "last_name" => "Test",
          "person_hbx_id" => "1195481", "is_primary_family_member" => false
        },
        "person_hbx_id" => "1195481",
        "is_required_to_file_taxes" => false,
        "is_filing_as_head_of_household" => false,
        "tax_filer_kind" => "dependent",
        "is_joint_tax_filing" => false,
        "is_claimed_as_tax_dependent" => true,
        "claimed_as_tax_dependent_by" => {
          "first_name" => "Primary", "last_name" => "Test", "dob" => "1984-08-29",
          "person_hbx_id" => "1195475", "encrypted_ssn" => "YwTVJEpqyW+qHgLUNH3mNoYAvf4LLsRMlg==\n"
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
          "is_pregnant" => false, "is_enrolled_on_medicaid" => false, "is_post_partum_period" => false,
          "expected_children_count" => nil, "pregnancy_due_on" => nil, "pregnancy_end_on" => nil
        },
        "is_primary_caregiver" => nil,
        "is_subject_to_five_year_bar" => false,
        "is_five_year_bar_met" => false,
        "is_forty_quarters" => false,
        "is_ssn_applied" => true,
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
          "not_eligible_in_last_90_days" => true, "denied_on" => today.to_s, "ended_as_change_in_eligibility" => false,
          "hh_income_or_size_changed" => false, "medicaid_or_chip_coverage_end_date" => nil,
          "ineligible_due_to_immigration_in_last_5_years" => true, "immigration_status_changed_since_ineligibility" => false
        },
        "other_health_service" => {
          "has_received" => false, "is_eligible" => false
        },
        "addresses" => [{
          "kind" => "mailing",
          "address_1" => "100 Dummy Ave",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "Cityyy",
          "county" => "Waldo",
          "state" => "ME",
          "zip" => "04915",
          "country_name" => nil
        }, {
          "kind" => "home",
          "address_1" => "200 Address Street",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "Cityyy",
          "county" => "Waldo",
          "state" => "ME",
          "zip" => "04915",
          "country_name" => nil
        }],
        "emails" => [],
        "phones" => [{
          "kind" => "mobile",
          "country_code" => nil,
          "area_code" => "207",
          "number" => "1111111",
          "extension" => nil,
          "primary" => false,
          "full_phone_number" => "2071111111"
        }],
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
            "member_identifier" => "1195475",
            "monthly_premium" => "420.36"
          }, {
            "member_identifier" => "1195479",
            "monthly_premium" => "487.16"
          }, {
            "member_identifier" => "1195480",
            "monthly_premium" => "258.09"
          }, {
            "member_identifier" => "1195481",
            "monthly_premium" => "258.09"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "1195475",
            "monthly_premium" => "424.19"
          }, {
            "member_identifier" => "1195479",
            "monthly_premium" => "491.6"
          }, {
            "member_identifier" => "1195480",
            "monthly_premium" => "260.44"
          }, {
            "member_identifier" => "1195481",
            "monthly_premium" => "260.44"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 0, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0,
          "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0,
          "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0,
          "magi_deductions" => 0, "adjusted_gross_income" => 0, "deductible_part_of_self_employment_tax" => 0,
          "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 1_195_475,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }, {
          "other_id" => 1_195_480,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "07"
        }, {
          "other_id" => 1_195_479,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }],
        "mitc_state_resident" => true,
        "mitc_is_required_to_file_taxes" => false,
        "income_evidence" => {
          "key" => "income", "title" => "Income", "aasm_state" => "outstanding", "description" => nil,
          "received_at" => start_of_year.to_s, "is_satisfied" => false, "verification_outstanding" => true,
          "update_reason" => nil, "due_on" => aptc_effective_date.to_s,
          "external_service" => nil, "updated_by" => nil,
          "verification_histories" => [{
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }, {
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }], "request_results" => [{
            "result" => "outstanding",
            "source" => "FDSH IFSV",
            "source_transaction_id" => "1317882",
            "code" => nil,
            "code_description" => nil,
            "raw_payload" => "{\"request_id\":\"1317882\",\"is_ifsv_eligible\":false,\"max_dollar_cap\":12000.0,\"max_percentage_factor\":50}"
          }, {
            "result" => "outstanding",
            "source" => "FDSH IFSV",
            "source_transaction_id" => "1317920",
            "code" => nil,
            "code_description" => nil,
            "raw_payload" => "{\"request_id\":\"1317920\",\"is_ifsv_eligible\":false,\"max_dollar_cap\":12000.0,\"max_percentage_factor\":50}"
          }]
        },
        "esi_evidence" => {
          "key" => "esi_mec", "title" => "ESI MEC", "aasm_state" => "unverified", "description" => nil,
          "received_at" => start_of_year.to_s, "is_satisfied" => true, "verification_outstanding" => false,
          "update_reason" => nil, "due_on" => nil,
          "external_service" => nil, "updated_by" => nil,
          "verification_histories" => [{
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }, {
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }]
        },
        "non_esi_evidence" => {
          "key" => "non_esi_mec", "title" => "Non ESI MEC", "aasm_state" => "unverified", "description" => nil,
          "received_at" => start_of_year.to_s, "is_satisfied" => true, "verification_outstanding" => false,
          "update_reason" => nil, "due_on" => nil,
          "external_service" => nil, "updated_by" => nil,
          "verification_histories" => [{
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }, {
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }]
        },
        "local_mec_evidence" => {
          "key" => "local_mec", "title" => "Local MEC", "aasm_state" => "unverified", "description" => nil,
          "received_at" => start_of_year.to_s, "is_satisfied" => true, "verification_outstanding" => false,
          "update_reason" => nil, "due_on" => nil,
          "external_service" => nil, "updated_by" => nil,
          "verification_histories" => [{
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }, {
            "action" => "application_determined",
            "modifier" => nil,
            "update_reason" => "Requested Hub for verification",
            "updated_by" => "system",
            "is_satisfied" => nil,
            "verification_outstanding" => nil,
            "due_on" => nil,
            "aasm_state" => nil
          }]
        }
      }], "tax_households" => [{
        "max_aptc" => "0.0",
        "hbx_id" => "156026",
        "is_insurance_assistance_eligible" => "UnDetermined",
        "tax_household_members" => [{
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false,
            "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false,
            "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil,
            "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "Primary", "last_name" => "Test", "dob" => "1984-08-29",
            "person_hbx_id" => "1195475", "encrypted_ssn" => "YwTVJEpqyW+qHgLUNH3mNoYAvf4LLsRMlg==\n"
          }
        }, {
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false,
            "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false,
            "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil,
            "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "Dependent1", "last_name" => "Test", "dob" => "1977-07-16",
            "person_hbx_id" => "1195479", "encrypted_ssn" => "dZdnL0R2pT0tKXA3pAPNd4EDvvkHI8NMng==\n"
          }
        }, {
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false,
            "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false,
            "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil,
            "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "Dependent2", "last_name" => "Test", "dob" => "2019-04-03",
            "person_hbx_id" => "1195480", "encrypted_ssn" => "ejusjjbdu5uvVz9jX5xNyoULvv8AI8VHlw==\n"
          }
        }, {
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false,
            "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false,
            "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil,
            "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "Dependent3", "last_name" => "Test", "dob" => "2009-12-10",
            "person_hbx_id" => "1195481", "encrypted_ssn" => nil
          }
        }],
        "annual_tax_household_income" => "0.0",
        "effective_on" => nil,
        "determined_on" => nil,
        "yearly_expected_contribution" => "0.0"
      }], "relationships" => [{
        "kind" => "spouse",
        "applicant_reference" => {
          "first_name" => "Dependent1", "last_name" => "Test", "dob" => "1977-07-16",
          "person_hbx_id" => "1195479", "encrypted_ssn" => "dZdnL0R2pT0tKXA3pAPNd4EDvvkHI8NMng==\n"
        },
        "relative_reference" => {
          "first_name" => "Primary", "last_name" => "Test", "dob" => "1984-08-29",
          "person_hbx_id" => "1195475", "encrypted_ssn" => "YwTVJEpqyW+qHgLUNH3mNoYAvf4LLsRMlg==\n"
        }
      }, {
        "kind" => "spouse",
        "applicant_reference" => {
          "first_name" => "Primary", "last_name" => "Test", "dob" => "1984-08-29",
          "person_hbx_id" => "1195475", "encrypted_ssn" => "YwTVJEpqyW+qHgLUNH3mNoYAvf4LLsRMlg==\n"
        },
        "relative_reference" => {
          "first_name" => "Dependent1", "last_name" => "Test", "dob" => "1977-07-16",
          "person_hbx_id" => "1195479", "encrypted_ssn" => "dZdnL0R2pT0tKXA3pAPNd4EDvvkHI8NMng==\n"
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "Dependent2", "last_name" => "Test", "dob" => "2019-04-03",
          "person_hbx_id" => "1195480", "encrypted_ssn" => "ejusjjbdu5uvVz9jX5xNyoULvv8AI8VHlw==\n"
        },
        "relative_reference" => {
          "first_name" => "Primary", "last_name" => "Test", "dob" => "1984-08-29",
          "person_hbx_id" => "1195475", "encrypted_ssn" => "YwTVJEpqyW+qHgLUNH3mNoYAvf4LLsRMlg==\n"
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "Primary", "last_name" => "Test", "dob" => "1984-08-29",
          "person_hbx_id" => "1195475", "encrypted_ssn" => "YwTVJEpqyW+qHgLUNH3mNoYAvf4LLsRMlg==\n"
        },
        "relative_reference" => {
          "first_name" => "Dependent2", "last_name" => "Test", "dob" => "2019-04-03",
          "person_hbx_id" => "1195480", "encrypted_ssn" => "ejusjjbdu5uvVz9jX5xNyoULvv8AI8VHlw==\n"
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "Dependent3", "last_name" => "Test", "dob" => "2009-12-10",
          "person_hbx_id" => "1195481", "encrypted_ssn" => nil
        },
        "relative_reference" => {
          "first_name" => "Primary", "last_name" => "Test", "dob" => "1984-08-29",
          "person_hbx_id" => "1195475", "encrypted_ssn" => "YwTVJEpqyW+qHgLUNH3mNoYAvf4LLsRMlg==\n"
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "Primary", "last_name" => "Test", "dob" => "1984-08-29",
          "person_hbx_id" => "1195475", "encrypted_ssn" => "YwTVJEpqyW+qHgLUNH3mNoYAvf4LLsRMlg==\n"
        },
        "relative_reference" => {
          "first_name" => "Dependent3", "last_name" => "Test", "dob" => "2009-12-10",
          "person_hbx_id" => "1195481", "encrypted_ssn" => nil
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "Dependent2", "last_name" => "Test", "dob" => "2019-04-03",
          "person_hbx_id" => "1195480", "encrypted_ssn" => "ejusjjbdu5uvVz9jX5xNyoULvv8AI8VHlw==\n"
        },
        "relative_reference" => {
          "first_name" => "Dependent3", "last_name" => "Test", "dob" => "2009-12-10",
          "person_hbx_id" => "1195481", "encrypted_ssn" => nil
        }
      }, {
        "kind" => "sibling",
        "applicant_reference" => {
          "first_name" => "Dependent3", "last_name" => "Test", "dob" => "2009-12-10",
          "person_hbx_id" => "1195481", "encrypted_ssn" => nil
        },
        "relative_reference" => {
          "first_name" => "Dependent2", "last_name" => "Test", "dob" => "2019-04-03",
          "person_hbx_id" => "1195480", "encrypted_ssn" => "ejusjjbdu5uvVz9jX5xNyoULvv8AI8VHlw==\n"
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "Dependent1", "last_name" => "Test", "dob" => "1977-07-16",
          "person_hbx_id" => "1195479", "encrypted_ssn" => "dZdnL0R2pT0tKXA3pAPNd4EDvvkHI8NMng==\n"
        },
        "relative_reference" => {
          "first_name" => "Dependent2", "last_name" => "Test", "dob" => "2019-04-03",
          "person_hbx_id" => "1195480", "encrypted_ssn" => "ejusjjbdu5uvVz9jX5xNyoULvv8AI8VHlw==\n"
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "Dependent2", "last_name" => "Test", "dob" => "2019-04-03",
          "person_hbx_id" => "1195480", "encrypted_ssn" => "ejusjjbdu5uvVz9jX5xNyoULvv8AI8VHlw==\n"
        },
        "relative_reference" => {
          "first_name" => "Dependent1", "last_name" => "Test", "dob" => "1977-07-16",
          "person_hbx_id" => "1195479", "encrypted_ssn" => "dZdnL0R2pT0tKXA3pAPNd4EDvvkHI8NMng==\n"
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "Dependent1", "last_name" => "Test", "dob" => "1977-07-16",
          "person_hbx_id" => "1195479", "encrypted_ssn" => "dZdnL0R2pT0tKXA3pAPNd4EDvvkHI8NMng==\n"
        },
        "relative_reference" => {
          "first_name" => "Dependent3", "last_name" => "Test", "dob" => "2009-12-10",
          "person_hbx_id" => "1195481", "encrypted_ssn" => nil
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "Dependent3", "last_name" => "Test", "dob" => "2009-12-10",
          "person_hbx_id" => "1195481", "encrypted_ssn" => nil
        },
        "relative_reference" => {
          "first_name" => "Dependent1", "last_name" => "Test", "dob" => "1977-07-16",
          "person_hbx_id" => "1195479", "encrypted_ssn" => "dZdnL0R2pT0tKXA3pAPNd4EDvvkHI8NMng==\n"
        }
      }], "us_state" => "ME", "hbx_id" => "1321470", "oe_start_on" => oe_start_on.to_s, "notice_options" => {
        "send_eligibility_notices" => true, "send_open_enrollment_notices" => false, "paper_notification" => true
      }, "mitc_households" => [{
        "household_id" => "1",
        "people" => [{
          "person_id" => 1_195_475
        }, {
          "person_id" => 1_195_479
        }, {
          "person_id" => 1_195_480
        }, {
          "person_id" => 1_195_481
        }]
      }], "mitc_tax_returns" => [{
        "filers" => [{
          "person_id" => 1_195_475
        }, {
          "person_id" => 1_195_479
        }],
        "dependents" => [{
          "person_id" => 1_195_480
        }, {
          "person_id" => 1_195_481
        }]
      }], "submitted_at" => start_of_year.to_s
    }
  end

  let(:application_entity) do
    app_params.deep_symbolize_keys!
    ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
  end

  let(:input_application) { application_entity.to_h }

  let(:mitc_string_response) do
    {
      "Determination Date" => start_of_year.to_s, "Applicants" => [{
        "Person ID" => 1_195_475,
        "Medicaid Household" => {
          "People" => [1_195_475, 1_195_479, 1_195_480, 1_195_481], "MAGI" => 48_092, "MAGI as Percentage of FPL" => 173, "Size" => 4
        },
        "Medicaid Eligible" => "N",
        "CHIP Eligible" => "N",
        "Ineligibility Reason" => ["Applicant did not meet citizenship/immigration requirements",
                                   "Applicant's MAGI above the threshold for category"],
        "Non-MAGI Referral" => "N",
        "CHIP Ineligibility Reason" => ["Applicant did not meet citizenship/immigration requirements",
                                        "Applicant did not meet the requirements for any CHIP category"],
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
            "Indicator" => "N", "Ineligibility Code" => 119,
            "Ineligibility Reason" => "Applicant is not a child or pregnant woman"
          }, "CHIP CHIPRA 214" => {
            "Indicator" => "N", "Ineligibility Code" => 118,
            "Ineligibility Reason" => "Applicant is not a child"
          }, "Trafficking Victim" => {
            "Indicator" => "N", "Ineligibility Code" => 410,
            "Ineligibility Reason" => "Applicant is not a victim of trafficking"
          }, "Seven Year Limit" => {
            "Indicator" => "X"
          }, "Five Year Bar" => {
            "Indicator" => "N", "Ineligibility Code" => 143,
            "Ineligibility Reason" => "Five Year bar in effect"
          }, "Title II Work Quarters Met" => {
            "Indicator" => "X"
          }, "Medicaid Citizen Or Immigrant" => {
            "Indicator" => "N", "Ineligibility Code" => 101,
            "Ineligibility Reason" => "Applicant did not meet all immigration requirements"
          }, "CHIP Citizen Or Immigrant" => {
            "Indicator" => "N", "Ineligibility Code" => 101,
            "Ineligibility Reason" => "Applicant did not meet all immigration requirements"
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
            "Person ID" => 1_195_480,
            "Determinations" => {
              "Dependent Age" => {
                "Indicator" => "Y"
              }, "Deprived Child" => {
                "Indicator" => "X"
              }, "Relationship" => {
                "Indicator" => "Y"
              }
            }
          }, {
            "Person ID" => 1_195_481,
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
        "Person ID" => 1_195_479,
        "Medicaid Household" => {
          "People" => [1_195_475, 1_195_479, 1_195_480, 1_195_481], "MAGI" => 48_092, "MAGI as Percentage of FPL" => 173, "Size" => 4
        },
        "Medicaid Eligible" => "N",
        "CHIP Eligible" => "N",
        "Ineligibility Reason" => ["Applicant did not meet citizenship/immigration requirements",
                                   "Applicant's MAGI above the threshold for category"],
        "Non-MAGI Referral" => "N",
        "CHIP Ineligibility Reason" => ["Applicant did not meet citizenship/immigration requirements",
                                        "Applicant did not meet the requirements for any CHIP category"],
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
            "Indicator" => "N", "Ineligibility Code" => 119,
            "Ineligibility Reason" => "Applicant is not a child or pregnant woman"
          }, "CHIP CHIPRA 214" => {
            "Indicator" => "N", "Ineligibility Code" => 118,
            "Ineligibility Reason" => "Applicant is not a child"
          }, "Trafficking Victim" => {
            "Indicator" => "N", "Ineligibility Code" => 410,
            "Ineligibility Reason" => "Applicant is not a victim of trafficking"
          }, "Seven Year Limit" => {
            "Indicator" => "X"
          }, "Five Year Bar" => {
            "Indicator" => "N", "Ineligibility Code" => 143,
            "Ineligibility Reason" => "Five Year bar in effect"
          }, "Title II Work Quarters Met" => {
            "Indicator" => "X"
          }, "Medicaid Citizen Or Immigrant" => {
            "Indicator" => "N", "Ineligibility Code" => 101,
            "Ineligibility Reason" => "Applicant did not meet all immigration requirements"
          }, "CHIP Citizen Or Immigrant" => {
            "Indicator" => "N", "Ineligibility Code" => 101,
            "Ineligibility Reason" => "Applicant did not meet all immigration requirements"
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
            "Person ID" => 1_195_480,
            "Determinations" => {
              "Dependent Age" => {
                "Indicator" => "Y"
              }, "Deprived Child" => {
                "Indicator" => "X"
              }, "Relationship" => {
                "Indicator" => "Y"
              }
            }
          }, {
            "Person ID" => 1_195_481,
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
        "Person ID" => 1_195_480,
        "Medicaid Household" => {
          "People" => [1_195_475, 1_195_479, 1_195_480, 1_195_481], "MAGI" => 48_092, "MAGI as Percentage of FPL" => 173, "Size" => 4
        },
        "Medicaid Eligible" => "N",
        "CHIP Eligible" => "Y",
        "Ineligibility Reason" => ["Applicant's MAGI above the threshold for category"],
        "Non-MAGI Referral" => "N",
        "Category" => "Child Category",
        "Category Threshold" => 44_955,
        "CHIP Category" => "CHIP Targeted Low Income Child",
        "CHIP Category Threshold" => 59_107,
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
            "Indicator" => "Y"
          }, "CHIP CHIPRA 214" => {
            "Indicator" => "Y"
          }, "Trafficking Victim" => {
            "Indicator" => "N", "Ineligibility Code" => 410,
            "Ineligibility Reason" => "Applicant is not a victim of trafficking"
          }, "Seven Year Limit" => {
            "Indicator" => "X"
          }, "Five Year Bar" => {
            "Indicator" => "Y"
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
        "Person ID" => 1_195_481,
        "Medicaid Household" => {
          "People" => [1_195_475, 1_195_479, 1_195_480, 1_195_481], "MAGI" => 48_092, "MAGI as Percentage of FPL" => 173, "Size" => 4
        },
        "Medicaid Eligible" => "N",
        "CHIP Eligible" => "Y",
        "Ineligibility Reason" => ["Applicant's MAGI above the threshold for category"],
        "Non-MAGI Referral" => "N",
        "Category" => "Child Category",
        "Category Threshold" => 44_955,
        "CHIP Category" => "CHIP Targeted Low Income Child",
        "CHIP Category Threshold" => 59_107,
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
            "Indicator" => "Y"
          }, "CHIP CHIPRA 214" => {
            "Indicator" => "Y"
          }, "Trafficking Victim" => {
            "Indicator" => "N", "Ineligibility Code" => 410,
            "Ineligibility Reason" => "Applicant is not a victim of trafficking"
          }, "Seven Year Limit" => {
            "Indicator" => "X"
          }, "Five Year Bar" => {
            "Indicator" => "N", "Ineligibility Code" => 143,
            "Ineligibility Reason" => "Five Year bar in effect"
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

  let(:mitc_response) { mitc_string_response.deep_symbolize_keys }
end
