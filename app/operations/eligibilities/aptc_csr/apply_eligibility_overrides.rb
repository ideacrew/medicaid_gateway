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

      def apply_eligibility_overrides(params)
        @mm_application = params[:magi_medicaid_application]
        mm_app_hash = @mm_application.to_h
        mm_app_hash[:tax_households].each do |mm_thh|
          mm_thh[:tax_household_members].each do |thhm|
            if only_medicaid_ineligible_due_to_immigration?(thhm) && (pregnancy_override?(thhm) || nineteen_to_twenty_one_override?(thhm))
              thhm[:product_eligibility_determination][:is_magi_medicaid] = true
            elsif only_chip_ineligible_due_to_immigration?(thhm) && under_eighteen_chip_override?(thhm)
              thhm[:product_eligibility_determination][:is_medicaid_chip_eligible] = true
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
        age = age(thhm)
        nineteen_to_twenty_one = age > 18 && age < 21
        nineteen_to_twenty_one && MedicaidGatewayRegistry[:eligibility_override].settings(:mitc_override_not_lawfully_present_under_twenty_one).item
      end

      def under_eighteen_chip_override?(thhm)
        age(thhm) < 19 && MedicaidGatewayRegistry[:eligibility_override].settings(:mitc_override_not_lawfully_present_chip_eligible).item
      end

      def age(thhm)
        dob = applicant_by_reference(thhm[:applicant_reference][:person_hbx_id])&.demographic&.dob
        ((Time.zone.now - dob.to_time) / 1.year.seconds).floor
      end

      def applicant_by_reference(person_hbx_id)
        @mm_application.applicants.detect do |applicant|
          applicant.person_hbx_id.to_s == person_hbx_id.to_s
        end
      end

      def only_medicaid_ineligible_due_to_immigration?(thhm)
        ineligibility_reasons = thhm[:product_eligibility_determination][:magi_medicaid_ineligibility_reasons]
        ineligibility_reasons&.include?("Applicant did not meet citizenship/immigration requirements") && ineligibility_reasons.count == 1
      end

      def only_chip_ineligible_due_to_immigration?(thhm)
        ineligibility_reasons = thhm[:product_eligibility_determination][:chip_ineligibility_reasons]
        ineligibility_reasons&.include?("Applicant did not meet citizenship/immigration requirements") && ineligibility_reasons.count == 1
      end
    end
  end
end
