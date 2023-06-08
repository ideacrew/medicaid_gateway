# frozen_string_literal: true

require "dry/monads"
require "dry/monads/do"

module Eligibilities
  module AptcCsr
    # This class applies eligibility overrides based on lawful presence
    class ApplyEligibilityOverrides
      include Dry::Monads[:result, :do]

      # @params [Hash] opts The options to apply eligibility overrides
      # @option opts [AcaEntities::MagiMedicaid::Application] :magi_medicaid_application
      # @return [Dry::Result]
      def call(params)
        @override_rules = ::AcaEntities::MagiMedicaid::Types::EligibilityOverrideRule.values
        valid_params = yield validate_params(params)
        app_with_member_determs = yield add_mdc_chip_member_determs(valid_params)
        result = yield apply_eligibility_overrides(app_with_member_determs)
        Success(result)
      end

      def validate_params(params)
        return Success(params) if params[:magi_medicaid_application].present?
        Failure("Invalid params -- magi_medicaid_application is missing in: #{params}")
      end

      def add_mdc_chip_member_determs(params)
        @mm_application = params[:magi_medicaid_application]
        mm_app_hash = @mm_application.to_h
        mm_app_hash[:tax_households].each do |mm_thh|
          mm_thh[:tax_household_members].each do |thhm|
            ped = thhm[:product_eligibility_determination]
            ped[:member_determinations] = [medicaid_chip_member_determination]
          end
        end
        Success(mm_app_hash)
      end

      def apply_eligibility_overrides(app_with_member_determs)
        app_with_member_determs[:tax_households].each do |mm_thh|
          mm_thh[:tax_household_members].each do |thhm|
            ped = thhm[:product_eligibility_determination]
            ped[:member_determinations] ||= [medicaid_chip_member_determination]
            @override_rules.each do |rule|
              apply_override_rule(thhm, ped, rule)
            end
          end
        end
        ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_with_member_determs)
      end

      def apply_override_rule(thhm, ped, rule)
        case rule
        when :not_lawfully_present_pregnant
          if medicaid_ineligible_due_to_immigration_only?(thhm) && pregnancy_override?(thhm)
            ped[:is_magi_medicaid] = true
            update_member_determ_for(thhm, rule)
          end
        when :not_lawfully_present_under_twenty_one
          if medicaid_ineligible_due_to_immigration_only?(thhm) && nineteen_to_twenty_one_override?(thhm)
            ped[:is_magi_medicaid] = true
            update_member_determ_for(thhm, rule)
          end
        when :not_lawfully_present_chip_eligible
          if medicaid_ineligible_due_to_immigration_only?(thhm) && under_eighteen_chip_override?(thhm)
            ped[:is_medicaid_chip_eligible] = true
            update_member_determ_for(thhm, rule)
          end
        end
      end

      def pregnancy_override?(thhm)
        is_pregnant = applicant_by_reference(thhm[:applicant_reference][:person_hbx_id])&.pregnancy_information&.is_pregnant
        is_pregnant && MedicaidGatewayRegistry[:eligibility_override].settings(:mitc_override_not_lawfully_present_pregnant).item
      end

      def nineteen_to_twenty_one_override?(thhm)
        age = applicant_by_reference(thhm[:applicant_reference][:person_hbx_id])&.age_of_applicant
        nineteen_to_twenty_one = age > 18 && age < 21
        nineteen_to_twenty_one && MedicaidGatewayRegistry[:eligibility_override].settings(:mitc_override_not_lawfully_present_under_twenty_one).item
      end

      def under_eighteen_chip_override?(thhm)
        age = applicant_by_reference(thhm[:applicant_reference][:person_hbx_id])&.age_of_applicant
        age < 19 && MedicaidGatewayRegistry[:eligibility_override].settings(:mitc_override_not_lawfully_present_chip_eligible).item
      end

      def applicant_by_reference(person_hbx_id)
        @mm_application.applicants.detect do |applicant|
          applicant.person_hbx_id.to_s == person_hbx_id.to_s
        end
      end

      def medicaid_ineligible_due_to_immigration_only?(thhm)
        ineligibility_reasons = thhm[:product_eligibility_determination][:magi_medicaid_ineligibility_reasons]
        ineligibility_reasons&.include?("Applicant did not meet citizenship/immigration requirements") && ineligibility_reasons.count == 1
      end

      def chip_ineligible_due_to_immigration_only?(thhm)
        ineligibility_reasons = thhm[:product_eligibility_determination][:chip_ineligibility_reasons]
        ineligibility_reasons&.include?("Applicant did not meet citizenship/immigration requirements") && ineligibility_reasons.count == 1
      end

      def medicaid_chip_member_determination
        {
          kind: 'Medicaid/CHIP Determination',
          criteria_met: false,
          determination_reasons: [],
          eligibility_overrides: eligibility_overrides
        }
      end

      def eligibility_overrides
        @override_rules.map do |rule|
          {
            override_rule: rule,
            override_applied: false
          }
        end
      end

      def update_member_determ_for(thhm, rule)
        member_determs = thhm.dig(:product_eligibility_determination, :member_determinations)
        mdc_chip_determ = member_determs&.detect {|md| md[:kind] == 'Medicaid/CHIP Determination' }
        mdc_chip_determ[:criteria_met] = true
        mdc_chip_determ[:determination_reasons] << rule
        set_override_rule_applied(mdc_chip_determ[:eligibility_overrides], rule)
        mdc_chip_determ
      end

      def set_override_rule_applied(overrides, rule)
        override = overrides.detect {|ov| ov[:override_rule] == rule }
        override[:override_applied] = true
      end
    end
  end
end
