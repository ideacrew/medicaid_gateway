# frozen_string_literal: true

# rubocop:disable Layout/LineLength
RSpec.shared_context 'cms ME me_test_scenarios test_three', :shared_context => :metadata do
  let(:app_params) do
    { "family_reference" => { "hbx_id" => "10236" }, "assistance_year" => 2021, "aptc_effective_date" => "2021-08-01T00:00:00.000+00:00", "years_to_renew" => nil, "renewal_consent_through_year" => 5, "is_ridp_verified" => true, "is_renewal_authorized" => true, "applicants" => [{ "name" => { "first_name" => "Francis", "middle_name" => nil, "last_name" => "F", "name_sfx" => nil, "name_pfx" => nil }, "identifying_information" => { "encrypted_ssn" => nil, "has_ssn" => false }, "demographic" => { "gender" => "Female", "dob" => "1984-01-01", "ethnicity" => ["", "", "", "", "", "", ""], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false }, "attestation" => { "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false }, "is_primary_applicant" => true, "native_american_information" => { "indian_tribe_member" => false, "tribal_id" => nil }, "citizenship_immigration_status_information" => { "citizen_status" => nil, "is_resident_post_092296" => false, "is_lawful_presence_self_attested" => false }, "is_consumer_role" => true, "is_resident_role" => false, "is_applying_coverage" => false, "is_consent_applicant" => false, "vlp_document" => nil, "family_member_reference" => { "family_member_hbx_id" => "1002512", "first_name" => "Francis", "last_name" => "F", "person_hbx_id" => "1002512", "is_primary_family_member" => true }, "person_hbx_id" => "1002512", "is_required_to_file_taxes" => true, "tax_filer_kind" => "tax_filer", "is_joint_tax_filing" => false, "is_claimed_as_tax_dependent" => false, "claimed_as_tax_dependent_by" => nil, "student" => { "is_student" => false, "student_kind" => nil, "student_school_kind" => nil, "student_status_end_on" => nil }, "is_refugee" => false, "is_trafficking_victim" => false, "foster_care" => { "is_former_foster_care" => false, "age_left_foster_care" => 0, "foster_care_us_state" => nil, "had_medicaid_during_foster_care" => false }, "pregnancy_information" => { "is_pregnant" => false, "is_enrolled_on_medicaid" => false, "is_post_partum_period" => false, "expected_children_count" => nil, "pregnancy_due_on" => nil, "pregnancy_end_on" => nil }, "is_subject_to_five_year_bar" => false, "is_five_year_bar_met" => false, "is_forty_quarters" => false, "is_ssn_applied" => false, "non_ssn_apply_reason" => nil, "moved_on_or_after_welfare_reformed_law" => false, "is_currently_enrolled_in_health_plan" => false, "has_daily_living_help" => false, "need_help_paying_bills" => false, "has_job_income" => true, "has_self_employment_income" => false, "has_unemployment_income" => false, "has_other_income" => true, "has_deductions" => false, "has_enrolled_health_coverage" => false, "has_eligible_health_coverage" => false, "job_coverage_ended_in_past_3_months" => false, "job_coverage_end_date" => nil, "medicaid_and_chip" => { "not_eligible_in_last_90_days" => false, "denied_on" => nil, "ended_as_change_in_eligibility" => false, "hh_income_or_size_changed" => false, "medicaid_or_chip_coverage_end_date" => nil, "ineligible_due_to_immigration_in_last_5_years" => false, "immigration_status_changed_since_ineligibility" => false }, "other_health_service" => { "has_received" => false, "is_eligible" => false }, "addresses" => [{ "kind" => "home", "address_1" => "23rd avenue", "address_2" => nil, "address_3" => nil, "city" => "newport", "county" => "Androscoggin", "state" => "ME", "zip" => "04210", "country_name" => nil }], "emails" => [], "phones" => [], "incomes" => [{ "title" => nil, "kind" => "wages_and_salaries", "wage_type" => nil, "hours_per_week" => nil, "amount" => "440.0", "amount_tax_exempt" => "0.0", "frequency_kind" => "Weekly", "start_on" => "2020-11-01", "end_on" => nil, "is_projected" => false, "employer" => { "employer_name" => "testing", "employer_id" => nil }, "has_property_usage_rights" => nil, "submitted_at" => "2021-07-09T20:15:18.000+00:00" }, { "title" => nil, "kind" => "interest", "wage_type" => nil, "hours_per_week" => nil, "amount" => "120.0", "amount_tax_exempt" => "0.0", "frequency_kind" => "Annually", "start_on" => "2021-01-01", "end_on" => "2021-12-31", "is_projected" => false, "employer" => nil, "has_property_usage_rights" => nil, "submitted_at" => "2021-07-09T20:15:18.000+00:00" }], "benefits" => [], "deductions" => [], "is_medicare_eligible" => false, "has_insurance" => false, "has_state_health_benefit" => false, "had_prior_insurance" => false, "prior_insurance_end_date" => nil, "age_of_applicant" => 37, "is_self_attested_long_term_care" => false, "hours_worked_per_week" => 0, "is_temporarily_out_of_state" => false, "is_claimed_as_dependent_by_non_applicant" => false, "benchmark_premium" => { "health_only_lcsp_premiums" => [{ "member_identifier" => "1002512", "monthly_premium" => "310.5" }, { "member_identifier" => "1002514", "monthly_premium" => "310.5" }, { "member_identifier" => "1002515", "monthly_premium" => "310.5" }], "health_only_slcsp_premiums" => [{ "member_identifier" => "1002512", "monthly_premium" => "310.5" }, { "member_identifier" => "1002514", "monthly_premium" => "310.5" }, { "member_identifier" => "1002515", "monthly_premium" => "310.5" }] }, "is_homeless" => false, "mitc_income" => { "amount" => 22_880, "taxable_interest" => 120, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 23_000, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0 }, "mitc_relationships" => [{ "other_id" => 1_002_514, "attest_primary_responsibility" => "Y", "relationship_code" => "03" }, { "other_id" => 1_002_515, "attest_primary_responsibility" => "Y", "relationship_code" => "02" }], "mitc_is_required_to_file_taxes" => true }, { "name" => { "first_name" => "Kid", "middle_name" => nil, "last_name" => "F", "name_sfx" => nil, "name_pfx" => nil }, "identifying_information" => { "encrypted_ssn" => "QEVuQwEAkNjP9lvqho6k9w5g4wzV0Q==", "has_ssn" => false }, "demographic" => { "gender" => "Female", "dob" => "2014-01-01", "ethnicity" => [], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false }, "attestation" => { "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false }, "is_primary_applicant" => false, "native_american_information" => { "indian_tribe_member" => false, "tribal_id" => nil }, "citizenship_immigration_status_information" => { "citizen_status" => "us_citizen", "is_resident_post_092296" => false, "is_lawful_presence_self_attested" => false }, "is_consumer_role" => true, "is_resident_role" => false, "is_applying_coverage" => true, "is_consent_applicant" => false, "vlp_document" => nil, "family_member_reference" => { "family_member_hbx_id" => "1002514", "first_name" => "Kid", "last_name" => "F", "person_hbx_id" => "1002514", "is_primary_family_member" => false }, "person_hbx_id" => "1002514", "is_required_to_file_taxes" => false, "tax_filer_kind" => "dependent", "is_joint_tax_filing" => false, "is_claimed_as_tax_dependent" => true, "claimed_as_tax_dependent_by" => { "first_name" => "Francis", "last_name" => "F", "dob" => "1984-01-01", "person_hbx_id" => "1002512", "encrypted_ssn" => nil }, "student" => { "is_student" => false, "student_kind" => nil, "student_school_kind" => nil, "student_status_end_on" => nil }, "is_refugee" => false, "is_trafficking_victim" => false, "foster_care" => { "is_former_foster_care" => false, "age_left_foster_care" => nil, "foster_care_us_state" => nil, "had_medicaid_during_foster_care" => false }, "pregnancy_information" => { "is_pregnant" => false, "is_enrolled_on_medicaid" => false, "is_post_partum_period" => false, "expected_children_count" => nil, "pregnancy_due_on" => nil, "pregnancy_end_on" => nil }, "is_subject_to_five_year_bar" => false, "is_five_year_bar_met" => false, "is_forty_quarters" => false, "is_ssn_applied" => false, "non_ssn_apply_reason" => nil, "moved_on_or_after_welfare_reformed_law" => false, "is_currently_enrolled_in_health_plan" => false, "has_daily_living_help" => false, "need_help_paying_bills" => false, "has_job_income" => false, "has_self_employment_income" => false, "has_unemployment_income" => false, "has_other_income" => false, "has_deductions" => false, "has_enrolled_health_coverage" => false, "has_eligible_health_coverage" => false, "job_coverage_ended_in_past_3_months" => false, "job_coverage_end_date" => nil, "medicaid_and_chip" => { "not_eligible_in_last_90_days" => true, "denied_on" => Date.today.to_s, "ended_as_change_in_eligibility" => false, "hh_income_or_size_changed" => false, "medicaid_or_chip_coverage_end_date" => nil, "ineligible_due_to_immigration_in_last_5_years" => false, "immigration_status_changed_since_ineligibility" => false }, "other_health_service" => { "has_received" => false, "is_eligible" => false }, "addresses" => [{ "kind" => "home", "address_1" => "6 hudson avenue", "address_2" => nil, "address_3" => nil, "city" => "newport", "county" => nil, "state" => "ME", "zip" => "04225", "country_name" => nil }], "emails" => [], "phones" => [], "incomes" => [], "benefits" => [], "deductions" => [], "is_medicare_eligible" => false, "has_insurance" => false, "has_state_health_benefit" => false, "had_prior_insurance" => false, "prior_insurance_end_date" => nil, "age_of_applicant" => 7, "is_self_attested_long_term_care" => false, "hours_worked_per_week" => 0, "is_temporarily_out_of_state" => false, "is_claimed_as_dependent_by_non_applicant" => false, "benchmark_premium" => { "health_only_lcsp_premiums" => [{ "member_identifier" => "1002512", "monthly_premium" => "310.5" }, { "member_identifier" => "1002514", "monthly_premium" => "310.5" }, { "member_identifier" => "1002515", "monthly_premium" => "310.5" }], "health_only_slcsp_premiums" => [{ "member_identifier" => "1002512", "monthly_premium" => "310.5" }, { "member_identifier" => "1002514", "monthly_premium" => "310.5" }, { "member_identifier" => "1002515", "monthly_premium" => "310.5" }] }, "is_homeless" => false, "mitc_income" => { "amount" => 0, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 0, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0 }, "mitc_relationships" => [{ "other_id" => 1_002_512, "attest_primary_responsibility" => "N", "relationship_code" => "04" }, { "other_id" => 1_002_515, "attest_primary_responsibility" => "N", "relationship_code" => "04" }], "mitc_is_required_to_file_taxes" => false }, { "name" => { "first_name" => "Frank", "middle_name" => nil, "last_name" => "F", "name_sfx" => nil, "name_pfx" => nil }, "identifying_information" => { "encrypted_ssn" => nil, "has_ssn" => false }, "demographic" => { "gender" => "Male", "dob" => "1986-01-01", "ethnicity" => [], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false }, "attestation" => { "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false }, "is_primary_applicant" => false, "native_american_information" => { "indian_tribe_member" => false, "tribal_id" => nil }, "citizenship_immigration_status_information" => { "citizen_status" => nil, "is_resident_post_092296" => false, "is_lawful_presence_self_attested" => false }, "is_consumer_role" => true, "is_resident_role" => false, "is_applying_coverage" => false, "is_consent_applicant" => false, "vlp_document" => nil, "family_member_reference" => { "family_member_hbx_id" => "1002515", "first_name" => "Frank", "last_name" => "F", "person_hbx_id" => "1002515", "is_primary_family_member" => false }, "person_hbx_id" => "1002515", "is_required_to_file_taxes" => false, "tax_filer_kind" => "non_filer", "is_joint_tax_filing" => false, "is_claimed_as_tax_dependent" => false, "claimed_as_tax_dependent_by" => nil, "student" => { "is_student" => false, "student_kind" => nil, "student_school_kind" => nil, "student_status_end_on" => nil }, "is_refugee" => false, "is_trafficking_victim" => false, "foster_care" => { "is_former_foster_care" => false, "age_left_foster_care" => 0, "foster_care_us_state" => nil, "had_medicaid_during_foster_care" => false }, "pregnancy_information" => { "is_pregnant" => false, "is_enrolled_on_medicaid" => false, "is_post_partum_period" => false, "expected_children_count" => nil, "pregnancy_due_on" => nil, "pregnancy_end_on" => nil }, "is_subject_to_five_year_bar" => false, "is_five_year_bar_met" => false, "is_forty_quarters" => false, "is_ssn_applied" => false, "non_ssn_apply_reason" => nil, "moved_on_or_after_welfare_reformed_law" => false, "is_currently_enrolled_in_health_plan" => false, "has_daily_living_help" => false, "need_help_paying_bills" => false, "has_job_income" => false, "has_self_employment_income" => false, "has_unemployment_income" => false, "has_other_income" => false, "has_deductions" => false, "has_enrolled_health_coverage" => false, "has_eligible_health_coverage" => false, "job_coverage_ended_in_past_3_months" => false, "job_coverage_end_date" => nil, "medicaid_and_chip" => { "not_eligible_in_last_90_days" => false, "denied_on" => nil, "ended_as_change_in_eligibility" => false, "hh_income_or_size_changed" => false, "medicaid_or_chip_coverage_end_date" => nil, "ineligible_due_to_immigration_in_last_5_years" => false, "immigration_status_changed_since_ineligibility" => false }, "other_health_service" => { "has_received" => false, "is_eligible" => false }, "addresses" => [{ "kind" => "home", "address_1" => "6 hudson avenue", "address_2" => nil, "address_3" => nil, "city" => "newport", "county" => nil, "state" => "ME", "zip" => "04225", "country_name" => nil }], "emails" => [], "phones" => [], "incomes" => [], "benefits" => [], "deductions" => [], "is_medicare_eligible" => false, "has_insurance" => false, "has_state_health_benefit" => false, "had_prior_insurance" => false, "prior_insurance_end_date" => nil, "age_of_applicant" => 35, "is_self_attested_long_term_care" => false, "hours_worked_per_week" => 0, "is_temporarily_out_of_state" => false, "is_claimed_as_dependent_by_non_applicant" => false, "benchmark_premium" => { "health_only_lcsp_premiums" => [{ "member_identifier" => "1002512", "monthly_premium" => "310.5" }, { "member_identifier" => "1002514", "monthly_premium" => "310.5" }, { "member_identifier" => "1002515", "monthly_premium" => "310.5" }], "health_only_slcsp_premiums" => [{ "member_identifier" => "1002512", "monthly_premium" => "310.5" }, { "member_identifier" => "1002514", "monthly_premium" => "310.5" }, { "member_identifier" => "1002515", "monthly_premium" => "310.5" }] }, "is_homeless" => false, "mitc_income" => { "amount" => 0, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 0, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0 }, "mitc_relationships" => [{ "other_id" => 1_002_512, "attest_primary_responsibility" => "N", "relationship_code" => "02" }, { "other_id" => 1_002_514, "attest_primary_responsibility" => "N", "relationship_code" => "03" }], "mitc_is_required_to_file_taxes" => false }], "tax_households" => [{ "max_aptc" => "0.0", "hbx_id" => "10725", "is_insurance_assistance_eligible" => nil, "tax_household_members" => [{ "product_eligibility_determination" => { "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil }, "applicant_reference" => { "first_name" => "Francis", "last_name" => "F", "dob" => "1984-01-01", "person_hbx_id" => "1002512", "encrypted_ssn" => nil } }, { "product_eligibility_determination" => { "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil }, "applicant_reference" => { "first_name" => "Kid", "last_name" => "F", "dob" => "2014-01-01", "person_hbx_id" => "1002514", "encrypted_ssn" => "QEVuQwEAkNjP9lvqho6k9w5g4wzV0Q==" } }], "annual_tax_household_income" => "0.0" }, { "max_aptc" => "0.0", "hbx_id" => "10726", "is_insurance_assistance_eligible" => nil, "tax_household_members" => [{ "product_eligibility_determination" => { "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil }, "applicant_reference" => { "first_name" => "Frank", "last_name" => "F", "dob" => "1986-01-01", "person_hbx_id" => "1002515", "encrypted_ssn" => nil } }], "annual_tax_household_income" => "0.0" }], "relationships" => [{ "kind" => "child", "applicant_reference" => { "first_name" => "Kid", "last_name" => "F", "dob" => "2014-01-01", "person_hbx_id" => "1002514", "encrypted_ssn" => "QEVuQwEAkNjP9lvqho6k9w5g4wzV0Q==" }, "relative_reference" => { "first_name" => "Francis", "last_name" => "F", "dob" => "1984-01-01", "person_hbx_id" => "1002512", "encrypted_ssn" => nil } }, { "kind" => "parent", "applicant_reference" => { "first_name" => "Francis", "last_name" => "F", "dob" => "1984-01-01", "person_hbx_id" => "1002512", "encrypted_ssn" => nil }, "relative_reference" => { "first_name" => "Kid", "last_name" => "F", "dob" => "2014-01-01", "person_hbx_id" => "1002514", "encrypted_ssn" => "QEVuQwEAkNjP9lvqho6k9w5g4wzV0Q==" } }, { "kind" => "spouse", "applicant_reference" => { "first_name" => "Frank", "last_name" => "F", "dob" => "1986-01-01", "person_hbx_id" => "1002515", "encrypted_ssn" => nil }, "relative_reference" => { "first_name" => "Francis", "last_name" => "F", "dob" => "1984-01-01", "person_hbx_id" => "1002512", "encrypted_ssn" => nil } }, { "kind" => "spouse", "applicant_reference" => { "first_name" => "Francis", "last_name" => "F", "dob" => "1984-01-01", "person_hbx_id" => "1002512", "encrypted_ssn" => nil }, "relative_reference" => { "first_name" => "Frank", "last_name" => "F", "dob" => "1986-01-01", "person_hbx_id" => "1002515", "encrypted_ssn" => nil } }, { "kind" => "child", "applicant_reference" => { "first_name" => "Kid", "last_name" => "F", "dob" => "2014-01-01", "person_hbx_id" => "1002514", "encrypted_ssn" => "QEVuQwEAkNjP9lvqho6k9w5g4wzV0Q==" }, "relative_reference" => { "first_name" => "Frank", "last_name" => "F", "dob" => "1986-01-01", "person_hbx_id" => "1002515", "encrypted_ssn" => nil } }, { "kind" => "parent", "applicant_reference" => { "first_name" => "Frank", "last_name" => "F", "dob" => "1986-01-01", "person_hbx_id" => "1002515", "encrypted_ssn" => nil }, "relative_reference" => { "first_name" => "Kid", "last_name" => "F", "dob" => "2014-01-01", "person_hbx_id" => "1002514", "encrypted_ssn" => "QEVuQwEAkNjP9lvqho6k9w5g4wzV0Q==" } }], "us_state" => "ME", notice_options: { send_eligibility_notices: true, send_open_enrollment_notices: false }, "hbx_id" => "270000193", "oe_start_on" => "2020-11-01", "mitc_households" => [{ "household_id" => "1", "people" => [{ "person_id" => 1_002_512 }] }, { "household_id" => "2", "people" => [{ "person_id" => 1_002_514 }, { "person_id" => 1_002_515 }] }], "mitc_tax_returns" => [{ "filers" => [{ "person_id" => 1_002_512 }], "dependents" => [{ "person_id" => 1_002_514 }] }, { "filers" => [{ "person_id" => 1_002_515 }], "dependents" => [] }] }
  end

  let(:application_entity) do
    app_params.deep_symbolize_keys!
    ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
  end

  let(:input_application) do
    application_entity.to_h
  end

  let(:mitc_string_response) do
    { "Determination Date" => "2021-07-09", "Applicants" => [{ "Person ID" => 1_002_514, "Medicaid Household" => { "People" => [1_002_515, 1_002_514], "MAGI" => 0, "MAGI as Percentage of FPL" => 0, "Size" => 2 }, "Medicaid Eligible" => "Y", "CHIP Eligible" => "Y", "Category" => "Child Category", "Category Threshold" => 28_220, "CHIP Category" => "CHIP Targeted Low Income Child", "CHIP Category Threshold" => 37_104, "Determinations" => { "Residency" => { "Indicator" => "Y" }, "Adult Group Category" => { "Indicator" => "N", "Ineligibility Code" => 123, "Ineligibility Reason" => "Applicant is not between the ages of 19 and 64 (inclusive)" }, "Parent Caretaker Category" => { "Indicator" => "N", "Ineligibility Code" => 146, "Ineligibility Reason" => "No child met all criteria for parent caretaker category" }, "Pregnancy Category" => { "Indicator" => "N", "Ineligibility Code" => 124, "Ineligibility Reason" => "Applicant not pregnant or within postpartum period" }, "Child Category" => { "Indicator" => "Y" }, "Optional Targeted Low Income Child" => { "Indicator" => "X" }, "CHIP Targeted Low Income Child" => { "Indicator" => "Y" }, "Unborn Child" => { "Indicator" => "X" }, "Income Medicaid Eligible" => { "Indicator" => "Y" }, "Income CHIP Eligible" => { "Indicator" => "Y" }, "Medicaid CHIPRA 214" => { "Indicator" => "X" }, "CHIP CHIPRA 214" => { "Indicator" => "X" }, "Trafficking Victim" => { "Indicator" => "X" }, "Seven Year Limit" => { "Indicator" => "X" }, "Five Year Bar" => { "Indicator" => "X" }, "Title II Work Quarters Met" => { "Indicator" => "X" }, "Medicaid Citizen Or Immigrant" => { "Indicator" => "Y" }, "CHIP Citizen Or Immigrant" => { "Indicator" => "Y" }, "Former Foster Care Category" => { "Indicator" => "N", "Ineligibility Code" => 400, "Ineligibility Reason" => "Applicant was not formerly in foster care" }, "Work Quarters Override Income" => { "Indicator" => "N", "Ineligibility Code" => 338, "Ineligibility Reason" => "Applicant did not meet all the criteria for income override rule" }, "State Health Benefits CHIP" => { "Indicator" => "X" }, "CHIP Waiting Period Satisfied" => { "Indicator" => "X" }, "Dependent Child Covered" => { "Indicator" => "X" }, "Medicaid Non-MAGI Referral" => { "Indicator" => "N", "Ineligibility Code" => 108, "Ineligibility Reason" => "Applicant does not meet requirements for a non-MAGI referral" }, "Emergency Medicaid" => { "Indicator" => "N", "Ineligibility Code" => 109, "Ineligibility Reason" => "Applicant does not meet the eligibility criteria for emergency Medicaid" }, "Refugee Medical Assistance" => { "Indicator" => "X" }, "APTC Referral" => { "Indicator" => "N", "Ineligibility Code" => 406, "Ineligibility Reason" => "Applicant is eligible for Medicaid" } }, "Other Outputs" => { "Qualified Children List" => [] } }] }
  end

  let(:mitc_response) do
    mitc_string_response.deep_symbolize_keys
  end
end
# rubocop:enable Layout/LineLength
