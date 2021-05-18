# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module MitcService
  # This class is for detemining the full eligibility for a given MagiMedicaidApplication
  class DetermineFullEligibility
    include Dry::Monads[:result, :do]

    # @param [Hash] opts The options to determine eligibility
    # @option opts [Hash] :params MagiMedicaid Application request payload
    # @return [Dry::Monads::Result]
    def call(params)
      # 1. init_magi_medicaid_application.
      #   Operation(::AcaEntities::MagiMedicaid::Operations::InitializeApplication) that takes
      #     CV3 MagiMedicaidApplication payload as input and returns ::AcaEntities::MagiMedicaid::Application
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
      mm_app_with_mitc_determination = yield determine_mitc_eligibility(mm_application)
      mm_app_with_full_determination = yield determine_full_eligibility(mm_app_with_mitc_determination)

      Success(mm_app_with_full_determination)
    end

    private

    def init_magi_medicaid_application(params)
      # TODO: We should be storing the Request from MagiMedicaidEngine of EA as it is into MedicaidGateway's DB.
      ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(params)
    end

    def determine_mitc_eligibility(mm_application)
      ::MitcService::DetermineMitcEligibility.new.call(mm_application)
    end

    def determine_full_eligibility(mm_application)
      @result_mm_application ||= mm_application
      mm_application.tax_households.each do |mm_thh|
        result = ::AptcCsr::DetermineEligibility.new.call({ magi_medicaid_application: @result_mm_application,
                                                            magi_medicaid_tax_household: mm_thh })
        return result if result.failure?
        @result_mm_application = result.success[:magi_medicaid_application]
      end

      Success(@result_mm_application)
    end
  end
end

# Pending Tasks:
#   1. Store magi_medicaid_request_payload, mitc_request_payload, mitc_response_payload and magi_medicaid_request_payload
#   2. Send out an event.
#   3. Log all Failure moands for finding failure cases.
