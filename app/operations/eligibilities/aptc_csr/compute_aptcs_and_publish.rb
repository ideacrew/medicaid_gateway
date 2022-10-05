# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  module AptcCsr
    # This Operation is to compute CSR values for each member of a given TaxHousehold
    class ComputeAptcsAndPublish
      include Dry::Monads[:result, :do]
      include BenchmarkEhbPremiumHelper
      include EventSource::Command

      def call(params)
        # { magi_medicaid_application: mm_application }

        mm_application, medicaid_application = yield find_medicaid_application(params)
        mm_application = yield compute_aptcs(mm_application, medicaid_application)
        event_name = yield determine_event_name_and_publish_payload(mm_application)

        Success({ event: event_name, payload: mm_application })
      end

      private

      def find_medicaid_application(params)
        mm_application = params[:magi_medicaid_application]
        medicaid_app = ::Medicaid::Application.where(application_identifier: mm_application.hbx_id).last

        if medicaid_app.present?
          Success([mm_application, medicaid_app])
        else
          Failure("Unable to find Medicaid Application with given identifier: #{mm_application.hbx_id}")
        end
      end

      def compute_aptcs(mm_application, medicaid_application)
        @use_non_dynamic_slcsp = use_non_dynamic_slcsp?(mm_application)
        tax_households = if @use_non_dynamic_slcsp
                           mm_application.tax_households
                         else
                           # tax_households_without_aptc_eligible_children
                           mm_application.tax_households.select do |thh|
                             thh.aptc_csr_eligible_members.all? do |aptc_member|
                               age_on(mm_application.aptc_effective_date, aptc_member.applicant_reference.dob) >= 19
                             end
                           end
                         end

        @result_mm_application ||= mm_application
        tax_households.each do |mm_thh|
          # Do not determine APTC/CSR if all members are ineligible
          next mm_thh unless mm_thh.aptc_csr_eligible?
          result = ::Eligibilities::AptcCsr::ComputeAptc.new.call({ application: @result_mm_application,
                                                                    medicaid_application: medicaid_application,
                                                                    tax_household: mm_thh })
          return result if result.failure?
          @result_mm_application = result.success[:magi_medicaid_application]
        end
        medicaid_application.update_attributes!(application_response_payload: @result_mm_application.to_json)

        Success(@result_mm_application)
      end

      def determine_event_name_and_publish_payload(mm_application)
        if @use_non_dynamic_slcsp
          Eligibilities::DetermineEventAndPublishFullDetermination.new.call(mm_application)
        else
          construct_and_publish_payload_for_dynamic_slcsp(mm_application)
        end
      end

      def construct_and_publish_payload_for_dynamic_slcsp(mm_application)
        event("events.magi_medicaid.iap.benchmark_products.determine_slcsp", attributes: mm_application.to_h).success.publish

        Success({ event: :determine_slcsp, payload: mm_application })
      end
    end
  end
end