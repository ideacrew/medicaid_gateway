# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module AptcCsr
  # This Operation is for calculating the BenchmarkPlanAmount for each APTC calculation eligible member
  class CalculateBenchmarkPlanAmount
    include Dry::Monads[:result, :do]

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

      members = @tax_household.tax_household_members.select do |thhm|
        applicant = mm_applicant_by_ref(thhm.applicant_reference.person_hbx_id)
        applicant_eligible_for_aptc?(applicant)
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

    # TODO: fix below
    def applicant_member_premium(_applicant)
      BigDecimal('496.02')
    end

    def applicant_eligible_for_aptc?(applicant)
      applicant.is_applying_coverage &&
        !enrolled_or_eligible_for_mecs?(applicant) &&
        !eligible_but_does_not_plan_to_enroll?(applicant) &&
        true
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
