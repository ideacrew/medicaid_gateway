# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module MitcService
  class DetermineFullEligibility
    include Dry::Monads[:result, :do]

    # @param [Hash] opts The options to determine eligibility
    # @option opts [Hash] :params MagiMedicaid Application request payload
    # @return [Dry::Monads::Result]
    def call(params)
      # 1. init_magi_medicaid_application.
      #   Operation(::AcaEntities::MagiMedicaid::Operations::InitializeApplication) that takes CV3 MagiMedicaidApplication payload as input and returns ::AcaEntities::MagiMedicaid::Application
      # 2. magi_medicaid_application_with_determination
      #   a) Transform mm_application to mitc_request_payload
      #     ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload
      #   b) Call MAGI in the cloud to get eligibility determination
      #     ::MitcService::CallMitc
      #   c) Load MitC determination on to the MagiMedicaidApplication
      #     ::MitcService::AddMitcDetermination
      # 3. determine APTC/CSR and other eligibilities
      #   ::AddAptcCsrDetermination

      mm_application = yield init_magi_medicaid_application(params)
      mm_app_with_determination = yield determine_mitc_eligibility(mm_application)
      Success({})
    end

    private

    def init_magi_medicaid_application(params)
      # TODO: We should be storing the Request from MagiMedicaidEngine of EA as it is into MedicaidGateway's DB.
      ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(params)
    end

    def determine_mitc_eligibility(mm_application)
      ::MitcService::DetermineMitcEligibility.new.call(mm_application)
    end
  end
end
