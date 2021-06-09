# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  module Medicaid
    # This class is for publishing the medicaid request payload for a given MagiMedicaidApplication.
    # This is a PRIVATE class, can only be called from Eligibilities::Medicaid::RequestDetermination
    class PublishRequestPayload
      include Dry::Monads[:result, :do]

      # @param [Hash] opts The options to publishing the medicaid request payload
      # @option opts [::AcaEntities::MagiMedicaid::Application] :mm_application
      # @return [Dry::Monads::Result]
      def call(mm_application)
        medicaid_service = yield determine_service(mm_application)
        application = yield generate_and_publish_payload(medicaid_service)

        Success(application)
      end

      private

      # TODO: determine which service to use based on Configuration
      # Example:
      #   1. DC wants MitC to determine Medicaid Eligibility
      #   2. VA might need some other system to determine Medicaid Eligibility
      def determine_service(mm_application)
        @mm_application = mm_application
        Success(:mitc_service)
      end

      def generate_and_publish_payload(_medicaid_service)
        # case medicaid_service
        # when :mitc_service
        #   ::MitcService::GenerateAndPublishPayload(@mm_application)
        # when :other_service
        #   ::OtherService::GenerateAndPublishPayload(@mm_application)
        # else
        # end
        ::MitcService::GenerateAndPublishPayload.new.call(@mm_application)
      end
    end
  end
end
