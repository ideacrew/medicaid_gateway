# frozen_string_literal: true

require "dry/monads"
require "dry/monads/do"

module Eligibilities
  module AptcCsr
    # This class applies eligibility overrides based on lawful presence
    class ApplyEligibilityOverrides
      include Dry::Monads[:result, :do]

      # params are mm_app_with_member_determinations
      def call(params)
        result = yield apply_eligibility_overrides(params)
        Success(result)
      end

      def apply_eligibility_overrides(params) # rubocop:disable Metrics/MethodLength
        @mm_application = params[:magi_medicaid_application]
        mm_app_hash = @mm_application.to_h
        mm_app_hash[:tax_households].each do |mm_thh|
          mm_thh[:tax_household_members].each do |thhm|
            ped = thhm[:product_eligibility_determination]
            ped[:member_determinations] ||= []
            if medicaid_ineligible_due_to_immigration_only?(thhm)
              if pregnancy_override?(thhm)
                ped[:is_magi_medicaid] = true
                ped[:member_determinations] << member_determ_for(thhm, :mitc_override_not_lawfully_present_pregnant)
              end
              if nineteen_to_twenty_one_override?(thhm)
                ped[:is_magi_medicaid] = true
                ped[:member_determinations] << member_determ_for(thhm, :mitc_override_not_lawfully_present_under_twenty_one)
              end
            elsif chip_ineligible_due_to_immigration_only?(thhm)
              if pregnancy_override?(thhm)
                ped[:is_magi_medicaid] = true
                ped[:member_determinations] << member_determ_for(thhm, :mitc_override_not_lawfully_present_pregnant)
              end
              if under_eighteen_chip_override?(thhm)
                ped[:is_medicaid_chip_eligible] = true
                ped[:member_determinations] << member_determ_for(thhm, :mitc_override_not_lawfully_present_chip_eligible)
              end
            end
          end
        end
        ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(mm_app_hash)
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

      def member_determ_for(thhm, determ_reason)
        member_determs = thhm.dig(:product_eligibility_determination, :member_determinations)
        mdc_chip_determ = member_determs&.detect {|md| md[:kind] == 'Medicaid/CHIP Determination' }
        if mdc_chip_determ.present?
          mdc_chip_determ[:determination_reasons] << determ_reason
        else
          {
            kind: 'Medicaid/CHIP Determination',
            is_eligible: true,
            determination_reasons: [determ_reason]
          }
        end
      end
    end
  end
end
