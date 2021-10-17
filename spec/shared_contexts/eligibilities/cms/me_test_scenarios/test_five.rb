# frozen_string_literal: true

# rubocop:disable Layout/LineLength
RSpec.shared_context 'cms ME me_test_scenarios test_five', :shared_context => :metadata do
  # 2021
  let(:assistance_year) { Date.today.year.next }

  # "2020-11-01"
  let(:oe_start_on) { Date.today.beginning_of_month }

  # "2021-08-01T00:00:00.000+00:00"
  let(:aptc_effective_date) { DateTime.now.beginning_of_month }

  let(:app_params) do
    { "family_reference" => { "hbx_id" => "10230" }, "assistance_year" => assistance_year, "aptc_effective_date" => aptc_effective_date, "years_to_renew" => nil, "renewal_consent_through_year" => 5, "is_ridp_verified" => true, "is_renewal_authorized" => true, "applicants" => [{ "name" => { "first_name" => "Alex", "middle_name" => nil, "last_name" => "Burns", "name_sfx" => nil, "name_pfx" => nil }, "identifying_information" => { "encrypted_ssn" => "QEVuQwEACu2UuIpD4I1L1X6IH0i8Ig==", "has_ssn" => false }, "demographic" => { "gender" => "Male", "dob" => "1993-01-01", "ethnicity" => ["", "", "", "", "", "", ""], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false }, "attestation" => { "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false }, "is_primary_applicant" => true, "native_american_information" => { "indian_tribe_member" => true, "tribal_id" => "435245235" }, "citizenship_immigration_status_information" => { "citizen_status" => "us_citizen", "is_resident_post_092296" => false, "is_lawful_presence_self_attested" => false }, "is_consumer_role" => true, "is_resident_role" => false, "is_applying_coverage" => true, "is_consent_applicant" => false, "vlp_document" => nil, "family_member_reference" => { "family_member_hbx_id" => "1002502", "first_name" => "Alex", "last_name" => "Burns", "person_hbx_id" => "1002502", "is_primary_family_member" => true }, "person_hbx_id" => "1002502", "is_required_to_file_taxes" => true, "tax_filer_kind" => "tax_filer", "is_joint_tax_filing" => true, "is_claimed_as_tax_dependent" => false, "claimed_as_tax_dependent_by" => nil, "student" => { "is_student" => false, "student_kind" => nil, "student_school_kind" => nil, "student_status_end_on" => nil }, "is_refugee" => false, "is_trafficking_victim" => false, "foster_care" => { "is_former_foster_care" => false, "age_left_foster_care" => nil, "foster_care_us_state" => nil, "had_medicaid_during_foster_care" => false }, "pregnancy_information" => { "is_pregnant" => false, "is_enrolled_on_medicaid" => false, "is_post_partum_period" => false, "expected_children_count" => nil, "pregnancy_due_on" => nil, "pregnancy_end_on" => nil }, "is_subject_to_five_year_bar" => false, "is_five_year_bar_met" => false, "is_forty_quarters" => false, "is_ssn_applied" => false, "non_ssn_apply_reason" => nil, "moved_on_or_after_welfare_reformed_law" => false, "is_currently_enrolled_in_health_plan" => false, "has_daily_living_help" => false, "need_help_paying_bills" => false, "has_job_income" => false, "has_self_employment_income" => true, "has_unemployment_income" => false, "has_other_income" => true, "has_deductions" => false, "has_enrolled_health_coverage" => false, "has_eligible_health_coverage" => false, "job_coverage_ended_in_past_3_months" => false, "job_coverage_end_date" => nil, "medicaid_and_chip" => { "not_eligible_in_last_90_days" => false, "denied_on" => nil, "ended_as_change_in_eligibility" => false, "hh_income_or_size_changed" => false, "medicaid_or_chip_coverage_end_date" => nil, "ineligible_due_to_immigration_in_last_5_years" => false, "immigration_status_changed_since_ineligibility" => false }, "other_health_service" => { "has_received" => false, "is_eligible" => false }, "addresses" => [{ "kind" => "home", "address_1" => "23rd avenue", "address_2" => nil, "address_3" => nil, "city" => "newport", "county" => "Androscoggin", "state" => "ME", "zip" => "04210", "country_name" => nil }], "emails" => [], "phones" => [], "incomes" => [{ "title" => nil, "kind" => "net_self_employment", "wage_type" => nil, "hours_per_week" => nil, "amount" => "2700.0", "amount_tax_exempt" => "0.0", "frequency_kind" => "Monthly", "start_on" => "2021-03-17", "end_on" => nil, "is_projected" => false, "employer" => nil, "has_property_usage_rights" => nil, "submitted_at" => "2021-07-11T14:28:52.000+00:00" }, { "title" => nil, "kind" => "american_indian_and_alaskan_native", "wage_type" => nil, "hours_per_week" => nil, "amount" => "500.0", "amount_tax_exempt" => "0.0", "frequency_kind" => "Monthly", "start_on" => "2021-01-01", "end_on" => nil, "is_projected" => false, "employer" => nil, "has_property_usage_rights" => nil, "submitted_at" => "2021-07-11T14:28:52.000+00:00" }], "benefits" => [], "deductions" => [], "is_medicare_eligible" => false, "has_insurance" => false, "has_state_health_benefit" => false, "had_prior_insurance" => false, "prior_insurance_end_date" => nil, "age_of_applicant" => 28, "is_self_attested_long_term_care" => false, "hours_worked_per_week" => 0, "is_temporarily_out_of_state" => false, "is_claimed_as_dependent_by_non_applicant" => false, "benchmark_premium" => { "health_only_lcsp_premiums" => [{ "member_identifier" => "1002502", "monthly_premium" => "310.5" }, { "member_identifier" => "1002503", "monthly_premium" => "310.5" }], "health_only_slcsp_premiums" => [{ "member_identifier" => "1002502", "monthly_premium" => "310.5" }, { "member_identifier" => "1002503", "monthly_premium" => "310.5" }] }, "is_homeless" => false, "mitc_income" => { "amount" => 32_400, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 6000, "magi_deductions" => 0, "adjusted_gross_income" => 31_742, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0 }, "mitc_relationships" => [{ "other_id" => 1_002_503, "attest_primary_responsibility" => "Y", "relationship_code" => "02" }], "mitc_is_required_to_file_taxes" => true }, { "name" => { "first_name" => "Lynn", "middle_name" => nil, "last_name" => "Jones", "name_sfx" => nil, "name_pfx" => nil }, "identifying_information" => { "encrypted_ssn" => "QEVuQwEABf8GYzbV2f1HlOzz2qQZgA==", "has_ssn" => false }, "demographic" => { "gender" => "Female", "dob" => "1999-01-01", "ethnicity" => [], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false }, "attestation" => { "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false }, "is_primary_applicant" => false, "native_american_information" => { "indian_tribe_member" => false, "tribal_id" => nil }, "citizenship_immigration_status_information" => { "citizen_status" => "us_citizen", "is_resident_post_092296" => false, "is_lawful_presence_self_attested" => false }, "is_consumer_role" => true, "is_resident_role" => false, "is_applying_coverage" => true, "is_consent_applicant" => false, "vlp_document" => nil, "family_member_reference" => { "family_member_hbx_id" => "1002503", "first_name" => "Lynn", "last_name" => "Jones", "person_hbx_id" => "1002503", "is_primary_family_member" => false }, "person_hbx_id" => "1002503", "is_required_to_file_taxes" => true, "tax_filer_kind" => "tax_filer", "is_joint_tax_filing" => true, "is_claimed_as_tax_dependent" => false, "claimed_as_tax_dependent_by" => nil, "student" => { "is_student" => false, "student_kind" => nil, "student_school_kind" => nil, "student_status_end_on" => nil }, "is_refugee" => false, "is_trafficking_victim" => false, "foster_care" => { "is_former_foster_care" => true, "age_left_foster_care" => 18, "foster_care_us_state" => "ME", "had_medicaid_during_foster_care" => true }, "pregnancy_information" => { "is_pregnant" => false, "is_enrolled_on_medicaid" => false, "is_post_partum_period" => false, "expected_children_count" => nil, "pregnancy_due_on" => nil, "pregnancy_end_on" => nil }, "is_subject_to_five_year_bar" => false, "is_five_year_bar_met" => false, "is_forty_quarters" => false, "is_ssn_applied" => false, "non_ssn_apply_reason" => nil, "moved_on_or_after_welfare_reformed_law" => false, "is_currently_enrolled_in_health_plan" => false, "has_daily_living_help" => false, "need_help_paying_bills" => false, "has_job_income" => false, "has_self_employment_income" => false, "has_unemployment_income" => false, "has_other_income" => false, "has_deductions" => false, "has_enrolled_health_coverage" => false, "has_eligible_health_coverage" => false, "job_coverage_ended_in_past_3_months" => false, "job_coverage_end_date" => nil, "medicaid_and_chip" => { "not_eligible_in_last_90_days" => false, "denied_on" => nil, "ended_as_change_in_eligibility" => false, "hh_income_or_size_changed" => false, "medicaid_or_chip_coverage_end_date" => nil, "ineligible_due_to_immigration_in_last_5_years" => false, "immigration_status_changed_since_ineligibility" => false }, "other_health_service" => { "has_received" => false, "is_eligible" => false }, "addresses" => [{ "kind" => "home", "address_1" => "23rd avenue", "address_2" => nil, "address_3" => nil, "city" => "newport", "county" => "Androscoggin", "state" => "ME", "zip" => "04210", "country_name" => nil }], "emails" => [], "phones" => [], "incomes" => [], "benefits" => [], "deductions" => [], "is_medicare_eligible" => false, "has_insurance" => false, "has_state_health_benefit" => false, "had_prior_insurance" => false, "prior_insurance_end_date" => nil, "age_of_applicant" => 22, "is_self_attested_long_term_care" => false, "hours_worked_per_week" => 0, "is_temporarily_out_of_state" => false, "is_claimed_as_dependent_by_non_applicant" => false, "benchmark_premium" => { "health_only_lcsp_premiums" => [{ "member_identifier" => "1002502", "monthly_premium" => "310.5" }, { "member_identifier" => "1002503", "monthly_premium" => "310.5" }], "health_only_slcsp_premiums" => [{ "member_identifier" => "1002502", "monthly_premium" => "310.5" }, { "member_identifier" => "1002503", "monthly_premium" => "310.5" }] }, "is_homeless" => false, "mitc_income" => { "amount" => 0, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 0, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0 }, "mitc_relationships" => [{ "other_id" => 1_002_502, "attest_primary_responsibility" => "N", "relationship_code" => "02" }], "mitc_is_required_to_file_taxes" => true }], "tax_households" => [{ "max_aptc" => "0.0", "hbx_id" => "10809", "is_insurance_assistance_eligible" => nil, "tax_household_members" => [{ "product_eligibility_determination" => { "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil }, "applicant_reference" => { "first_name" => "Alex", "last_name" => "Burns", "dob" => "1993-01-01", "person_hbx_id" => "1002502", "encrypted_ssn" => "QEVuQwEACu2UuIpD4I1L1X6IH0i8Ig==" } }, { "product_eligibility_determination" => { "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil }, "applicant_reference" => { "first_name" => "Lynn", "last_name" => "Jones", "dob" => "1999-01-01", "person_hbx_id" => "1002503", "encrypted_ssn" => "QEVuQwEABf8GYzbV2f1HlOzz2qQZgA==" } }], "annual_tax_household_income" => "0.0" }], "relationships" => [{ "kind" => "spouse", "applicant_reference" => { "first_name" => "Lynn", "last_name" => "Jones", "dob" => "1999-01-01", "person_hbx_id" => "1002503", "encrypted_ssn" => "QEVuQwEABf8GYzbV2f1HlOzz2qQZgA==" }, "relative_reference" => { "first_name" => "Alex", "last_name" => "Burns", "dob" => "1993-01-01", "person_hbx_id" => "1002502", "encrypted_ssn" => "QEVuQwEACu2UuIpD4I1L1X6IH0i8Ig==" } }, { "kind" => "spouse", "applicant_reference" => { "first_name" => "Alex", "last_name" => "Burns", "dob" => "1993-01-01", "person_hbx_id" => "1002502", "encrypted_ssn" => "QEVuQwEACu2UuIpD4I1L1X6IH0i8Ig==" }, "relative_reference" => { "first_name" => "Lynn", "last_name" => "Jones", "dob" => "1999-01-01", "person_hbx_id" => "1002503", "encrypted_ssn" => "QEVuQwEABf8GYzbV2f1HlOzz2qQZgA==" } }], "us_state" => "ME", notice_options: { send_eligibility_notices: true, send_open_enrollment_notices: false }, "hbx_id" => "270000266", "oe_start_on" => oe_start_on, "mitc_households" => [{ "household_id" => "1", "people" => [{ "person_id" => 1_002_502 }, { "person_id" => 1_002_503 }] }], "mitc_tax_returns" => [{ "filers" => [{ "person_id" => 1_002_502 }, { "person_id" => 1_002_503 }], "dependents" => [] }] }
  end

  let(:application_entity) do
    app_params.deep_symbolize_keys!
    ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
  end

  let(:input_application) do
    application_entity.to_h
  end

  let(:mitc_string_response) do
    { "Determination Date" => "2021-10-07", "Applicants" => [{ "Person ID" => 1_002_502, "Medicaid Household" => { "People" => [1_002_502, 1_002_503], "MAGI" => 38_400, "MAGI as Percentage of FPL" => 220, "Size" => 2 }, "Medicaid Eligible" => "N", "CHIP Eligible" => "N", "Ineligibility Reason" => ["Applicant's MAGI above the threshold for category"], "Non-MAGI Referral" => "N", "CHIP Ineligibility Reason" => ["Applicant did not meet the requirements for any CHIP category"], "Category" => "Adult Group Category", "Category Threshold" => 24_039, "CHIP Category" => "None", "CHIP Category Threshold" => 0, "Determinations" => { "Residency" => { "Indicator" => "Y" }, "Adult Group Category" => { "Indicator" => "Y" }, "Parent Caretaker Category" => { "Indicator" => "N", "Ineligibility Code" => 146, "Ineligibility Reason" => "No child met all criteria for parent caretaker category" }, "Pregnancy Category" => { "Indicator" => "N", "Ineligibility Code" => 124, "Ineligibility Reason" => "Applicant not pregnant or within postpartum period" }, "Child Category" => { "Indicator" => "N", "Ineligibility Code" => 394, "Ineligibility Reason" => "Applicant is over the age limit for the young adult threshold in the state" }, "Optional Targeted Low Income Child" => { "Indicator" => "X" }, "CHIP Targeted Low Income Child" => { "Indicator" => "N", "Ineligibility Code" => 127, "Ineligibility Reason" => "Applicant's age is not within the allowed age range" }, "Unborn Child" => { "Indicator" => "X" }, "Income Medicaid Eligible" => { "Indicator" => "N", "Ineligibility Code" => 402, "Ineligibility Reason" => "Applicant's income is greater than the threshold for all eligible categories" }, "Income CHIP Eligible" => { "Indicator" => "N", "Ineligibility Code" => 401, "Ineligibility Reason" => "Applicant did not meet the requirements for any eligibility category" }, "Medicaid CHIPRA 214" => { "Indicator" => "X" }, "CHIP CHIPRA 214" => { "Indicator" => "X" }, "Trafficking Victim" => { "Indicator" => "X" }, "Seven Year Limit" => { "Indicator" => "X" }, "Five Year Bar" => { "Indicator" => "X" }, "Title II Work Quarters Met" => { "Indicator" => "X" }, "Medicaid Citizen Or Immigrant" => { "Indicator" => "Y" }, "CHIP Citizen Or Immigrant" => { "Indicator" => "Y" }, "Former Foster Care Category" => { "Indicator" => "N", "Ineligibility Code" => 400, "Ineligibility Reason" => "Applicant was not formerly in foster care" }, "Work Quarters Override Income" => { "Indicator" => "N", "Ineligibility Code" => 340, "Ineligibility Reason" => "Income is greater than 100% FPL" }, "State Health Benefits CHIP" => { "Indicator" => "X" }, "CHIP Waiting Period Satisfied" => { "Indicator" => "X" }, "Dependent Child Covered" => { "Indicator" => "X" }, "Medicaid Non-MAGI Referral" => { "Indicator" => "N", "Ineligibility Code" => 108, "Ineligibility Reason" => "Applicant does not meet requirements for a non-MAGI referral" }, "Emergency Medicaid" => { "Indicator" => "N", "Ineligibility Code" => 109, "Ineligibility Reason" => "Applicant does not meet the eligibility criteria for emergency Medicaid" }, "Refugee Medical Assistance" => { "Indicator" => "X" }, "APTC Referral" => { "Indicator" => "Y" } }, "Other Outputs" => { "Qualified Children List" => [] } }, { "Person ID" => 1_002_503, "Medicaid Household" => { "People" => [1_002_502, 1_002_503], "MAGI" => 38_400, "MAGI as Percentage of FPL" => 220, "Size" => 2 }, "Medicaid Eligible" => "Y", "CHIP Eligible" => "N", "CHIP Ineligibility Reason" => ["Applicant did not meet the requirements for any CHIP category"], "Category" => "Adult Group Category", "Category Threshold" => 24_039, "CHIP Category" => "None", "CHIP Category Threshold" => 0, "Determinations" => { "Residency" => { "Indicator" => "Y" }, "Adult Group Category" => { "Indicator" => "Y" }, "Parent Caretaker Category" => { "Indicator" => "N", "Ineligibility Code" => 146, "Ineligibility Reason" => "No child met all criteria for parent caretaker category" }, "Pregnancy Category" => { "Indicator" => "N", "Ineligibility Code" => 124, "Ineligibility Reason" => "Applicant not pregnant or within postpartum period" }, "Child Category" => { "Indicator" => "N", "Ineligibility Code" => 394, "Ineligibility Reason" => "Applicant is over the age limit for the young adult threshold in the state" }, "Optional Targeted Low Income Child" => { "Indicator" => "X" }, "CHIP Targeted Low Income Child" => { "Indicator" => "N", "Ineligibility Code" => 127, "Ineligibility Reason" => "Applicant's age is not within the allowed age range" }, "Unborn Child" => { "Indicator" => "X" }, "Income Medicaid Eligible" => { "Indicator" => "N", "Ineligibility Code" => 402, "Ineligibility Reason" => "Applicant's income is greater than the threshold for all eligible categories" }, "Income CHIP Eligible" => { "Indicator" => "N", "Ineligibility Code" => 401, "Ineligibility Reason" => "Applicant did not meet the requirements for any eligibility category" }, "Medicaid CHIPRA 214" => { "Indicator" => "X" }, "CHIP CHIPRA 214" => { "Indicator" => "X" }, "Trafficking Victim" => { "Indicator" => "X" }, "Seven Year Limit" => { "Indicator" => "X" }, "Five Year Bar" => { "Indicator" => "X" }, "Title II Work Quarters Met" => { "Indicator" => "X" }, "Medicaid Citizen Or Immigrant" => { "Indicator" => "Y" }, "CHIP Citizen Or Immigrant" => { "Indicator" => "Y" }, "Former Foster Care Category" => { "Indicator" => "Y" }, "Work Quarters Override Income" => { "Indicator" => "N", "Ineligibility Code" => 340, "Ineligibility Reason" => "Income is greater than 100% FPL" }, "State Health Benefits CHIP" => { "Indicator" => "X" }, "CHIP Waiting Period Satisfied" => { "Indicator" => "X" }, "Dependent Child Covered" => { "Indicator" => "X" }, "Medicaid Non-MAGI Referral" => { "Indicator" => "N", "Ineligibility Code" => 108, "Ineligibility Reason" => "Applicant does not meet requirements for a non-MAGI referral" }, "Emergency Medicaid" => { "Indicator" => nil }, "Refugee Medical Assistance" => { "Indicator" => "X" }, "APTC Referral" => { "Indicator" => "N", "Ineligibility Code" => 406, "Ineligibility Reason" => "Applicant is eligible for Medicaid" } }, "Other Outputs" => { "Qualified Children List" => [] } }] }
  end

  let(:mitc_response) do
    mitc_string_response.deep_symbolize_keys
  end
end
# rubocop:enable Layout/LineLength
