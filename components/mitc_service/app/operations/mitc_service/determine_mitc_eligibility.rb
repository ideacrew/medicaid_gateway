# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module MitcService
  # DO NOT USE this operation, the AcaEntities::MagiMedicaid::Transformers::IapTo::Mitc has some mocked attributes
  # This class takes MagiMedicaidApplication as input and returns MagiMedicaidApplication with added MitcDetermination
  class DetermineMitcEligibility
    include Dry::Monads[:result, :do]

    # @param [Hash] opts The options to determine mitc eligibility
    # @option opts [Hash] :magi_medicaid_application MagiMedicaid::Application entity
    # @return [Dry::Monads::Result]
    def call(magi_medicaid_application)
      # a) Transform mm_application to mitc_request_payload
      #   ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload
      # b) Call MAGI in the cloud to get eligibility determination
      #   ::MitcService::CallMitc
      # c) Load MitC determination on to the MagiMedicaidApplication
      #   ::MitcService::AddMitcDetermination

      mm_application = yield validate_mm_application(magi_medicaid_application)
      mitc_request_payload = yield transform_mm_app_to_mitc_request_payload(mm_application)
      mitc_response_payload = yield call_magi_in_the_cloud(mitc_request_payload)
      mm_app_with_mitc_determination = yield add_mitc_determination_to_mm_application(mm_application, mitc_response_payload)

      Success(mm_app_with_mitc_determination)
    end

    private

    def validate_mm_application(magi_medicaid_application)
      if magi_medicaid_application.is_a?(::AcaEntities::MagiMedicaid::Application)
        Success(magi_medicaid_application)
      else
        Failure("Invalid Application, given value is not a ::AcaEntities::MagiMedicaid::Application, input_value:#{magi_medicaid_application}")
      end
    end

    def transform_mm_app_to_mitc_request_payload(mm_application)
      ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(mm_application)
    end

    def call_magi_in_the_cloud(mitc_request_payload)
      # TODO: We should be storing the Response from MitC as it is into MedicaidGateway's DB.
      ::MitcService::CallMagiInTheCloud.new.call(mitc_request_payload)
    end

    def add_mitc_determination_to_mm_application(mm_application, mitc_response_payload)
      ::MitcService::AddMitcDeterminationToApplication.new.call({ magi_medicaid_application: mm_application,
                                                                  mitc_response: mitc_response_payload })
      Success(mm_application)
    end
  end
end
