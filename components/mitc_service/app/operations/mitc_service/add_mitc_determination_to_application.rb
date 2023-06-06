# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module MitcService
  # This class takes MagiMedicaidApplication & mitc_response_payload as input and returns MagiMedicaidApplication with added MitcDetermination
  # This class is PRIVATE and can only be used from MitcService::DetermineMitcEligibility
  class AddMitcDeterminationToApplication
    include Dry::Monads[:result, :do]

    # @param [Hash] opts The options to add MitcDetermination to MagiMedicaidApplication
    # @option opts [AcaEntities::MagiMedicaid::Application] :magi_medicaid_application
    # @option opts [Hash] :mitc_response MitC Actual response for the submitted MagiMedicaidApplication
    # @return [Dry::Monads::Result]
    def call(params)
      # a) Validate incoming params.
      # b) Transform MitC Response Payload to match with MitcEligibilityReponse
      #   AcaEntities::MagiMedicaid::Mitc::Transformers::ToMitc::EligibilityResponse
      # c) Add MitcDetermination to MagiMedicaidApplication

      validated_params = yield validate_input_params(params)
      result_params = yield transform_response_payload(validated_params)
      mm_application = yield add_determination_to_mm_application(result_params)

      Success(mm_application)
    end

    private

    def validate_input_params(params)
      if !params.key?(:magi_medicaid_application) || !params.key?(:mitc_response)
        Failure('Input hash does not have one/both the keys :magi_medicaid_application, :mitc_response')
      elsif !params[:magi_medicaid_application].is_a?(::AcaEntities::MagiMedicaid::Application)
        Failure('Given value for key :magi_medicaid_application is not a ::AcaEntities::MagiMedicaid::Application')
      else
        Success(params)
      end
    end

    # Transform mitc_response_payload to MitcEligibilityReponse
    def transform_response_payload(params)
      ::AcaEntities::MagiMedicaid::Mitc::Transformers::ToMitc::EligibilityResponse.call(params[:mitc_response].to_json) do |record|
        @transform_result = record
      end

      Success({ magi_medicaid_application: params[:magi_medicaid_application],
                mitc_response: @transform_result })
    end

    def add_determination_to_mm_application(result_params)
      mm_app_hash = result_params[:magi_medicaid_application].to_h
      mitc_response = result_params[:mitc_response]
      add_determination_data(mm_app_hash, mitc_response)

      ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(mm_app_hash)
    rescue StandardError => _e
      # TODO: Log the error
      if mm_app_hash[:hbx_id].present?
        # Rails.logger.error { "MitCIntegrationError: for magi_medicaid_application with
        #   hbx_id: #{mm_app_hash[:hbx_id]} with mitc_response: #{mitc_response}, error: #{e.backtrace}" }
        Failure("Error adding MitC response: #{mitc_response} to magi_medicaid_application: #{mm_app_hash} with hbx_id: #{mm_app_hash[:hbx_id]}")
      else
        # Rails.logger.error { "MitCIntegrationError: for mitc_response: #{mitc_response}, error: #{e.backtrace}" }
        Failure("Error adding MitC response: #{mitc_response} to magi_medicaid_application: #{mm_app_hash}")
      end
    end

    def add_determination_data(mm_app_hash, mitc_response)
      mitc_applicants = mitc_response[:applicants]
      mm_app_hash[:tax_households].each do |mm_thh|
        mm_thh[:determined_on] = Date.today
        mm_thh[:effective_on] = calculate_eligibility_date(mm_app_hash)
        mm_thh[:tax_household_members].each do |mm_thhm|
          member_identifier = mm_thhm[:applicant_reference][:person_hbx_id]
          mitc_bypass_flag = bypass_mitc_determination?(mm_app_hash, member_identifier)
          mitc_applicant = mitc_applicant_by_person_id(mitc_applicants, member_identifier)
          next mm_thhm if mitc_applicant.blank?
          ped_attrs = { magi_medicaid_monthly_household_income: mitc_applicant[:medicaid_household][:magi_income],
                        medicaid_household_size: mitc_applicant[:medicaid_household][:size],
                        magi_as_percentage_of_fpl: mitc_applicant[:medicaid_household][:magi_as_percentage_of_fpl],
                        is_magi_medicaid: calculate_medicaid_eligibility(mitc_applicant[:is_medicaid_eligible], mitc_bypass_flag),
                        is_medicaid_chip_eligible: calculate_medicaid_eligibility(mitc_applicant[:is_chip_eligible], mitc_bypass_flag),
                        magi_medicaid_ineligibility_reasons: mitc_applicant[:medicaid_ineligibility_reasons] || [],
                        is_eligible_for_non_magi_reasons: get_non_magi_reasons(mitc_applicant),
                        chip_ineligibility_reasons: mitc_applicant[:chip_ineligibility_reasons] || [],
                        magi_medicaid_category: medicaid_category(mitc_applicant[:medicaid_category]),
                        magi_medicaid_category_threshold: mitc_applicant[:medicaid_category_threshold],
                        medicaid_chip_category: mitc_applicant[:chip_category],
                        medicaid_chip_category_threshold: mitc_applicant[:chip_category_threshold],
                        category_determinations: category_determinations(mitc_applicant[:determinations]) }

          mm_thhm[:product_eligibility_determination].merge!(ped_attrs)
        end
      end
    end

    # For a case, value for 'Non-MAGI Referral' is not sent but the cleanDets with
    # category 'Medicaid Non-MAGI Referral' has the determination for is_eligible_for_non_magi_reasons.

    # TestCase:
    #   1. 'cms ME complex_scenarios test_case_e_1'
    #   2. spec/shared_contexts/eligibilities/cms/me_complex_scenarios/test_case_e_1.rb
    #   3. Member Name: 'Baby Ee', hbx_id: 1002558
    def get_non_magi_reasons(mitc_applicant)
      mitc_applicant[:determinations].detect do |cat_det|
        cat_det[:category].to_s == 'Medicaid Non-MAGI Referral'
      end[:indicator_code]
    end

    # Calculates MagiMedicaid/MedicaidChip eligibility based on MitcBypassFlag
    def calculate_medicaid_eligibility(medicaid_eligible, mitc_bypass_flag)
      return false if mitc_bypass_flag
      mitc_value_to_boolean(medicaid_eligible)
    end

    def calculate_eligibility_date(mm_app_hash)
      current_date = Date.today
      return Date.new(mm_app_hash[:assistance_year]) if current_date.year < mm_app_hash[:assistance_year]
      return mm_app_hash[:aptc_effective_date] if current_date.year > mm_app_hash[:assistance_year]
      oe_start_on = mm_app_hash[:oe_start_on]
      end_of_assistance_year = Date.new(mm_app_hash[:assistance_year]).end_of_year
      if (oe_start_on..end_of_assistance_year).cover?(current_date)
        mm_app_hash[:aptc_effective_date]
      else
        current_date.next_month.beginning_of_month
      end
    end

    def applicant_is_not_applying_coverage?(mm_app_hash, member_identifier)
      applicant = mm_app_hash[:applicants].detect { |appli_hash| appli_hash[:person_hbx_id] == member_identifier }
      !applicant[:is_applying_coverage]
    end

    def bypass_mitc_determination?(mm_app_hash, member_identifier)
      return if applicant_is_not_applying_coverage?(mm_app_hash, member_identifier)

      mm_applicant = applicant_by_reference(mm_app_hash, member_identifier)
      # should not be eligible if the applicant is incarcerated
      return true if mm_applicant[:attestation][:is_incarcerated] && !MedicaidGatewayRegistry.feature_enabled?(:medicaid_eligible_incarcerated)
      medicaid_and_chip = mm_applicant[:medicaid_and_chip]
      return false if medicaid_and_chip.blank?
      date_for_comparision = Date.today - 90.days
      medicaid_or_chip_denial?(date_for_comparision, medicaid_and_chip) ||
        medicaid_or_chip_termination?(date_for_comparision, medicaid_and_chip) ||
        denial_due_to_immigration?(medicaid_and_chip)
    end

    def medicaid_or_chip_denial?(date_for_comparision, medicaid_and_chip)
      medicaid_and_chip[:not_eligible_in_last_90_days] &&
        medicaid_and_chip[:denied_on] &&
        date_for_comparision < medicaid_and_chip[:denied_on]
    end

    def medicaid_or_chip_termination?(date_for_comparision, medicaid_and_chip)
      medicaid_and_chip[:ended_as_change_in_eligibility] &&
        !medicaid_and_chip[:hh_income_or_size_changed] &&
        date_for_comparision < medicaid_and_chip[:medicaid_or_chip_coverage_end_date]
    end

    def denial_due_to_immigration?(medicaid_and_chip)
      medicaid_and_chip[:ineligible_due_to_immigration_in_last_5_years] &&
        !medicaid_and_chip[:immigration_status_changed_since_ineligibility]
    end

    def applicant_by_reference(mm_app_hash, member_identifier)
      mm_app_hash[:applicants].detect do |applicant|
        applicant[:person_hbx_id].to_s == member_identifier.to_s
      end
    end

    def mitc_value_to_boolean(value)
      { 'Y' => true, 'N' => false }[value]
    end

    def medicaid_category(value)
      Types::MitcToMagiMedicaidMedicaidCategoryMap[value]
    end

    def category_determinations(determinations)
      determinations.inject([]) do |det_array, deter|
        det_array << { category: deter[:category],
                       indicator_code: mitc_value_to_boolean(deter[:indicator_code]),
                       ineligibility_code: deter[:ineligibility_code],
                       ineligibility_reason: deter[:ineligibility_reason] }
      end
    end

    def mitc_applicant_by_person_id(applicants, person_id)
      applicants.detect do |applicant|
        applicant[:person_id].to_s == person_id.to_s
      end
    end
  end
end

# Pending Tasks:
#   1. Log all Failure moands for finding failure cases.
