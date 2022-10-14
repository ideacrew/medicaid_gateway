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
      def call(params, is_renewal = nil)
        mm_application = yield init_magi_medicaid_application(params)
        application = yield publish_request_payload(mm_application, is_renewal)

        Success(application)
      end

      private

      def init_magi_medicaid_application(params)
        ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(params)
      end

      def publish_request_payload(mm_application, is_renewal)
        ::Eligibilities::Medicaid::PublishRequestPayload.new.call(mm_application, is_renewal)
      end
    end
  end
end
