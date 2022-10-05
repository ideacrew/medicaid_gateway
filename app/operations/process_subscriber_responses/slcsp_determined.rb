# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module ProcessSubscriberResponses
  # This Operation processes SlcspDetermined Response.
  # Computes APTC for tax households with Dynamic SLCSP values.
  class SlcspDetermined
    include Dry::Monads[:result, :do]

    def call(mm_application_params)
      mm_application       = yield initialize_application(mm_application_params)
      medicaid_application = yield find_medicaid_application(mm_application)
      mm_application       = yield compute_aptcs(mm_application, medicaid_application)
      event_name           = yield determine_event_name_and_publish_payload(mm_application)

      Success({ event: event_name, payload: mm_application })
    end

    private

    def initialize_application(params)
      AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(params)
    end

    def find_medicaid_application(mm_application)
      medicaid_app = ::Medicaid::Application.where(application_identifier: mm_application.hbx_id).last

      if medicaid_app.present?
        Success(medicaid_app)
      else
        Failure("Unable to find Medicaid Application with given identifier: #{mm_application.hbx_id}")
      end
    end

    def compute_aptcs(mm_application, medicaid_application)
      tax_household_hbx_ids = mm_application.benchmark_product.households.map(&:household_hbx_id)
      tax_households = mm_application.tax_households.select { |thh| tax_household_hbx_ids.include?(thh.hbx_id) }

      @result_mm_application ||= mm_application
      tax_households.each do |mm_thh|
        household_ehb_premium = mm_application.benchmark_product.households.detect { |hh| hh.household_hbx_id == mm_thh.hbx_id }.household_ehb_premium
        result = ::Eligibilities::AptcCsr::ComputeAptc.new.call({ application: @result_mm_application,
                                                                  medicaid_application: medicaid_application,
                                                                  tax_household: mm_thh,
                                                                  household_benchmark_ehb_premium: household_ehb_premium })
        return result if result.failure?
        @result_mm_application = result.success[:magi_medicaid_application]
      end
      medicaid_application.update_attributes!(application_response_payload: @result_mm_application.to_json)

      Success(@result_mm_application)
    end

    def determine_event_name_and_publish_payload(mm_application)
      Eligibilities::DetermineEventAndPublishFullDetermination.new.call(mm_application)
    end
  end
end
