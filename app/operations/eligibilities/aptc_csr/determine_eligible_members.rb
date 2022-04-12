# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

# This operation is private to ::Eligibilities::AptcCsr::DetermineEligibility
module Eligibilities
  module AptcCsr
    # This Operation is to compute the APTC and CSR values for a given TaxHousehold
    # rubocop:disable Metrics/ClassLength
    class DetermineEligibleMembers
      include Dry::Monads[:result, :do]

      def call(params)
        # { tax_household: @tax_household,
        #   aptc_household: aptc_household,
        #   application: @application }
        affordability_threshold = yield find_affordability_threshold(params)
        aptc_household = yield determine_who_qualifies_for_aptc_csr(affordability_threshold)
        aptc_household = yield determine_slcsp_premiums(aptc_household)

        Success(aptc_household)
      end

      private

      def determine_slcsp_premiums(aptc_household)
        ::Eligibilities::AptcCsr::FindSlcspPremiums.new.call({ aptc_household: aptc_household, application: @application })
      end

      def find_affordability_threshold(params)
        @application = params[:application]
        @tax_household = params[:tax_household]
        @aptc_household = params[:aptc_household]

        AptcCsr::FindAffordabilityThreshold.new.call(@aptc_household[:eligibility_date].year)
      end

      def determine_who_qualifies_for_aptc_csr(affordability_threshold)
        if any_income_questions_unanswered? || check_for_married_filing_separate?
          update_all_members_as_aptc_ineligible
        else
          @affordability_threshold = affordability_threshold
          @tax_household.tax_household_members.each do |thhm|
            member_identifier = thhm.applicant_reference.person_hbx_id
            applicant = applicant_by_reference(member_identifier)
            aptc_hh_member = matching_aptc_member(member_identifier)
            next thhm if aptc_hh_member[:aptc_eligible] == false

            eligible = member_eligible_for_aptc_csr?(applicant)
            aptc_hh_member[:aptc_eligible] = eligible
            aptc_hh_member[:csr_eligible] = eligible
          end
        end

        Success(@aptc_household)
      end

      def update_all_members_as_aptc_ineligible
        @tax_household.tax_household_members.each do |thhm|
          member_identifier = thhm.applicant_reference.person_hbx_id
          aptc_hh_member = matching_aptc_member(member_identifier)
          aptc_hh_member[:aptc_eligible] = false
          aptc_hh_member[:csr_eligible] = false
        end
      end

      # Check if all applying members answered income driver questions.
      def any_income_questions_unanswered?
        @tax_household.tax_household_members.any? do |thhm|
          applicant = applicant_by_reference(thhm.applicant_reference.person_hbx_id)
          [applicant.has_job_income,
           applicant.has_self_employment_income,
           applicant.has_unemployment_income,
           applicant.has_other_income].any?(&:nil?)
        end
      end

      # 'spouse' rela & Jointly: false, HeadOfHousehold: false
      # MarriedFilingSeparate
      def check_for_married_filing_separate?
        spouse_applicants_from_thh.any? do |appli|
          !appli.is_joint_tax_filing && !appli.is_filing_as_head_of_household
        end
      end

      def spouse_applicants_from_thh
        @tax_household.tax_household_members.inject([]) do |applis, thhm|
          appli = applicant_by_reference(thhm.applicant_reference.person_hbx_id)
          applis << appli if !appli.is_claimed_as_tax_dependent && @application.spouse_relationships(appli).present?
          applis
        end
      end

      def member_eligible_for_aptc_csr?(applicant)
        ped = find_matching_ped(applicant.person_hbx_id)

        applicant.is_applying_coverage &&
          tax_filer_is_state_resident? &&
          !applicant.incarcerated? &&
          applicant.lawfully_present_in_us? &&
          tax_filing?(applicant) &&
          medicaid_or_chip_check?(ped) &&
          !enrolled_in_other_coverage?(applicant) &&
          !eligible_for_other_coverage?(applicant) &&
          all_esi_affordable?(applicant) &&
          all_ichra_affordable?(applicant) &&
          all_qsehra_affordable?(applicant)
      end

      def all_esi_affordable?(applicant)
        return true unless applicant.has_eligible_health_coverage
        esi_benefits = applicant.eligible_benefit_esis
        return true if esi_benefits.blank?
        return true unless esi_benefits.any? { |benefit| benefit_coverage_covers?(benefit) }
        esi_benefits.select { |benefit| benefit_coverage_covers?(benefit) }.each do |esi_benefit|
          esi_rules_satisfied?(applicant, esi_benefit)
        end
      end

      def esi_rules_satisfied?(applicant, esi_benefit)
        esi_benefit.is_esi_mec_met &&
          waiting_period_rule_satisfied?(esi_benefit) &&
          determine_esi_benefit_affordability(applicant, esi_benefit)
      end

      def waiting_period_rule_satisfied?(esi_benefit)
        return true unless esi_benefit.is_esi_waiting_period
        esi_benefit.start_on <= @aptc_household[:eligibility_date]
      end

      def determine_esi_benefit_affordability(applicant, esi_benefit)
        employee_only_premium_amnt = esi_benefit.annual_employee_cost
        employee_premium_as_percent = (employee_only_premium_amnt / @aptc_household[:annual_tax_household_income]) * 100
        return true if employee_premium_as_percent > @affordability_threshold
        update_member_aptc_eligibility(applicant, esi_benefit)
        false
      end

      def update_member_aptc_eligibility(applicant, esi_benefit)
        case esi_benefit.esi_covered
        when 'self'
          aptc_hh_member = matching_aptc_member(applicant.person_hbx_id)
          aptc_hh_member[:aptc_eligible] = false
          aptc_hh_member[:csr_eligible] = false
        when 'self_and_spouse'
          aptc_hh_member = matching_aptc_member(applicant.person_hbx_id)
          aptc_hh_member[:aptc_eligible] = false
          aptc_hh_member[:csr_eligible] = false
          rels = @application.spouse_relationships(applicant)
          rels.each do |relation|
            spouse_member = matching_aptc_member(relation.applicant_reference.person_hbx_id)
            spouse_member[:aptc_eligible] = false
            spouse_member[:csr_eligible] = false
          end
        when 'family'
          update_all_members_as_aptc_ineligible
        end
      end

      def state_resident?(applicant)
        residential_address_in_state?(applicant) ||
          applicant.is_homeless ||
          temporarily_absent?(applicant)
      end

      # any member of the tax household may enroll in a QHP through any of the Exchanges for which one of the tax filers meets the residency standard
      def tax_filer_is_state_resident?
        tax_filer_applicants.any? {|applicant| residential_address_in_state?(applicant)}
      end

      def tax_filer_applicants
        @tax_household.tax_household_members.each_with_object([]) do |thhm, filers|
          member_identifier = thhm.applicant_reference.person_hbx_id
          applicant = applicant_by_reference(member_identifier)
          filers << applicant if applicant.tax_filer_kind == "tax_filer"
        end
      end

      def residential_address_in_state?(applicant)
        hme_address = applicant.home_address
        return false if hme_address.blank?

        hme_address.state == @application.us_state
      end

      def temporarily_absent?(applicant)
        applicant.is_temporarily_out_of_state
      end

      def tax_filing?(applicant)
        # To qualify for APTC/CSR, a consumer must plan to file taxes or be claimed as a tax dependent for the coverage year.
        eligible_tax_filer?(applicant) || eligible_tax_dependent?(applicant)
      end

      def medicaid_or_chip_check?(ped)
        # Eligible for APTC if ineligble for magi_medicaid or medicaid_chip
        !(ped.is_magi_medicaid || ped.is_medicaid_chip_eligible)
      end

      def enrolled_in_other_coverage?(applicant)
        return false if applicant.benefits.blank?
        enrolled_other_coverage_benefits = applicant.benefits.select do |benefit|
          benefit.status == 'is_enrolled' && ['medicaid', 'child_health_insurance_plan',
                                              'medicare', 'medicare_advantage', 'tricare', 'employer_sponsored_insurance',
                                              'health_reimbursement_arrangement', 'cobra',
                                              'retiree_health_benefits', 'veterans_administration_health_benefits',
                                              'peace_corps_health_benefits'].include?(benefit.kind)
        end
        enrolled_other_coverage_benefits.any? { |benefit| benefit_coverage_covers?(benefit) }
      end

      def eligible_for_other_coverage?(applicant)
        return false if applicant.benefits.blank?
        eligible_other_coverage_benefits = applicant.benefits.select do |benefit|
          benefit.status == 'is_eligible' && ['medicaid', 'child_health_insurance_plan',
                                              'medicare', 'medicare_advantage', 'tricare', 'retiree_health_benefits',
                                              'veterans_administration_health_benefits',
                                              'peace_corps_health_benefits'].include?(benefit.kind)
        end
        eligible_other_coverage_benefits.any? { |benefit| benefit_coverage_covers?(benefit) }
      end

      def benefit_coverage_covers?(benefit)
        eligibility_date = @aptc_household[:eligibility_date]
        start_on = benefit.start_on
        end_on = benefit.end_on || eligibility_date.end_of_year
        (start_on..end_on).cover? eligibility_date
      end

      def eligible_tax_filer?(applicant)
        return false if applicant.is_claimed_as_tax_dependent
        # If the consumer is married, they must be filing jointly or as head of household
        applicant.is_required_to_file_taxes ||
          (married?(applicant) && (applicant.is_joint_tax_filing || applicant.is_filing_as_head_of_household))
      end

      def married?(applicant)
        @application.spouse_relationships(applicant).present?
      end

      # If a member is tax dependent, then they are simply passes 'Tax filing status'
      def eligible_tax_dependent?(applicant)
        applicant.is_claimed_as_tax_dependent
      end

      def monthly_lcsp_premium(applicant)
        applicant.benchmark_premium.health_only_lcsp_premiums.detect do |member_premium|
          member_premium.member_identifier == applicant.person_hbx_id.to_s
        end.monthly_premium
      end

      def all_ichra_affordable?(applicant)
        monthly_premium = monthly_lcsp_premium(applicant)

        # TODO: Update ichra_benefits method correctly
        applicant.ichra_benefits.all? do |ichra_benefit|
          ichra_benefit_affordable?(ichra_benefit, monthly_premium)
        end
      end

      def ichra_benefit_affordable?(ichra_benefit, monthly_premium)
        employee_premium_amnt = ichra_benefit.annual_employee_cost
        net_premium = (monthly_premium * 12) - employee_premium_amnt
        net_premium_percent = (net_premium / @aptc_household[:annual_tax_household_income]) * 100
        return true if net_premium_percent > @affordability_threshold
        update_all_members_as_aptc_ineligible
        false
      end

      def all_qsehra_affordable?(applicant)
        monthly_premium = monthly_lcsp_premium(applicant)

        # TODO: Update qsehra_benefits method correctly
        applicant.qsehra_benefits.all? do |qsehra_benefit|
          qsehra_benefit_affordable?(qsehra_benefit, monthly_premium)
        end
      end

      def qsehra_benefit_affordable?(qsehra_benefit, monthly_premium)
        employee_premium_amnt = qsehra_benefit.annual_employee_cost
        net_premium = (monthly_premium * 12) - employee_premium_amnt
        net_premium_percent = (net_premium / @aptc_household[:annual_tax_household_income]) * 100
        return true if net_premium_percent > @affordability_threshold
        update_all_members_as_aptc_ineligible
        false
      end

      def applicant_by_reference(person_hbx_id)
        @application.applicants.detect do |applicant|
          applicant.person_hbx_id.to_s == person_hbx_id.to_s
        end
      end

      def matching_aptc_member(member_identifier)
        @aptc_household[:members].detect { |aptc_mem| aptc_mem[:member_identifier].to_s == member_identifier.to_s }
      end

      def find_matching_ped(member_identifier)
        @tax_household.tax_household_members.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == member_identifier.to_s
        end&.product_eligibility_determination
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end

# TODO
#   1. Update ichra_benefits method correctly
#   2. Update qsehra_benefits method correctly
