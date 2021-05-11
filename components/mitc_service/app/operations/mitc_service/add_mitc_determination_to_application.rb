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
        mm_thh[:tax_household_members].each do |mm_thhm|
          mitc_applicant = mitc_applicant_by_person_id(mitc_applicants, mitc_response[:applicants].first[:person_id])
          ped_attrs = { magi_medicaid_monthly_household_income: mitc_applicant[:medicaid_household][:magi_income],
                        medicaid_household_size: mitc_applicant[:medicaid_household][:size],
                        magi_as_percentage_of_fpl: mitc_applicant[:medicaid_household][:magi_as_percentage_of_fpl],
                        is_magi_medicaid: to_boolean(mitc_applicant[:is_medicaid_eligible]),
                        is_medicaid_chip_eligible: to_boolean(mitc_applicant[:is_chip_eligible]),
                        magi_medicaid_ineligibility_reasons: mitc_applicant[:medicaid_ineligibility_reasons],
                        is_eligible_for_non_magi_reasons: mitc_applicant[:is_eligible_for_non_magi_reasons],
                        chip_ineligibility_reasons: mitc_applicant[:chip_ineligibility_reasons],
                        magi_medicaid_category: medicaid_category(mitc_applicant[:medicaid_category]),
                        magi_medicaid_category_threshold: mitc_applicant[:medicaid_category_threshold],
                        medicaid_chip_category: mitc_applicant[:chip_category],
                        medicaid_chip_category_threshold: mitc_applicant[:chip_category_threshold],
                        category_determinations: category_determinations(mitc_applicant[:determinations]) }

          mm_thhm[:product_eligibility_determination].merge!(ped_attrs)
        end
      end
    end

    def to_boolean(value)
      { 'Y' => true, 'N' => false }[value]
    end

    def medicaid_category(value)
      Types::MitcToMagiMedicaidMedicaidCategoryMap[value]
    end

    def category_determinations(determinations)
      determinations.inject([]) do |det_array, deter|
        det_array << { category: deter[:category],
                       indicator_code: to_boolean(deter[:indicator_code]),
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
