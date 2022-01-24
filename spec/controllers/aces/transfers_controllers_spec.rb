# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/ModuleLength
# Spec for TransfersController
module Aces
  RSpec.describe TransfersController, type: :controller, dbclean: :after_each do

    describe 'GET new' do
      let(:user) { FactoryBot.create(:user) }

      before :each do
        sign_in user
        get :new
      end

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end
    end

    describe 'POST create' do
      let(:user) { FactoryBot.create(:user) }
      let(:outbound_payload) do
        {
          "family" => {
            "hbx_id" => "10031",
            "family_members" => [
              {
                "hbx_id" => "1624289008997662",
                "is_primary_applicant" => true,
                "is_consent_applicant" => false,
                "is_coverage_applicant" => true,
                "is_active" => true,
                "person" => {
                  "hbx_id" => "1624289008997662",
                  "person_name" => {
                    "first_name" => "betty",
                    "middle_name" => nil,
                    "last_name" => "curtis",
                    "name_sfx" => nil,
                    "name_pfx" => nil,
                    "full_name" =>
                    "betty curtis",
                    "alternate_name" => nil
                  },
                  "person_demographics" => {
                    "encrypted_ssn" => "stgXNlY2ksCXbGsvz4tst4kEu/sFLMlIlA==\n",
                    "no_ssn" => false,
                    "gender" => "female",
                    "dob" => "1998-01-01",
                    "date_of_death" => nil,
                    "dob_check" => false,
                    "is_incarcerated" => false,
                    "ethnicity" => ["", "", "", "", "", "", ""],
                    "race" => nil,
                    "tribal_id" => nil,
                    "language_code" => "en"
                  },
                  "person_health" => {
                    "is_tobacco_user" => "unknown",
                    "is_physically_disabled" => nil
                  },
                  "no_dc_address" => false,
                  "no_dc_address_reason" => "",
                  "is_homeless" => false,
                  "is_temporarily_out_of_state" => false,
                  "age_off_excluded" => false,
                  "is_applying_for_assistance" => nil,
                  "is_active" => true,
                  "is_disabled" => nil,
                  "person_relationships" => [],
                  "consumer_role" => { "five_year_bar" => false,
                                       "requested_coverage_start_date" => "2021-06-21",
                                       "aasm_state" => "unverified",
                                       "is_applicant" => true,
                                       "birth_location" => nil,
                                       "marital_status" => nil,
                                       "is_active" => true,
                                       "is_applying_coverage" => true,
                                       "bookmark_url" => "http://localhost:3002/insured/families/manage_family",
                                       "admin_bookmark_url" => "/insured/families/manage_family",
                                       "contact_method" => "mail",
                                       "language_preference" => "English",
                                       "is_state_resident" => nil,
                                       "identity_validation" => "valid",
                                       "identity_update_reason" => "Verified from Experian",
                                       "application_validation" => "valid",
                                       "application_update_reason" => "Verified from Experian",
                                       "identity_rejected" => false,
                                       "application_rejected" => false,
                                       "documents" => [],
                                       "vlp_documents" => [],
                                       "ridp_documents" => [],
                                       "verification_type_history_elements" => [],
                                       "lawful_presence_determination" => { "vlp_verified_at" => nil,
                                                                            "vlp_authority" => nil,
                                                                            "vlp_document_id" => nil,
                                                                            "citizen_status" => "us_citizen",
                                                                            "citizenship_result" => nil,
                                                                            "qualified_non_citizenship_result" => nil,
                                                                            "aasm_state" => "verification_pending",
                                                                            "ssa_responses" => [],
                                                                            "ssa_requests" => [],
                                                                            "vlp_responses" => [],
                                                                            "vlp_requests" => [] },
                                       "local_residency_responses" => [],
                                       "local_residency_requests" => [] },
                  "resident_role" => nil,
                  "broker_role" => nil,
                  "individual_market_transitions" => [{ "role_type" => "consumer",
                                                        "start_on" => "2021-06-21",
                                                        "end_on" => nil,
                                                        "reason_code" => "generating_consumer_role",
                                                        "submitted_at" => "2021-06-21T15:23:29.000+00:00" }],
                  "verification_types" => [{ "type_name" => "DC Residency",
                                             "validation_status" => "unverified",
                                             "applied_roles" => ["consumer_role"],
                                             "update_reason" => nil,
                                             "rejected" => nil,
                                             "external_service" => nil,
                                             "due_date" => nil,
                                             "due_date_type" => nil,
                                             "inactive" => false,
                                             "vlp_documents" => [] }, { "type_name" => "Social Security Number",
                                                                        "validation_status" => "unverified",
                                                                        "applied_roles" => ["consumer_role"],
                                                                        "update_reason" => nil,
                                                                        "rejected" => nil,
                                                                        "external_service" => nil,
                                                                        "due_date" => nil,
                                                                        "due_date_type" => nil,
                                                                        "inactive" => nil,
                                                                        "vlp_documents" => [] }, { "type_name" => "Citizenship",
                                                                                                   "validation_status" => "unverified",
                                                                                                   "applied_roles" => ["consumer_role"],
                                                                                                   "update_reason" => nil,
                                                                                                   "rejected" => nil,
                                                                                                   "external_service" => nil,
                                                                                                   "due_date" => nil,
                                                                                                   "due_date_type" => nil,
                                                                                                   "inactive" => nil,
                                                                                                   "vlp_documents" => [] }],
                  "user" => {},
                  "addresses" => [{ "kind" => "home",
                                    "address_1" => "123",
                                    "address_2" => "",
                                    "address_3" => "",
                                    "city" => "was",
                                    "county" => "",
                                    "state" => "DC",
                                    "zip" => "98272",
                                    "country_name" => "United States of America",
                                    "has_fixed_address" => true }],
                  "emails" => [],
                  "phones" => [],
                  "documents" => [],
                  "timestamp" => { "created_at" => "2021-06-21T15:23:28.997+00:00",
                                   "modified_at" => "2021-10-18T13:27:05.313+00:00" }
                },
                "timestamp" => { "created_at" => "2021-06-21T15:23:29.682+00:00",
                                 "modified_at" => "2021-06-21T15:23:29.682+00:00" }
              }
            ],
            "households" => [{ "start_date" => "2021-06-21",
                               "end_date" => nil,
                               "is_active" => true,
                               "irs_groups" => [{ "hbx_id" => nil,
                                                  "start_on" => "2021-06-21",
                                                  "end_on" => nil,
                                                  "is_active" => true }],
                               "tax_households" => [],
                               "coverage_households" => [{ "is_immediate_family" => true,
                                                           "is_determination_split_household" => false,
                                                           "submitted_at" => nil,
                                                           "aasm_state" => "applicant" }, { "is_immediate_family" => false,
                                                                                            "is_determination_split_household" => false,
                                                                                            "submitted_at" => nil,
                                                                                            "aasm_state" => "applicant" }] }],
            "renewal_consent_through_year" => nil,
            "special_enrollment_periods" => [],
            "payment_transactions" => [],
            "magi_medicaid_applications" => { "family_reference" => { "hbx_id" => "10031" },
                                              "assistance_year" => 2021,
                                              "aptc_effective_date" => "2021-08-01T00:00:00.000+00:00",
                                              "years_to_renew" => nil,
                                              "renewal_consent_through_year" => 5,
                                              "is_ridp_verified" => true,
                                              "is_renewal_authorized" => true,
                                              "applicants" => [{ "name" => { "first_name" => "betty",
                                                                             "middle_name" => nil,
                                                                             "last_name" => "curtis",
                                                                             "name_sfx" => nil,
                                                                             "name_pfx" => nil },
                                                                 "identifying_information" => {
                                                                   "has_ssn" => "0",
                                                                   "encrypted_ssn" => "stgXNlY2ksCXbGsvz4tst4kEu/sFLMlIlA==\n"
                                                                 },
                                                                 "demographic" => { "gender" => "Female",
                                                                                    "dob" => "1998-01-01",
                                                                                    "ethnicity" => ["", "", "", "", "", "", ""],
                                                                                    "race" => nil,
                                                                                    "is_veteran_or_active_military" => false,
                                                                                    "is_vets_spouse_or_child" => false },
                                                                 "attestation" => { "is_incarcerated" => false,
                                                                                    "is_self_attested_disabled" => false,
                                                                                    "is_self_attested_blind" => false,
                                                                                    "is_self_attested_long_term_care" => false },
                                                                 "is_primary_applicant" => true,
                                                                 "native_american_information" => { "indian_tribe_member" => false,
                                                                                                    "tribal_name" => nil,
                                                                                                    "tribal_state" => nil },
                                                                 "citizenship_immigration_status_information" => {
                                                                   "citizen_status" => "us_citizen",
                                                                   "is_lawful_presence_self_attested" => false,
                                                                   "is_resident_post_092296" => false
                                                                 },
                                                                 "is_consumer_role" => true,
                                                                 "is_resident_role" => false,
                                                                 "is_applying_coverage" => true,
                                                                 "is_consent_applicant" => false,
                                                                 "vlp_document" => nil,
                                                                 "family_member_reference" => { "family_member_hbx_id" => "1624289008997662",
                                                                                                "first_name" => "betty",
                                                                                                "last_name" => "curtis",
                                                                                                "person_hbx_id" => "1624289008997662",
                                                                                                "is_primary_family_member" => true },
                                                                 "person_hbx_id" => "1624289008997662",
                                                                 "is_required_to_file_taxes" => true,
                                                                 "is_filing_as_head_of_household" => false,
                                                                 "is_joint_tax_filing" => false,
                                                                 "is_claimed_as_tax_dependent" => false,
                                                                 "claimed_as_tax_dependent_by" => nil,
                                                                 "tax_filer_kind" => "tax_filer",
                                                                 "student" => { "is_student" => false,
                                                                                "student_kind" => "",
                                                                                "student_school_kind" => "",
                                                                                "student_status_end_on" => nil },
                                                                 "is_refugee" => false,
                                                                 "is_trafficking_victim" => false,
                                                                 "foster_care" => { "is_former_foster_care" => false,
                                                                                    "age_left_foster_care" => nil,
                                                                                    "foster_care_us_state" => "",
                                                                                    "had_medicaid_during_foster_care" => false },
                                                                 "pregnancy_information" => { "is_pregnant" => false,
                                                                                              "is_enrolled_on_medicaid" => false,
                                                                                              "is_post_partum_period" => false,
                                                                                              "expected_children_count" => nil,
                                                                                              "pregnancy_due_on" => nil,
                                                                                              "pregnancy_end_on" => nil },
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
                                                                 "has_enrolled_health_coverage" => true,
                                                                 "has_eligible_health_coverage" => false,
                                                                 "job_coverage_ended_in_past_3_months" => false,
                                                                 "job_coverage_end_date" => nil,
                                                                 "medicaid_and_chip" => { "not_eligible_in_last_90_days" => false,
                                                                                          "denied_on" => nil,
                                                                                          "ended_as_change_in_eligibility" => false,
                                                                                          "hh_income_or_size_changed" => false,
                                                                                          "medicaid_or_chip_coverage_end_date" => nil,
                                                                                          "ineligible_due_to_immigration_in_last_5_years" => false,
                                                                                          "immigration_status_changed_since_ineligibility" => false },
                                                                 "other_health_service" => { "has_received" => false,
                                                                                             "is_eligible" => false },
                                                                 "addresses" => [{ "kind" => "home",
                                                                                   "address_1" => "123",
                                                                                   "address_2" => "",
                                                                                   "address_3" => "",
                                                                                   "city" => "was",
                                                                                   "county" => "",
                                                                                   "state" => "DC",
                                                                                   "zip" => "98272",
                                                                                   "country_name" => "" }],
                                                                 "emails" => [],
                                                                 "phones" => [],
                                                                 "incomes" => [],
                                                                 "benefits" => [{ "name" => nil,
                                                                                  "kind" => "employer_sponsored_insurance",
                                                                                  "status" => "is_enrolled",
                                                                                  "is_employer_sponsored" => false,
                                                                                  "employer" => { "employer_name" => "er1",
                                                                                                  "employer_id" => "12-2132133" },
                                                                                  "esi_covered" => "self",
                                                                                  "is_esi_waiting_period" => false,
                                                                                  "is_esi_mec_met" => true,
                                                                                  "employee_cost" => { "cents" => 50_000,
                                                                                                       "currency_iso" => "USD" },
                                                                                  "employee_cost_frequency" => "Monthly",
                                                                                  "start_on" => "2020-11-01",
                                                                                  "end_on" => nil,
                                                                                  "submitted_at" => "2021-06-21T19:03:57.000+00:00",
                                                                                  "hra_kind" => nil }],
                                                                 "deductions" => [],
                                                                 "is_medicare_eligible" => false,
                                                                 "is_self_attested_long_term_care" => false,
                                                                 "has_insurance" => true,
                                                                 "has_state_health_benefit" => false,
                                                                 "had_prior_insurance" => false,
                                                                 "prior_insurance_end_date" => nil,
                                                                 "age_of_applicant" => 23,
                                                                 "hours_worked_per_week" => 0,
                                                                 "is_temporarily_out_of_state" => false,
                                                                 "is_claimed_as_dependent_by_non_applicant" => false,
                                                                 "benchmark_premium" => {
                                                                   "health_only_lcsp_premiums" => [
                                                                     { "cost" => 236.5,
                                                                       "product_id" => "5f773f7ec09d073df2dd33a4",
                                                                       "member_identifier" => "1624289008997662",
                                                                       "monthly_premium" => 236.5 }
                                                                   ],
                                                                   "health_only_slcsp_premiums" => [
                                                                     {
                                                                       "cost" => 243.94,
                                                                       "product_id" => "5f773f7bc09d073df2dd232c",
                                                                       "member_identifier" => "1624289008997662",
                                                                       "monthly_premium" => 243.94
                                                                     }
                                                                   ]
                                                                 },
                                                                 "is_homeless" => false,
                                                                 "mitc_income" => { "amount" => 0,
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
                                                                                    "adjusted_gross_income" => 0.0,
                                                                                    "deductible_part_of_self_employment_tax" => 0,
                                                                                    "ira_deduction" => 0,
                                                                                    "student_loan_interest_deduction" => 0,
                                                                                    "tution_and_fees" => 0,
                                                                                    "other_magi_eligible_income" => 0 },
                                                                 "evidences" => [{ "_id" => "61705afffca84e8d2d57f709",
                                                                                   "created_at" => "2021-10-20T18:07:59.262Z",
                                                                                   "description" => nil,
                                                                                   "due_on" => nil,
                                                                                   "eligibility_results" => [
                                                                                     { "_id" => "61706281fca84e8d28eef451",
                                                                                       "code" => "7313",
                                                                                       "code_description" => nil,
                                                                                       "created_at" => "2021-10-20T18:40:01.485Z",
                                                                                       "result" => "eligible",
                                                                                       "source" => "MEDC",
                                                                                       "source_transaction_id" => nil,
                                                                                       "updated_at" => "2021-10-20T18:40:01.485Z" },
                                                                                     { "_id" => "617062cdfca84e8de2e988b3",
                                                                                       "code" => "7313",
                                                                                       "code_description" => nil,
                                                                                       "created_at" => "2021-10-20T18:41:17.894Z",
                                                                                       "result" => "eligible",
                                                                                       "source" => "MEDC",
                                                                                       "source_transaction_id" => nil,
                                                                                       "updated_at" => "2021-10-20T18:41:17.894Z" },
                                                                                     { "_id" => "617063e2fca84e8ec4c2e6ee",
                                                                                       "code" => "7313",
                                                                                       "code_description" => nil,
                                                                                       "created_at" => "2021-10-20T18:45:54.422Z",
                                                                                       "result" => "eligible",
                                                                                       "source" => "MEDC",
                                                                                       "source_transaction_id" => nil,
                                                                                       "updated_at" => "2021-10-20T18:45:54.422Z" },
                                                                                     { "_id" => "6170649ffca84e8ec4c2e6ef",
                                                                                       "code" => "7313",
                                                                                       "code_description" => nil,
                                                                                       "created_at" => "2021-10-20T18:49:03.700Z",
                                                                                       "result" => "eligible",
                                                                                       "source" => "MEDC",
                                                                                       "source_transaction_id" => nil,
                                                                                       "updated_at" => "2021-10-20T18:49:03.700Z" },
                                                                                     { "_id" => "6170655dfca84e8ee2e33803",
                                                                                       "code" => "7313",
                                                                                       "code_description" => nil,
                                                                                       "created_at" => "2021-10-20T18:52:13.037Z",
                                                                                       "result" => "eligible",
                                                                                       "source" => "MEDC",
                                                                                       "source_transaction_id" => nil,
                                                                                       "updated_at" => "2021-10-20T18:52:13.037Z" }
                                                                                   ],
                                                                                   "eligibility_status" => "attested",
                                                                                   "external_service" => nil,
                                                                                   "key" => "aces_mec",
                                                                                   "rejected" => nil,
                                                                                   "title" => "ACES MEC",
                                                                                   "update_reason" => "State Medicaid Agency",
                                                                                   "updated_at" => "2021-10-20T18:56:03.420Z",
                                                                                   "updated_by" => nil }],
                                                                 "mitc_relationships" => [],
                                                                 "mitc_is_required_to_file_taxes" => true }],
                                              "relationships" => [],
                                              "tax_households" => [{ "hbx_id" => "10069",
                                                                     "max_aptc" => { "cents" => 0,
                                                                                     "currency_iso" => "USD" },
                                                                     "is_insurance_assistance_eligible" => "Yes",
                                                                     "annual_tax_household_income" => { "cents" => 0,
                                                                                                        "currency_iso" => "USD" },
                                                                     "tax_household_members" => [{
                                                                       "applicant_reference" => {
                                                                         "first_name" => "betty",
                                                                         "last_name" => "curtis",
                                                                         "dob" => "1998-01-01",
                                                                         "person_hbx_id" => "1624289008997662",
                                                                         "encrypted_ssn" => "stgXNlY2ksCXbGsvz4tst4kEu/sFLMlIlA==\n"
                                                                       },
                                                                       "product_eligibility_determination" => {
                                                                         "is_ia_eligible" => false,
                                                                         "is_medicaid_chip_eligible" => true,
                                                                         "is_totally_ineligible" => false,
                                                                         "is_magi_medicaid" => false,
                                                                         "is_non_magi_medicaid_eligible" => false,
                                                                         "is_without_assistance" => nil,
                                                                         "magi_medicaid_monthly_household_income" => { "cents" => 0,
                                                                                                                       "currency_iso" => "USD" },
                                                                         "medicaid_household_size" => 1,
                                                                         "magi_medicaid_monthly_income_limit" => { "cents" => 0,
                                                                                                                   "currency_iso" => "USD" },
                                                                         "magi_as_percentage_of_fpl" => 0.0,
                                                                         "magi_medicaid_category" => "adult_group"
                                                                       }
                                                                     }] }],
                                              "us_state" => "DC",
                                              "hbx_id" => "16242893665194108",
                                              "oe_start_on" => "2020-11-01",
                                              "notice_options" => { "send_eligibility_notices" => true,
                                                                    "send_open_enrollment_notices" => false },
                                              "mitc_households" => [{ "household_id" => "1",
                                                                      "people" => [{ "person_id" => "1624289008997662" }] }],
                                              "mitc_tax_returns" => [{ "filers" => [{ "person_id" => "1624289008997662" }],
                                                                       "dependents" => [] }] },
            "documents" => [],
            "timestamp" => { "created_at" => "2021-06-21T15:23:29.685+00:00",
                             "modified_at" => "2021-10-07T12:48:24.644+00:00" },
            "irs_groups" => [{ "hbx_id" => nil, "start_on" => "2021-06-21", "end_on" => nil, "is_active" => true }]
          }
        }
      end

      let(:aces_connection) { double('Aces Connection') }

      before :each do
        allow(::MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(double(item: "aces"))
        allow(::MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(aces_connection)
        allow(aces_connection).to receive(:setting).with(:aces_atp_service_username).and_return(double(item: 'username'))
        allow(aces_connection).to receive(:setting).with(:aces_atp_service_password).and_return(double(item: 'password'))
        allow(aces_connection).to receive(:setting).with(:aces_atp_service_uri).and_return(double(item: 'URI'))
        allow(Faraday).to receive(:post).and_return({ test: 'test' })

        sign_in user
        post :create, params: { transfer: { :outbound_payload => outbound_payload.to_s } }
      end

      context 'with valid payload' do
        it 'redirects with success flash ' do
          expect(response).to have_http_status(:redirect)
          expect(flash[:success]).to match(/Successfully send payload/)
        end
      end

      context 'with invalid payload' do
        let(:outbound_payload) do
          {}
        end

        it 'redirects with error flash' do
          expect(response).to have_http_status(:redirect)
          expect(flash[:error]).to match(/Exception raised/)
        end
      end
    end
  end
end
# rubocop:enable Metrics/ModuleLength
