# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module AptcCsr
  # This Operation is for calculating the BenchmarkPlanAmount for each APTC calculation eligible member
  class CalculateBenchmarkPlanAmount
    include Dry::Monads[:result, :do]

    # @param [Hash] opts The options to calculate benchmark_plan_amount
    # @option opts [Hash] :aptc_household(params of ::AptcCsr::AptcHouseholdContract)
    # @option opts [AcaEntities::MagiMedicaid::TaxHoushold] :magi_medicaid_tax_household
    # @option opts [AcaEntities::MagiMedicaid::Application] :magi_medicaid_application(includes MAGI Medicaid Deteminations)
    # @return [Dry::Result]
    # This class is PRIVATE. Can only be called from ::AptcCsr::ComputeAptcAndCsr
    def call(params)
      # { aptc_household: aptc_household,
      #   tax_household: @mm_tax_household,
      #   application: @mm_application }

      aptc_household = yield determine_eligible_members_with_benchmark_amounts(params)
      Success(aptc_household)
    end

    private

    def matching_aptc_member(aptc_household, member_identifier)
      aptc_household[:members].detect { |aptc_mem| aptc_mem[:member_identifier].to_s == member_identifier.to_s }
    end

    # rubocop:disable Metrics/MethodLength
    def determine_eligible_members_with_benchmark_amounts(params)
      @aptc_household = params[:aptc_household]
      @tax_household = params[:tax_household]
      @application = params[:application]

      members = @tax_household.tax_household_members.inject([]) do |membrs, thhm|
        applicant = mm_applicant_by_ref(thhm.applicant_reference.person_hbx_id)
        aptc_membr = matching_aptc_member(aptc_household, member_identifier)
        if applicant_eligible_for_aptc?(applicant)
          membrs << thhm
          aptc_membr[:aptc_eligible] = true
        else
          aptc_membr[:aptc_eligible] = false
        end
        membrs
      end

      thhms_hashes = applicant_rel_with_premiums(members)
      child_thhms = thhms_hashes.select { |thhm| thhm[:relationship_kind_to_primary] == 'child' }
      eligible_members =
        if child_thhms.count > 3
          eligible_children = child_thhms.sort_by { |k| k[:member_premium] }.last(3)
          eligible_members = eligible_children
          thhms_hashes.select do |thhm|
            eligible_members << thhm unless child_thhms[:member_identifier].include?(thhm[:member_identifier])
          end
        else
          eligible_members = thhms_hashes
        end
      total_monthly_benchmark = eligible_members.inject(0) do |total, thhm_hash|
        total + thhm_hash[:member_premium]
      end
      @aptc_household[:aptc_calculation_members] = eligible_members
      @aptc_household[:total_benchmark_plan_monthly_premium_amount] = total_monthly_benchmark
      Success(@aptc_household)
    end
    # rubocop:enable Metrics/MethodLength

    def applicant_rel_with_premiums(members)
      members.inject([]) do |mem_hashes, thhm|
        aptc_member = @aptc_household[:members].detect { |member| member[:member_identifier] == thhm.applicant_reference.person_hbx_id }
        applicant = mm_applicant_by_ref(thhm.applicant_reference.person_hbx_id)
        primary = @application.primary_applicant
        rel_kind = @application.relationship_kind(applicant, primary)
        member_premium = applicant_member_premium(applicant)
        mem_hashes << { member_identifier: applicant.person_hbx_id,
                        relationship_kind_to_primary: rel_kind,
                        member_premium: member_premium }
        aptc_member[:benchmark_plan_monthly_premium_amount] = member_premium
        mem_hashes
      end
    end

    def applicant_member_premium(applicant)
      applicant.slcsp_premium
    end

    def applicant_eligible_for_aptc?(applicant)
      applicant.is_applying_coverage &&
        !enrolled_or_eligible_for_mecs?(applicant) &&
        !eligible_but_does_not_plan_to_enroll?(applicant)
    end

    # TODO: fix below
    def eligible_but_does_not_plan_to_enroll?(_applicant)
      false
    end

    def enrolled_or_eligible_for_mecs?(applicant)
      applicant.minimum_essential_coverages.present?
    end

    def mm_applicant_by_ref(person_hbx_id)
      @application.applicants.detect do |applicant|
        applicant.person_hbx_id.to_s == person_hbx_id.to_s
      end
    end
  end
end

# Pending Tasks:
#   1. Fix Rules to check for APTC eligibility
#   2. Do we have any other rules which we need to configure?
#   3. Do we have to configure the child count?
#      Will the child count differ between states?