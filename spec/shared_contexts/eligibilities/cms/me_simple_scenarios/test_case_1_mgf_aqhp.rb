# frozen_string_literal: true

# USState: 'ME'
# SBMaya should be eligible for MagiMedicaid because of Medicaid Gap Filling,
# but just because SBMaya attested that her medicaid_or_chip_termination in the last 90 days,
# she is eligible for aqhp.
# rubocop:disable Layout/LineLength
RSpec.shared_context 'cms ME simple_scenarios test_case_1_mgf_aqhp', :shared_context => :metadata do

  let(:medicaid_or_chip_termination_date) { 70.days.ago.to_s }
  let(:determination_date) { 60.days.ago.to_s }

  let(:app_params) do
    { "family_reference" => { "hbx_id" => "10315" }, "assistance_year" => 70.days.ago.year.to_s, "aptc_effective_date" => 30.days.ago.to_s, "years_to_renew" => nil, "renewal_consent_through_year" => 5, "is_ridp_verified" => true, "is_renewal_authorized" => true, "applicants" => [{ "name" => { "first_name" => "SBMaya", "middle_name" => nil, "last_name" => "SBMartins", "name_sfx" => nil, "name_pfx" => nil }, "identifying_information" => { "encrypted_ssn" => "QEVuQwEAOPMMBV5qheqkyuGWtIsabA==", "has_ssn" => false }, "demographic" => { "gender" => "Female", "dob" => "1990-01-04", "ethnicity" => ["", "", "", "", "", "", ""], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false }, "attestation" => { "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false }, "is_primary_applicant" => true, "native_american_information" => { "indian_tribe_member" => false, "tribal_id" => nil }, "citizenship_immigration_status_information" => { "citizen_status" => "us_citizen", "is_resident_post_092296" => false, "is_lawful_presence_self_attested" => false }, "is_consumer_role" => true, "is_resident_role" => false, "is_applying_coverage" => true, "is_consent_applicant" => false, "vlp_document" => nil, "family_member_reference" => { "family_member_hbx_id" => "1002733", "first_name" => "SBMaya", "last_name" => "SBMartins", "person_hbx_id" => "1002733", "is_primary_family_member" => true }, "person_hbx_id" => "1002733", "is_required_to_file_taxes" => true, "mitc_is_required_to_file_taxes" => true, "tax_filer_kind" => "tax_filer", "is_joint_tax_filing" => false, "is_claimed_as_tax_dependent" => false, "claimed_as_tax_dependent_by" => nil, "student" => { "is_student" => false, "student_kind" => nil, "student_school_kind" => nil, "student_status_end_on" => nil }, "is_refugee" => false, "is_trafficking_victim" => false, "foster_care" => { "is_former_foster_care" => false, "age_left_foster_care" => nil, "foster_care_us_state" => nil, "had_medicaid_during_foster_care" => false }, "pregnancy_information" => { "is_pregnant" => false, "is_enrolled_on_medicaid" => false, "is_post_partum_period" => false, "expected_children_count" => nil, "pregnancy_due_on" => nil, "pregnancy_end_on" => nil }, "is_subject_to_five_year_bar" => false, "is_five_year_bar_met" => false, "is_forty_quarters" => false, "is_ssn_applied" => false, "non_ssn_apply_reason" => nil, "moved_on_or_after_welfare_reformed_law" => false, "is_currently_enrolled_in_health_plan" => false, "has_daily_living_help" => false, "need_help_paying_bills" => false, "has_job_income" => true, "has_self_employment_income" => false, "has_unemployment_income" => false, "has_other_income" => false, "has_deductions" => false, "has_enrolled_health_coverage" => false, "has_eligible_health_coverage" => false, "job_coverage_ended_in_past_3_months" => false, "job_coverage_end_date" => nil, "medicaid_and_chip" => { "not_eligible_in_last_90_days" => false, "denied_on" => nil, "ended_as_change_in_eligibility" => true, "hh_income_or_size_changed" => false, "medicaid_or_chip_coverage_end_date" => medicaid_or_chip_termination_date, "ineligible_due_to_immigration_in_last_5_years" => false, "immigration_status_changed_since_ineligibility" => false }, "other_health_service" => { "has_received" => false, "is_eligible" => false }, "addresses" => [{ "kind" => "home", "address_1" => "1220 T St", "address_2" => nil, "address_3" => nil, "city" => "Augusta", "county" => "Kennebec", "state" => "ME", "zip" => "04330", "country_name" => nil }], "emails" => [], "phones" => [], "incomes" => [{ "title" => nil, "kind" => "wages_and_salaries", "wage_type" => nil, "hours_per_week" => nil, "amount" => "15000.0", "amount_tax_exempt" => "0.0", "frequency_kind" => "Annually", "start_on" => "2021-01-01", "end_on" => nil, "is_projected" => false, "employer" => { "employer_name" => "Joe's Coffee", "employer_id" => nil }, "has_property_usage_rights" => nil, "submitted_at" => "2021-06-29T16:23:05.000+00:00" }], "benefits" => [], "deductions" => [], "is_medicare_eligible" => false, "has_insurance" => false, "has_state_health_benefit" => false, "had_prior_insurance" => false, "prior_insurance_end_date" => nil, "age_of_applicant" => 31, "is_self_attested_long_term_care" => false, "hours_worked_per_week" => 0, "is_temporarily_out_of_state" => false, "is_claimed_as_dependent_by_non_applicant" => false, "benchmark_premium" => { "health_only_lcsp_premiums" => [{ "member_identifier" => "1002733", "monthly_premium" => "310.5" }, { "member_identifier" => "1002734", "monthly_premium" => "310.5" }], "health_only_slcsp_premiums" => [{ "member_identifier" => "1002733", "monthly_premium" => "310.5" }, { "member_identifier" => "1002734", "monthly_premium" => "310.5" }] }, "is_homeless" => false, "mitc_income" => { "amount" => 15_000, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 15_000, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0 }, "mitc_relationships" => [{ "other_id" => 1_002_734, "attest_primary_responsibility" => "Y", "relationship_code" => "03" }] }, { "name" => { "first_name" => "SBZoey", "middle_name" => nil, "last_name" => "SBMartins", "name_sfx" => nil, "name_pfx" => nil }, "identifying_information" => { "encrypted_ssn" => "QEVuQwEAW2ZTnA4n6CODR/EY59Q0OQ==", "has_ssn" => false }, "demographic" => { "gender" => "Female", "dob" => "2010-01-04", "ethnicity" => [], "race" => nil, "is_veteran_or_active_military" => false, "is_vets_spouse_or_child" => false }, "attestation" => { "is_incarcerated" => false, "is_self_attested_disabled" => false, "is_self_attested_blind" => false, "is_self_attested_long_term_care" => false }, "is_primary_applicant" => false, "native_american_information" => { "indian_tribe_member" => false, "tribal_id" => nil }, "citizenship_immigration_status_information" => { "citizen_status" => "not_lawfully_present_in_us", "is_resident_post_092296" => false, "is_lawful_presence_self_attested" => false }, "is_consumer_role" => true, "is_resident_role" => false, "is_applying_coverage" => false, "is_consent_applicant" => false, "vlp_document" => nil, "family_member_reference" => { "family_member_hbx_id" => "1002734", "first_name" => "SBZoey", "last_name" => "SBMartins", "person_hbx_id" => "1002734", "is_primary_family_member" => false }, "person_hbx_id" => "1002734", "is_required_to_file_taxes" => false, "mitc_is_required_to_file_taxes" => false, "tax_filer_kind" => "dependent", "is_joint_tax_filing" => false, "is_claimed_as_tax_dependent" => true, "claimed_as_tax_dependent_by" => { "first_name" => "SBMaya", "last_name" => "SBMartins", "dob" => "1990-01-04", "person_hbx_id" => "1002733", "encrypted_ssn" => "QEVuQwEAOPMMBV5qheqkyuGWtIsabA==" }, "student" => { "is_student" => false, "student_kind" => nil, "student_school_kind" => nil, "student_status_end_on" => nil }, "is_refugee" => false, "is_trafficking_victim" => false, "foster_care" => { "is_former_foster_care" => false, "age_left_foster_care" => 0, "foster_care_us_state" => nil, "had_medicaid_during_foster_care" => false }, "pregnancy_information" => { "is_pregnant" => false, "is_enrolled_on_medicaid" => false, "is_post_partum_period" => false, "expected_children_count" => nil, "pregnancy_due_on" => nil, "pregnancy_end_on" => nil }, "is_subject_to_five_year_bar" => false, "is_five_year_bar_met" => false, "is_forty_quarters" => false, "is_ssn_applied" => false, "non_ssn_apply_reason" => nil, "moved_on_or_after_welfare_reformed_law" => false, "is_currently_enrolled_in_health_plan" => false, "has_daily_living_help" => false, "need_help_paying_bills" => false, "has_job_income" => false, "has_self_employment_income" => false, "has_unemployment_income" => false, "has_other_income" => false, "has_deductions" => false, "has_enrolled_health_coverage" => false, "has_eligible_health_coverage" => false, "job_coverage_ended_in_past_3_months" => false, "job_coverage_end_date" => nil, "medicaid_and_chip" => { "not_eligible_in_last_90_days" => false, "denied_on" => nil, "ended_as_change_in_eligibility" => false, "hh_income_or_size_changed" => false, "medicaid_or_chip_coverage_end_date" => nil, "ineligible_due_to_immigration_in_last_5_years" => false, "immigration_status_changed_since_ineligibility" => false }, "other_health_service" => { "has_received" => false, "is_eligible" => false }, "addresses" => [{ "kind" => "home", "address_1" => "1220 T St", "address_2" => nil, "address_3" => nil, "city" => "Augusta", "county" => "Kennebec", "state" => "ME", "zip" => "04330", "country_name" => nil }], "emails" => [], "phones" => [], "incomes" => [], "benefits" => [], "deductions" => [], "is_medicare_eligible" => false, "has_insurance" => false, "has_state_health_benefit" => false, "had_prior_insurance" => false, "prior_insurance_end_date" => nil, "age_of_applicant" => 11, "is_self_attested_long_term_care" => false, "hours_worked_per_week" => 0, "is_temporarily_out_of_state" => false, "is_claimed_as_dependent_by_non_applicant" => false, "benchmark_premium" => { "health_only_lcsp_premiums" => [{ "member_identifier" => "1002733", "monthly_premium" => "310.5" }, { "member_identifier" => "1002734", "monthly_premium" => "310.5" }], "health_only_slcsp_premiums" => [{ "member_identifier" => "1002733", "monthly_premium" => "310.5" }, { "member_identifier" => "1002734", "monthly_premium" => "310.5" }] }, "is_homeless" => false, "mitc_income" => { "amount" => 0, "taxable_interest" => 0, "tax_exempt_interest" => 0, "taxable_refunds" => 0, "alimony" => 0, "capital_gain_or_loss" => 0, "pensions_and_annuities_taxable_amount" => 0, "farm_income_or_loss" => 0, "unemployment_compensation" => 0, "other_income" => 0, "magi_deductions" => 0, "adjusted_gross_income" => 0, "deductible_part_of_self_employment_tax" => 0, "ira_deduction" => 0, "student_loan_interest_deduction" => 0, "tution_and_fees" => 0, "other_magi_eligible_income" => 0 }, "mitc_relationships" => [{ "other_id" => 1_002_733, "attest_primary_responsibility" => "N", "relationship_code" => "04" }] }], "tax_households" => [{ "max_aptc" => "0.0", "hbx_id" => "10638", "is_insurance_assistance_eligible" => nil, "tax_household_members" => [{ "product_eligibility_determination" => { "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil }, "applicant_reference" => { "first_name" => "SBMaya", "last_name" => "SBMartins", "dob" => "1990-01-04", "person_hbx_id" => "1002733", "encrypted_ssn" => "QEVuQwEAOPMMBV5qheqkyuGWtIsabA==" } }, { "product_eligibility_determination" => { "is_ia_eligible" => false, "is_medicaid_chip_eligible" => false, "is_totally_ineligible" => false, "is_magi_medicaid" => false, "is_non_magi_medicaid_eligible" => false, "is_without_assistance" => false, "magi_medicaid_monthly_household_income" => "0.0", "medicaid_household_size" => nil, "magi_medicaid_monthly_income_limit" => "0.0", "magi_as_percentage_of_fpl" => "0.0", "magi_medicaid_category" => nil }, "applicant_reference" => { "first_name" => "SBZoey", "last_name" => "SBMartins", "dob" => "2010-01-04", "person_hbx_id" => "1002734", "encrypted_ssn" => "QEVuQwEAW2ZTnA4n6CODR/EY59Q0OQ==" } }], "annual_tax_household_income" => "0.0" }], "relationships" => [{ "kind" => "child", "applicant_reference" => { "first_name" => "SBZoey", "last_name" => "SBMartins", "dob" => "2010-01-04", "person_hbx_id" => "1002734", "encrypted_ssn" => "QEVuQwEAW2ZTnA4n6CODR/EY59Q0OQ==" }, "relative_reference" => { "first_name" => "SBMaya", "last_name" => "SBMartins", "dob" => "1990-01-04", "person_hbx_id" => "1002733", "encrypted_ssn" => "QEVuQwEAOPMMBV5qheqkyuGWtIsabA==" } }, { "kind" => "parent", "applicant_reference" => { "first_name" => "SBMaya", "last_name" => "SBMartins", "dob" => "1990-01-04", "person_hbx_id" => "1002733", "encrypted_ssn" => "QEVuQwEAOPMMBV5qheqkyuGWtIsabA==" }, "relative_reference" => { "first_name" => "SBZoey", "last_name" => "SBMartins", "dob" => "2010-01-04", "person_hbx_id" => "1002734", "encrypted_ssn" => "QEVuQwEAW2ZTnA4n6CODR/EY59Q0OQ==" } }], "us_state" => "ME", notice_options: { send_eligibility_notices: true, send_open_enrollment_notices: false }, "hbx_id" => "1000718", "oe_start_on" => "2020-11-01", "mitc_households" => [{ "household_id" => "1", "people" => [{ "person_id" => 1_002_733 }, { "person_id" => 1_002_734 }] }], "mitc_tax_returns" => [{ "filers" => [{ "person_id" => 1_002_733 }], "dependents" => [{ "person_id" => 1_002_734 }] }] }
  end

  let(:application_entity) do
    app_params.deep_symbolize_keys!
    ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
  end

  let(:input_application) do
    application_entity.to_h
  end

  let(:mitc_string_response) do
    { "Determination Date" => determination_date, "Applicants" => [{ "Person ID" => 1_002_733, "Medicaid Household" => { "People" => [1_002_733, 1_002_734], "MAGI" => 15_000, "MAGI as Percentage of FPL" => 86, "Size" => 2 }, "Medicaid Eligible" => "Y", "CHIP Eligible" => "N", "CHIP Ineligibility Reason" => ["Applicant did not meet the requirements for any CHIP category"], "Category" => "Parent Caretaker Category", "Category Threshold" => 18_291, "CHIP Category" => "None", "CHIP Category Threshold" => 0, "Determinations" => { "Residency" => { "Indicator" => "Y" }, "Adult Group Category" => { "Indicator" => "N", "Ineligibility Code" => 411, "Ineligibility Reason" => "Applicant's dependent child does not have minimal essential coverage" }, "Parent Caretaker Category" => { "Indicator" => "Y" }, "Pregnancy Category" => { "Indicator" => "N", "Ineligibility Code" => 124, "Ineligibility Reason" => "Applicant not pregnant or within postpartum period" }, "Child Category" => { "Indicator" => "N", "Ineligibility Code" => 394, "Ineligibility Reason" => "Applicant is over the age limit for the young adult threshold in the state" }, "Optional Targeted Low Income Child" => { "Indicator" => "X" }, "CHIP Targeted Low Income Child" => { "Indicator" => "N", "Ineligibility Code" => 127, "Ineligibility Reason" => "Applicant's age is not within the allowed age range" }, "Unborn Child" => { "Indicator" => "X" }, "Income Medicaid Eligible" => { "Indicator" => "Y" }, "Income CHIP Eligible" => { "Indicator" => "N", "Ineligibility Code" => 401, "Ineligibility Reason" => "Applicant did not meet the requirements for any eligibility category" }, "Medicaid CHIPRA 214" => { "Indicator" => "X" }, "CHIP CHIPRA 214" => { "Indicator" => "X" }, "Trafficking Victim" => { "Indicator" => "X" }, "Seven Year Limit" => { "Indicator" => "X" }, "Five Year Bar" => { "Indicator" => "X" }, "Title II Work Quarters Met" => { "Indicator" => "X" }, "Medicaid Citizen Or Immigrant" => { "Indicator" => "Y" }, "CHIP Citizen Or Immigrant" => { "Indicator" => "Y" }, "Former Foster Care Category" => { "Indicator" => "N", "Ineligibility Code" => 400, "Ineligibility Reason" => "Applicant was not formerly in foster care" }, "Work Quarters Override Income" => { "Indicator" => "N", "Ineligibility Code" => 338, "Ineligibility Reason" => "Applicant did not meet all the criteria for income override rule" }, "State Health Benefits CHIP" => { "Indicator" => "X" }, "CHIP Waiting Period Satisfied" => { "Indicator" => "X" }, "Dependent Child Covered" => { "Indicator" => "N", "Ineligibility Code" => 128, "Ineligibility Reason" => "Applicant's dependent child does not have minimal essential coverage" }, "Medicaid Non-MAGI Referral" => { "Indicator" => "N", "Ineligibility Code" => 108, "Ineligibility Reason" => "Applicant does not meet requirements for a non-MAGI referral" }, "Emergency Medicaid" => { "Indicator" => "N", "Ineligibility Code" => 109, "Ineligibility Reason" => "Applicant does not meet the eligibility criteria for emergency Medicaid" }, "Refugee Medical Assistance" => { "Indicator" => "X" }, "APTC Referral" => { "Indicator" => "N", "Ineligibility Code" => 406, "Ineligibility Reason" => "Applicant is eligible for Medicaid" } }, "Other Outputs" => { "Qualified Children List" => [{ "Person ID" => 1_002_734, "Determinations" => { "Dependent Age" => { "Indicator" => "Y" }, "Deprived Child" => { "Indicator" => "X" }, "Relationship" => { "Indicator" => "Y" } } }] } }] }
  end

  let(:mitc_response) do
    mitc_string_response.deep_symbolize_keys
  end
end
# rubocop:enable Layout/LineLength
