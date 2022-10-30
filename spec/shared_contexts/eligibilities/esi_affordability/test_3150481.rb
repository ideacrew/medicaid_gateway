# frozen_string_literal: true

RSpec.shared_context 'esi_affordability test_3150481', :shared_context => :metadata do
  let(:assistance_year) { 2022 }
  let(:health_plan_meets_mvs_and_affordable) { true }
  let(:esi_covered) { 'family' }

  let(:app_params) do
    {
      "family_reference" => { "hbx_id" => "3080185" },
      "assistance_year" => assistance_year,
      "aptc_effective_date" => "2022-12-01",
      "years_to_renew" => 2027,
      "renewal_consent_through_year" => 5, "is_ridp_verified" => true, "is_renewal_authorized" => true,
      "applicants" => [{
        "name" => {
          "first_name" => "John", "middle_name" => nil, "last_name" => "October", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "bpjomPtFTXArQ2XYQ04VrIMAvvwLL8dLlA==\n", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Male", "dob" => "1970-01-01",
          "ethnicity" => ["", "", "", "", "", "", ""],
          "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false,
          "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false
        },
        "is_primary_applicant" => true,
        "native_american_information" => {
          "indian_tribe_member" => false, "tribal_name" => nil, "tribal_state" => nil
        },
        "citizenship_immigration_status_information" => {
          "citizen_status" => "us_citizen", "is_resident_post_092296" => nil, "is_lawful_presence_self_attested" => false
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
          "family_member_hbx_id" => "3080184", "first_name" => "John", "last_name" => "October", "person_hbx_id" => "3080184",
          "is_primary_family_member" => true
        },
        "person_hbx_id" => "3080184",
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
          "is_former_foster_care" => false, "age_left_foster_care" => nil, "foster_care_us_state" => nil,
          "had_medicaid_during_foster_care" => false
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
        "need_help_paying_bills" => false,
        "has_job_income" => true,
        "has_self_employment_income" => false,
        "has_unemployment_income" => false,
        "has_other_income" => false,
        "has_deductions" => false,
        "has_enrolled_health_coverage" => false,
        "has_eligible_health_coverage" => true,
        "job_coverage_ended_in_past_3_months" => false,
        "job_coverage_end_date" => nil,
        "medicaid_and_chip" => {
          "not_eligible_in_last_90_days" => false, "denied_on" => nil,
          "ended_as_change_in_eligibility" => false, "hh_income_or_size_changed" => false,
          "medicaid_or_chip_coverage_end_date" => nil, "ineligible_due_to_immigration_in_last_5_years" => false,
          "immigration_status_changed_since_ineligibility" => false
        },
        "other_health_service" => {
          "has_received" => false, "is_eligible" => false
        },
        "addresses" => [{
          "kind" => "home",
          "address_1" => "111 h",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "augusta",
          "county" => "Kennebec",
          "state" => "ME",
          "zip" => "04330",
          "country_name" => nil
        }],
        "emails" => [],
        "phones" => [],
        "incomes" => [{
          "title" => nil,
          "kind" => "wages_and_salaries",
          "wage_type" => nil,
          "hours_per_week" => nil,
          "amount" => "80000.0",
          "amount_tax_exempt" => "0.0",
          "frequency_kind" => "Annually",
          "start_on" => "2022-01-01",
          "end_on" => nil,
          "is_projected" => false,
          "employer" => {
            "employer_name" => "Test LLC", "employer_id" => nil
          },
          "has_property_usage_rights" => nil,
          "ssi_type" => nil,
          "submitted_at" => "2022-11-01T15:42:47.000+00:00"
        }],
        "benefits" => [{
          "name" => nil,
          "kind" => "employer_sponsored_insurance",
          "status" => "is_eligible",
          "is_employer_sponsored" => false,
          "employer" => {
            "employer_name" => "test llc", "employer_id" => "56-7890987"
          },
          "esi_covered" => esi_covered,
          "is_esi_waiting_period" => false,
          "is_esi_mec_met" => true,
          "employee_cost" => "50.0",
          "employee_cost_frequency" => "Weekly",
          "start_on" => "2022-01-01",
          "end_on" => nil,
          "submitted_at" => "2022-11-01T15:42:47.000+00:00",
          "hra_kind" => nil,
          "health_plan_meets_mvs_and_affordable" => health_plan_meets_mvs_and_affordable
        }],
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
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "3080184",
            "monthly_premium" => "632.95"
          }, {
            "member_identifier" => "3080188",
            "monthly_premium" => "579.11"
          }, {
            "member_identifier" => "3080189",
            "monthly_premium" => "248.05"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "3080184",
            "monthly_premium" => "641.72"
          }, {
            "member_identifier" => "3080188",
            "monthly_premium" => "587.15"
          }, {
            "member_identifier" => "3080189",
            "monthly_premium" => "251.5"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 80_000, "taxable_interest" => 0, "tax_exempt_interest" => 0,
          "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0,
          "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0,
          "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0,
          "adjusted_gross_income" => 80_000, "deductible_part_of_self_employment_tax" => 0,
          "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 3_080_188,
          "attest_primary_responsibility" => "Y",
          "relationship_code" => "02"
        }, {
          "other_id" => 3_080_189,
          "attest_primary_responsibility" => "Y",
          "relationship_code" => "03"
        }],
        "mitc_state_resident" => true,
        "mitc_is_required_to_file_taxes" => true,
        "income_evidence" => {
          "key" => "income", "title" => "Income",
          "aasm_state" => "pending", "description" => nil, "received_at" => "2022-10-29T20:40:54.088+00:00",
          "is_satisfied" => true, "verification_outstanding" => false, "update_reason" => nil, "due_on" => nil,
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
        "esi_evidence" => {
          "key" => "esi_mec", "title" => "ESI MEC",
          "aasm_state" => "attested", "description" => nil, "received_at" => "2022-10-29T20:40:53.976+00:00",
          "is_satisfied" => true, "verification_outstanding" => false, "update_reason" => nil, "due_on" => nil,
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
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "635d9a2d454d9d000e3adaca",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "635da65fb9c88d000e7f72f6",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }]
        },
        "non_esi_evidence" => {
          "key" => "non_esi_mec", "title" => "Non ESI MEC",
          "aasm_state" => "attested", "description" => nil, "received_at" => "2022-10-29T20:40:54.028+00:00",
          "is_satisfied" => true, "verification_outstanding" => false, "update_reason" => nil, "due_on" => nil,
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
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "635d9a51454d9d000e3adace",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "635d9a51454d9d000e3adace",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "635d9a51454d9d000e3adace",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "635d9a51454d9d000e3adace",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "635da676b9c88d000e7f72fa",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "635da676b9c88d000e7f72fa",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "635da676b9c88d000e7f72fa",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "635da676b9c88d000e7f72fa",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }]
        },
        "local_mec_evidence" => {
          "key" => "local_mec", "title" => "Local MEC",
          "aasm_state" => "attested", "description" => nil, "received_at" => "2022-10-29T20:40:53.946+00:00",
          "is_satisfied" => true, "verification_outstanding" => false, "update_reason" => nil, "due_on" => nil,
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
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }]
        }
      }, {
        "name" => {
          "first_name" => "Spouse", "middle_name" => nil, "last_name" => "October", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "RMuS+QQObZOf3cigk8ZvkIUEvfoGL8dJnw==\n", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Female", "dob" => "1972-01-01", "ethnicity" => [], "race" => nil,
          "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false,
          "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false
        },
        "is_primary_applicant" => false,
        "native_american_information" => {
          "indian_tribe_member" => false, "tribal_name" => nil, "tribal_state" => nil
        },
        "citizenship_immigration_status_information" => {
          "citizen_status" => "us_citizen", "is_resident_post_092296" => nil, "is_lawful_presence_self_attested" => false
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
          "family_member_hbx_id" => "3080188", "first_name" => "Spouse", "last_name" => "October", "person_hbx_id" => "3080188",
          "is_primary_family_member" => false
        },
        "person_hbx_id" => "3080188",
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
          "is_former_foster_care" => false, "age_left_foster_care" => nil, "foster_care_us_state" => nil,
          "had_medicaid_during_foster_care" => false
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
          "not_eligible_in_last_90_days" => false, "denied_on" => nil,
          "ended_as_change_in_eligibility" => false, "hh_income_or_size_changed" => false,
          "medicaid_or_chip_coverage_end_date" => nil, "ineligible_due_to_immigration_in_last_5_years" => false,
          "immigration_status_changed_since_ineligibility" => false
        },
        "other_health_service" => {
          "has_received" => false, "is_eligible" => false
        },
        "addresses" => [{
          "kind" => "home",
          "address_1" => "111 h",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "augusta",
          "county" => "Kennebec",
          "state" => "ME",
          "zip" => "04330",
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
        "age_of_applicant" => 50,
        "is_self_attested_long_term_care" => false,
        "hours_worked_per_week" => 0,
        "is_temporarily_out_of_state" => false,
        "is_claimed_as_dependent_by_non_applicant" => false,
        "benchmark_premium" => {
          "health_only_lcsp_premiums" => [{
            "member_identifier" => "3080184",
            "monthly_premium" => "632.95"
          }, {
            "member_identifier" => "3080188",
            "monthly_premium" => "579.11"
          }, {
            "member_identifier" => "3080189",
            "monthly_premium" => "248.05"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "3080184",
            "monthly_premium" => "641.72"
          }, {
            "member_identifier" => "3080188",
            "monthly_premium" => "587.15"
          }, {
            "member_identifier" => "3080189",
            "monthly_premium" => "251.5"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 0, "taxable_interest" => 0, "tax_exempt_interest" => 0,
          "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0,
          "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0,
          "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0,
          "adjusted_gross_income" => 0, "deductible_part_of_self_employment_tax" => 0,
          "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 3_080_184,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "02"
        }, {
          "other_id" => 3_080_189,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "03"
        }],
        "mitc_state_resident" => true,
        "mitc_is_required_to_file_taxes" => true,
        "income_evidence" => {
          "key" => "income", "title" => "Income",
          "aasm_state" => "attested", "description" => nil, "received_at" => "2022-10-29T20:40:54.318+00:00",
          "is_satisfied" => true, "verification_outstanding" => false, "update_reason" => nil, "due_on" => nil,
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
        "esi_evidence" => {
          "key" => "esi_mec", "title" => "ESI MEC",
          "aasm_state" => "attested", "description" => nil, "received_at" => "2022-10-29T20:40:54.194+00:00",
          "is_satisfied" => true, "verification_outstanding" => false, "update_reason" => nil, "due_on" => nil,
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
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "635d9a2d454d9d000e3adaca",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "635da65fb9c88d000e7f72f6",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }]
        },
        "non_esi_evidence" => {
          "key" => "non_esi_mec", "title" => "Non ESI MEC",
          "aasm_state" => "attested", "description" => nil, "received_at" => "2022-10-29T20:40:54.248+00:00",
          "is_satisfied" => true, "verification_outstanding" => false, "update_reason" => nil, "due_on" => nil,
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
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "635d9a51454d9d000e3adace",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "635d9a51454d9d000e3adace",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "635d9a51454d9d000e3adace",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "635d9a51454d9d000e3adace",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "635da676b9c88d000e7f72fa",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "635da676b9c88d000e7f72fa",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "635da676b9c88d000e7f72fa",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "635da676b9c88d000e7f72fa",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }]
        },
        "local_mec_evidence" => {
          "key" => "local_mec", "title" => "Local MEC",
          "aasm_state" => "attested", "description" => nil, "received_at" => "2022-10-29T20:40:54.135+00:00",
          "is_satisfied" => true, "verification_outstanding" => false, "update_reason" => nil, "due_on" => nil,
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
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }]
        }
      }, {
        "name" => {
          "first_name" => "Child", "middle_name" => nil, "last_name" => "October", "name_sfx" => nil, "name_pfx" => nil
        },
        "identifying_information" => {
          "encrypted_ssn" => "qZoeeNdJDeG/ZdXthrjC/YMAv/0GLcJJnw==\n", "has_ssn" => false
        },
        "demographic" => {
          "gender" => "Male", "dob" => "2010-01-01", "ethnicity" => [], "race" => nil,
          "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false
        },
        "attestation" => {
          "is_incarcerated" => false, "is_self_attested_disabled" => false,
          "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false
        },
        "is_primary_applicant" => false,
        "native_american_information" => {
          "indian_tribe_member" => false, "tribal_name" => nil, "tribal_state" => nil
        },
        "citizenship_immigration_status_information" => {
          "citizen_status" => "us_citizen", "is_resident_post_092296" => nil, "is_lawful_presence_self_attested" => false
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
          "family_member_hbx_id" => "3080189", "first_name" => "Child", "last_name" => "October", "person_hbx_id" => "3080189",
          "is_primary_family_member" => false
        },
        "person_hbx_id" => "3080189",
        "is_required_to_file_taxes" => false,
        "is_filing_as_head_of_household" => false,
        "tax_filer_kind" => "dependent",
        "is_joint_tax_filing" => false,
        "is_claimed_as_tax_dependent" => true,
        "claimed_as_tax_dependent_by" => {
          "first_name" => "John", "last_name" => "October", "dob" => "1970-01-01", "person_hbx_id" => "3080184",
          "encrypted_ssn" => "bpjomPtFTXArQ2XYQ04VrIMAvvwLL8dLlA==\n"
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
          "not_eligible_in_last_90_days" => false, "denied_on" => nil,
          "ended_as_change_in_eligibility" => false, "hh_income_or_size_changed" => false,
          "medicaid_or_chip_coverage_end_date" => nil, "ineligible_due_to_immigration_in_last_5_years" => false,
          "immigration_status_changed_since_ineligibility" => false
        },
        "other_health_service" => {
          "has_received" => false, "is_eligible" => false
        },
        "addresses" => [{
          "kind" => "home",
          "address_1" => "111 h",
          "address_2" => nil,
          "address_3" => nil,
          "city" => "augusta",
          "county" => "Kennebec",
          "state" => "ME",
          "zip" => "04330",
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
            "member_identifier" => "3080184",
            "monthly_premium" => "632.95"
          }, {
            "member_identifier" => "3080188",
            "monthly_premium" => "579.11"
          }, {
            "member_identifier" => "3080189",
            "monthly_premium" => "248.05"
          }], "health_only_slcsp_premiums" => [{
            "member_identifier" => "3080184",
            "monthly_premium" => "641.72"
          }, {
            "member_identifier" => "3080188",
            "monthly_premium" => "587.15"
          }, {
            "member_identifier" => "3080189",
            "monthly_premium" => "251.5"
          }]
        },
        "is_homeless" => false,
        "mitc_income" => {
          "amount" => 0, "taxable_interest" => 0, "tax_exempt_interest" => 0,
          "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0,
          "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0,
          "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0,
          "adjusted_gross_income" => 0, "deductible_part_of_self_employment_tax" => 0,
          "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0
        },
        "mitc_relationships" => [{
          "other_id" => 3_080_184,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }, {
          "other_id" => 3_080_188,
          "attest_primary_responsibility" => "N",
          "relationship_code" => "04"
        }],
        "mitc_state_resident" => true,
        "mitc_is_required_to_file_taxes" => false,
        "income_evidence" => {
          "key" => "income", "title" => "Income",
          "aasm_state" => "attested", "description" => nil, "received_at" => "2022-10-29T20:40:54.492+00:00",
          "is_satisfied" => true, "verification_outstanding" => false, "update_reason" => nil, "due_on" => nil,
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
        "esi_evidence" => {
          "key" => "esi_mec", "title" => "ESI MEC",
          "aasm_state" => "attested", "description" => nil, "received_at" => "2022-10-29T20:40:54.392+00:00",
          "is_satisfied" => true, "verification_outstanding" => false, "update_reason" => nil, "due_on" => nil,
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
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "635d9a2d454d9d000e3adaca",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "62bb2f2baa99470001243fc1",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "attested",
            "source" => "FDSH",
            "source_transaction_id" => "635da65fb9c88d000e7f72f6",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }]
        },
        "non_esi_evidence" => {
          "key" => "non_esi_mec", "title" => "Non ESI MEC",
          "aasm_state" => "attested", "description" => nil, "received_at" => "2022-10-29T20:40:54.437+00:00",
          "is_satisfied" => true, "verification_outstanding" => false, "update_reason" => nil, "due_on" => nil,
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
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "635d9a51454d9d000e3adace",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "635d9a51454d9d000e3adace",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "635d9a51454d9d000e3adace",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "635d9a51454d9d000e3adace",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "62bb2f3baa99470001243fc5",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH MEDI",
            "source_transaction_id" => "635da676b9c88d000e7f72fa",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH TRIC",
            "source_transaction_id" => "635da676b9c88d000e7f72fa",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH PECO",
            "source_transaction_id" => "635da676b9c88d000e7f72fa",
            "code" => "HE000001",
            "code_description" => nil,
            'raw_payload' => nil
          }, {
            "result" => "eligible",
            "source" => "FDSH VHPC",
            "source_transaction_id" => "635da676b9c88d000e7f72fa",
            "code" => "HX005001",
            "code_description" => nil,
            'raw_payload' => nil
          }]
        },
        "local_mec_evidence" => {
          "key" => "local_mec", "title" => "Local MEC",
          "aasm_state" => "attested", "description" => nil, "received_at" => "2022-10-29T20:40:54.359+00:00",
          "is_satisfied" => true, "verification_outstanding" => false, "update_reason" => nil, "due_on" => nil,
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
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }, {
            "result" => "eligible",
            "source" => nil,
            "source_transaction_id" => nil,
            "code" => "4200",
            "code_description" => nil,
            "raw_payload" => nil
          }]
        }
      }], "tax_households" => [{
        "max_aptc" => "0.0",
        "hbx_id" => "155291",
        "is_insurance_assistance_eligible" => "UnDetermined",
        "tax_household_members" => [{
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false,
            "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false,
            "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil,
            "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "John", "last_name" => "October", "dob" => "1970-01-01", "person_hbx_id" => "3080184",
            "encrypted_ssn" => "bpjomPtFTXArQ2XYQ04VrIMAvvwLL8dLlA==\n"
          }
        }, {
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false,
            "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false,
            "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil,
            "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "Spouse", "last_name" => "October", "dob" => "1972-01-01", "person_hbx_id" => "3080188",
            "encrypted_ssn" => "RMuS+QQObZOf3cigk8ZvkIUEvfoGL8dJnw==\n"
          }
        }, {
          "product_eligibility_determination" => {
            "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false,
            "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false,
            "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil,
            "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil
          },
          "applicant_reference" => {
            "first_name" => "Child", "last_name" => "October", "dob" => "2010-01-01", "person_hbx_id" => "3080189",
            "encrypted_ssn" => "qZoeeNdJDeG/ZdXthrjC/YMAv/0GLcJJnw==\n"
          }
        }],
        "annual_tax_household_income" => "0.0",
        "effective_on" => nil,
        "determined_on" => nil,
        "yearly_expected_contribution" => "0.0"
      }], "relationships" => [{
        "kind" => "spouse",
        "applicant_reference" => {
          "first_name" => "Spouse", "last_name" => "October", "dob" => "1972-01-01", "person_hbx_id" => "3080188",
          "encrypted_ssn" => "RMuS+QQObZOf3cigk8ZvkIUEvfoGL8dJnw==\n"
        },
        "relative_reference" => {
          "first_name" => "John", "last_name" => "October", "dob" => "1970-01-01", "person_hbx_id" => "3080184",
          "encrypted_ssn" => "bpjomPtFTXArQ2XYQ04VrIMAvvwLL8dLlA==\n"
        }
      }, {
        "kind" => "spouse",
        "applicant_reference" => {
          "first_name" => "John", "last_name" => "October", "dob" => "1970-01-01", "person_hbx_id" => "3080184",
          "encrypted_ssn" => "bpjomPtFTXArQ2XYQ04VrIMAvvwLL8dLlA==\n"
        },
        "relative_reference" => {
          "first_name" => "Spouse", "last_name" => "October", "dob" => "1972-01-01", "person_hbx_id" => "3080188",
          "encrypted_ssn" => "RMuS+QQObZOf3cigk8ZvkIUEvfoGL8dJnw==\n"
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "Child", "last_name" => "October", "dob" => "2010-01-01", "person_hbx_id" => "3080189",
          "encrypted_ssn" => "qZoeeNdJDeG/ZdXthrjC/YMAv/0GLcJJnw==\n"
        },
        "relative_reference" => {
          "first_name" => "John", "last_name" => "October", "dob" => "1970-01-01", "person_hbx_id" => "3080184",
          "encrypted_ssn" => "bpjomPtFTXArQ2XYQ04VrIMAvvwLL8dLlA==\n"
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "John", "last_name" => "October", "dob" => "1970-01-01", "person_hbx_id" => "3080184",
          "encrypted_ssn" => "bpjomPtFTXArQ2XYQ04VrIMAvvwLL8dLlA==\n"
        },
        "relative_reference" => {
          "first_name" => "Child", "last_name" => "October", "dob" => "2010-01-01", "person_hbx_id" => "3080189",
          "encrypted_ssn" => "qZoeeNdJDeG/ZdXthrjC/YMAv/0GLcJJnw==\n"
        }
      }, {
        "kind" => "parent",
        "applicant_reference" => {
          "first_name" => "Spouse", "last_name" => "October", "dob" => "1972-01-01", "person_hbx_id" => "3080188",
          "encrypted_ssn" => "RMuS+QQObZOf3cigk8ZvkIUEvfoGL8dJnw==\n"
        },
        "relative_reference" => {
          "first_name" => "Child", "last_name" => "October", "dob" => "2010-01-01", "person_hbx_id" => "3080189",
          "encrypted_ssn" => "qZoeeNdJDeG/ZdXthrjC/YMAv/0GLcJJnw==\n"
        }
      }, {
        "kind" => "child",
        "applicant_reference" => {
          "first_name" => "Child", "last_name" => "October", "dob" => "2010-01-01", "person_hbx_id" => "3080189",
          "encrypted_ssn" => "qZoeeNdJDeG/ZdXthrjC/YMAv/0GLcJJnw==\n"
        },
        "relative_reference" => {
          "first_name" => "Spouse", "last_name" => "October", "dob" => "1972-01-01", "person_hbx_id" => "3080188",
          "encrypted_ssn" => "RMuS+QQObZOf3cigk8ZvkIUEvfoGL8dJnw==\n"
        }
      }], "us_state" => "ME", "hbx_id" => "3150481", "oe_start_on" => "2021-11-01", "notice_options" => {
        "send_eligibility_notices" => true, "send_open_enrollment_notices" => false, "paper_notification" => true
      }, "mitc_households" => [{
        "household_id" => "1",
        "people" => [{
          "person_id" => 3_080_184
        }, {
          "person_id" => 3_080_188
        }, {
          "person_id" => 3_080_189
        }]
      }], "mitc_tax_returns" => [{
        "filers" => [{
          "person_id" => 3_080_184
        }, {
          "person_id" => 3_080_188
        }],
        "dependents" => [{
          "person_id" => 3_080_189
        }]
      }], "submitted_at" => "2022-10-30T15:44:24.728+00:00"
    }
  end

  let(:application_entity) do
    app_params.deep_symbolize_keys!
    ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
  end

  let(:input_application) { application_entity.to_h }

  let(:mitc_string_response) do
    {
      "Determination Date" => "2022-10-30", "Applicants" => [{
        "Person ID" => 3_080_184,
        "Medicaid Household" => {
          "People" => [3_080_184, 3_080_188, 3_080_189], "MAGI" => 80_000, "MAGI as Percentage of FPL" => 347, "Size" => 3
        },
        "Medicaid Eligible" => "N",
        "CHIP Eligible" => "N",
        "Ineligibility Reason" => ["Applicant's MAGI above the threshold for category"],
        "Non-MAGI Referral" => "N",
        "CHIP Ineligibility Reason" => ["Applicant did not meet the requirements for any CHIP category"],
        "Category" => "Adult Group Category",
        "Category Threshold" => 31_781,
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
            "Person ID" => 3_080_189,
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
        "Person ID" => 3_080_188,
        "Medicaid Household" => {
          "People" => [3_080_184, 3_080_188, 3_080_189], "MAGI" => 80_000, "MAGI as Percentage of FPL" => 347, "Size" => 3
        },
        "Medicaid Eligible" => "N",
        "CHIP Eligible" => "N",
        "Ineligibility Reason" => ["Applicant's MAGI above the threshold for category"],
        "Non-MAGI Referral" => "N",
        "CHIP Ineligibility Reason" => ["Applicant did not meet the requirements for any CHIP category"],
        "Category" => "Adult Group Category",
        "Category Threshold" => 31_781,
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
            "Person ID" => 3_080_189,
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
        "Person ID" => 3_080_189,
        "Medicaid Household" => {
          "People" => [3_080_184, 3_080_188, 3_080_189], "MAGI" => 80_000, "MAGI as Percentage of FPL" => 347, "Size" => 3
        },
        "Medicaid Eligible" => "N",
        "CHIP Eligible" => "N",
        "Ineligibility Reason" => ["Applicant's MAGI above the threshold for category"],
        "Non-MAGI Referral" => "N",
        "CHIP Ineligibility Reason" => ["Applicant's MAGI above the threshold for category"],
        "Category" => "Child Category",
        "Category Threshold" => 37_308,
        "CHIP Category" => "CHIP Targeted Low Income Child",
        "CHIP Category Threshold" => 49_053,
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
            "Indicator" => "N", "Ineligibility Code" => 402,
            "Ineligibility Reason" => "Applicant's income is greater than the threshold for all eligible categories"
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

  let(:mitc_response) { mitc_string_response.deep_symbolize_keys }
end
