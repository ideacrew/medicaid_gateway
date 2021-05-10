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
    # @option opts [Hash] :mitc_response MitC response for the submitted MagiMedicaidApplication
    # @return [Dry::Monads::Result]
    def call(params)
      # a) Transform mitc_response_payload to MitcEligibilityReponse
      #   ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload
      # b) Call MAGI in the cloud to get eligibility determination
      #   ::MitcService::CallMitc
      # c) Load MitC determination on to the MagiMedicaidApplication
      #   ::MitcService::AddMitcDetermination
      # { magi_medicaid_application: mm_application, mitc_response: mitc_response_payload }
      validated_params = yield validate_input_params(params)
      mitc_eligibility_response = yield transform_response_payload(validated_params)

      Success(mitc_eligibility_response)
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
  end
end
