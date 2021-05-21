# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module AptcCsr
  # This Operation is to compute the APTC and CSR values for a given TaxHousehold
  class DetermineEligibleMembers
    include Dry::Monads[:result, :do]

    def call(params)
      # { tax_household: @tax_household,
      #   aptc_household: aptc_household,
      #   application: @application }
      affordability_threshold = yield find_affordability_threshold(params)
      aptc_household = yield determine_who_qualifies_for_aptc_csr(affordability_threshold)

      Success(aptc_household)
    end

    private

    def find_affordability_threshold(params)
      @application = params[:application]
      @tax_household = params[:tax_household]
      @aptc_household = params[:aptc_household]

      AptcCsr::FindAffordabilityThreshold.new.call(@aptc_household[:eligibility_date].year)
    end

    def determine_who_qualifies_for_aptc_csr(affordability_threshold)
      if any_missing_incomes?
        update_all_members_as_ineligible
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

    def update_all_members_as_ineligible
      @tax_household.tax_household_members.each do |thhm|
        member_identifier = thhm.applicant_reference.person_hbx_id
        aptc_hh_member = matching_aptc_member(member_identifier)
        aptc_hh_member[:aptc_eligible] = false
        aptc_hh_member[:csr_eligible] = false
      end
    end

    def any_missing_incomes?
      @tax_household.tax_household_members.any? do |thhm|
        applicant = applicant_by_reference(thhm.applicant_reference.person_hbx_id)
        applicant.incomes.blank?
      end
    end

    def member_eligible_for_aptc_csr?(applicant)
      applicant.is_applying_coverage &&
        state_resident?(applicant) &&
        !applicant.incarcerated? &&
        applicant.lawfully_present_in_us? &&
        tax_filing?(applicant) &&
        medicaid_or_chip_check? &&
        !enrolled_in_other_coverage? &&
        !eligible_for_other_coverage? &&
        esi_affordable?(applicant) &&
        ichra_affordable?(applicant) &&
        qsehra_affordable?(applicant)
    end

    def esi_affordable?(applicant)
      return true unless applicant.has_eligible_health_coverage
      esi_benefits = eligible_benefit_esis
      return true if esis.blank?

      esi_benefits.all? do |esi_benefit|
        esi_rules_satisfied?(applicant, esi_benefit)
      end
    end

    def esi_rules_satisfied?(esi_benefit)
      esi_benefit.is_esi_mec_met &&
        waiting_period_rule_satisfied?(esi_benefit) &&
        determine_affordability(applicant, esi_benefit)
    end

    def waiting_period_rule_satisfied?(esi_benefit)
      return true unless esi_benefit.is_esi_waiting_period
      esi_benefit.start_on <= @aptc_household[:eligibility_date]
    end

    def determine_affordability(applicant, esi_benefit)
      employee_only_premium_amnt = esi_benefit.annual_employee_cost
      employee_premium_as_percent = employee_only_premium_amnt / @aptc_household[:annual_tax_household_income]
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
        update_all_members_as_ineligible
      end
    end

    # TODO
    def state_resident?(_applicant)
      true
    end

    def tax_filing?(applicant)
      eligible_tax_filer?(applicant) || eligible_tax_dependent?(applicant)
    end

    # TODO
    def medicaid_or_chip_check?
      true
    end

    # TODO
    def enrolled_in_other_coverage?
      false
    end

    # TODO
    def eligible_for_other_coverage?
      false
    end

    def eligible_tax_filer?(applicant)
      return false if applicant.is_claimed_as_tax_dependent
      applicant.is_joint_tax_filing || (married?(applicant) && applicant.is_primary_applicant)
    end

    def married?(applicant)
      @application.spouse_relationships(applicant).present?
    end

    def eligible_tax_dependent?(applicant)
      claiming_applicant_identifier = applicant.claimed_as_tax_dependent_by.person_hbx_id
      claiming_applicant = applicant_by_reference(claiming_applicant_identifier)
      claiming_applicant.incomes.present?
    end

    # TODO
    def ichra_affordable?(_applicant)
      true
    end

    # TODO
    def qsehra_affordable?(_applicant)
      true
    end

    def applicant_by_reference(person_hbx_id)
      @application.applicants.detect do |applicant|
        applicant.person_hbx_id.to_s == person_hbx_id.to_s
      end
    end

    def matching_aptc_member(member_identifier)
      @aptc_household[:members].detect { |aptc_mem| aptc_mem[:member_identifier].to_s == member_identifier.to_s }
    end
  end
end