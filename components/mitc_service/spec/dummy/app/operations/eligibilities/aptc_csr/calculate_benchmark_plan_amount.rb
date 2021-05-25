# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  module AptcCsr
    # This Operation is for calculating the BenchmarkPlanAmount for each APTC calculation eligible member
    class CalculateBenchmarkPlanAmount
      include Dry::Monads[:result, :do]

      # @param [Hash] opts The options to calculate benchmark_plan_amount
      # @option opts [Hash] :aptc_household(params of ::AptcCsr::AptcHouseholdContract)
      # @option opts [AcaEntities::MagiMedicaid::TaxHoushold] :magi_medicaid_tax_household
      # @option opts [AcaEntities::MagiMedicaid::Application] :magi_medicaid_application(includes MAGI Medicaid Deteminations)
      # @return [Dry::Result]
      # This class is PRIVATE. Can only be called from ::Eligibilities::AptcCsr::ComputeAptcAndCsr
      def call(params)
        # { aptc_household: aptc_household,
        #   tax_household: @mm_tax_household,
        #   application: @mm_application }

        aptc_household = yield determine_eligible_members_with_benchmark_amounts(params)
        Success(aptc_household)
      end

      private

      def determine_eligible_members_with_benchmark_amounts(params)
        @aptc_household = params[:aptc_household]
        @tax_household = params[:tax_household]
        @application = params[:application]

        aptc_members = @aptc_household[:members].select { |mbr| mbr[:aptc_eligible] }
        thhms_hashes = applicant_rel_with_premiums(aptc_members)
        child_thhms = thhms_hashes.select { |thhm| thhm[:relationship_kind_to_primary] == 'child' }

        if child_thhms.count > 3
          eligible_children = child_thhms.sort_by { |k| k[:member_premium] }.last(3)
          eligible_aptc_members = eligible_children
          thhms_hashes.select do |thhm|
            eligible_aptc_members << thhm unless child_thhms[:member_identifier].include?(thhm[:member_identifier])
          end
        else
          eligible_aptc_members = thhms_hashes
        end

        total_monthly_benchmark = eligible_aptc_members.inject(BigDecimal('0')) do |total, thhm_hash|
          total + thhm_hash[:member_premium]
        end
        @aptc_household[:aptc_calculation_members] = eligible_aptc_members
        @aptc_household[:total_benchmark_plan_monthly_premium_amount] = total_monthly_benchmark
        Success(@aptc_household)
      end

      def applicant_rel_with_premiums(aptc_members)
        aptc_members.inject([]) do |mem_hashes, aptc_mmbr|
          applicant = applicant_by_reference(aptc_mmbr[:member_identifier])
          primary = @application.primary_applicant
          rel_kind = @application.relationship_kind(applicant, primary)
          member_premium = applicant_member_premium(applicant)
          mem_hashes << { member_identifier: applicant.person_hbx_id,
                          relationship_kind_to_primary: rel_kind,
                          # age_of_applicant: applicant.age_of_applicant,
                          member_premium: member_premium }
          aptc_mmbr[:benchmark_plan_monthly_premium_amount] = member_premium
          mem_hashes
        end
      end

      def applicant_member_premium(applicant)
        applicant.slcsp_premium
      end

      def applicant_by_reference(person_hbx_id)
        @application.applicants.detect do |applicant|
          applicant.person_hbx_id.to_s == person_hbx_id.to_s
        end
      end
    end
  end
end
