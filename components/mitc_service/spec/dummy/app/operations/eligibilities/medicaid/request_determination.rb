# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  module Medicaid
    # This class is for requesting the medicaid determination for all the Applicants.
    class RequestDetermination
      include Dry::Monads[:result, :do]

      # @param [Hash] opts The options to request medicaid determination
      # @option opts [Hash] :params MagiMedicaid Application request payload
      # @return [Dry::Monads::Result]
      def call(params)
        mm_application = yield init_magi_medicaid_application(params)
        medicaid_request_payload = yield publish_request_payload(mm_application)
        application = yield persist_medicaid_application(mm_application, medicaid_request_payload)

        Success(application)
      end

      private

      def init_magi_medicaid_application(params)
        ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(params)
      end

      def publish_request_payload(mm_application)
        ::Eligibilities::Medicaid::PublishRequestPayload.new.call(mm_application)
      end

      def persist_medicaid_application(mm_application, medicaid_request_payload)
        ::Applications::Create.new.call({ application_identifier: mm_application.hbx_id,
                                          application_request_payload: mm_application.to_json,
                                          medicaid_request_payload: medicaid_request_payload.to_json })
      end
    end
  end
end
