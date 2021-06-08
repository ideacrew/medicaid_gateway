# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module MitcService
  # This class is for generating & publishing
  # the medicaid request payload for a given MagiMedicaidApplication
  # to Magi In The Cloud(MiTC)
  # This is a PRIVATE class, can only be called from Eligibilities::Medicaid::PublishRequestPayload
  class GenerateAndPublishPayload
    include Dry::Monads[:result, :do]

    # @param [Hash] opts The options to publishing the medicaid request payload
    # @option opts [::AcaEntities::MagiMedicaid::Application] :mm_application
    # @return [Dry::Monads::Result]
    def call(mm_application)
      mm_application = yield validate_mm_application(mm_application)
      mitc_request_payload = yield generate_request_payload(mm_application)
      _message = yield publish_mitc_request_payload(mitc_request_payload)

      Success(mitc_request_payload)
    end

    private

    def validate_mm_application(mm_application)
      if mm_application.is_a?(::AcaEntities::MagiMedicaid::Application)
        Success(mm_application)
      else
        Failure("Invalid Application, given value is not a ::AcaEntities::MagiMedicaid::Application, input_value: #{mm_application}")
      end
    end

    # Transforms MagiMedicaid Application to Mitc Request Payload
    def generate_request_payload(mm_application)
      ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(mm_application)
    end

    def publish_mitc_request_payload(mitc_request_payload)
      # rename MitcService::CallMagiInTheCloud to MitcService::PublishRequestPayload
      ::MitcService::CallMagiInTheCloud.new.call(mitc_request_payload)
    end
  end
end
