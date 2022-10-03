# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  module AptcCsr
    # This Operation is to compute CSR values for each member of a given TaxHousehold
    class ComputeAptcsAndPublish
      include Dry::Monads[:result, :do]
      include BenchmarkEhbPremiumHelper

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

      def calculate_benchmark_plan_amount(aptc_household)
        @tax_household = params[:tax_household]
        @application = params[:application]
        ::Eligibilities::AptcCsr::CalculateBenchmarkPlanAmount.new.call({ aptc_household: aptc_household,
                                                                          tax_household: @tax_household,
                                                                          application: @application })
      end

      def calculate_aptc(aptc_household)
        total_benchmark_amount = aptc_household[:total_benchmark_plan_monthly_premium_amount] * 12
        total_contribution_amount = aptc_household[:total_expected_contribution_amount]
        compared_result = total_benchmark_amount - total_contribution_amount
        aptc =
          if compared_result > 0
            correct_aptc_if_qsehra(compared_result, aptc_household) / 12
          else
            BigDecimal('0')
          end
        aptc_household[:maximum_aptc_amount] = aptc.round
        aptc_household[:is_aptc_calculated] = true
        Success(aptc_household)
      end

      def correct_aptc_if_qsehra(compared_result, aptc_household)
        amount = total_monthly_qsehra_amount(aptc_household)
        return compared_result if amount.zero?

        corrected_aptc = compared_result - (amount * 12.0)
        corrected_aptc > 0 ? corrected_aptc : BigDecimal('0')
      end

      # Check qsehra for APTC eligible members only
      def total_monthly_qsehra_amount(aptc_household)
        aptc_eligible_members = aptc_household[:members].select do |member|
          member[:aptc_eligible] == true
        end
        aptc_eligible_members.inject(BigDecimal('0')) do |total, member|
          applicant = applicant_by_reference(member[:member_identifier])
          total + applicant.monthly_qsehra_amount
        end
      end

      def applicant_by_reference(person_hbx_id)
        @application.applicants.detect do |applicant|
          applicant.person_hbx_id.to_s == person_hbx_id.to_s
        end
      end

      def determine_event_name_and_publish_payload(mm_application)
        if @use_non_dynamic_slcsp
          publish_payload_for_fully_determined_application(mm_application)
        else
          construct_and_publish_payload_for_dynamic_slcsp(mm_application)
        end
      end

      # rubocop:disable Metrics/CyclomaticComplexity
      def publish_payload_for_fully_determined_application(mm_application)
        peds = mm_application.tax_households.flat_map(&:tax_household_members).map(&:product_eligibility_determination)
        event_name =
          if peds.all?(&:is_ia_eligible)
            :aptc_eligible
          elsif peds.all?(&:is_medicaid_chip_eligible)
            :medicaid_chip_eligible
          elsif peds.all?(&:is_totally_ineligible)
            :totally_ineligible
          elsif peds.all?(&:is_magi_medicaid)
            :magi_medicaid_eligible
          elsif peds.all?(&:is_uqhp_eligible)
            :uqhp_eligible
          else
            :mixed_determination
          end

        Eligibilities::PublishDetermination.new.call(mm_application, event_name.to_s)

        Success({ event: event_name, payload: mm_application })
      end
      # rubocop:enable Metrics/CyclomaticComplexity

      def construct_and_publish_payload_for_dynamic_slcsp(mm_application)
        Success({ event: :event_name, payload: mm_application })
      end
    end
  end
end
