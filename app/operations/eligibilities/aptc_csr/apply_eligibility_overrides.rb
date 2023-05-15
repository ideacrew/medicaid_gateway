# frozen_string_literal: true

require "dry/monads"
require "dry/monads/do"

module Eligibilities
  module AptcCsr
    # This class determine the aptc and csr subsidies for a given TaxHousehold
    class ApplyEligibilityOverrides
      include Dry::Monads[:result, :do]

      # params are mm_app_with_member_determinations
      def call(params)
        result = yield apply_eligibility_overrides(params)
        Success(result)
      end

      def apply_eligibility_overrides(params)
        @mm_application = params[:magi_medicaid_application]
        mm_app_hash = mm_application.to_h
        mm_app_hash[:tax_households].each do |mm_thh|
          mm_thh[:tax_household_members].each do |thhm|
            if only_medicaid_ineligible_due_to_immigration?(tthm)
              thhm[:product_eligibility_determination][:is_magi_medicaid] = true if pregnancy_override?(thhm) || under_twenty_one_override?(thhm)
            elsif only_chip_ineligible_due_to_immigration?(thhm)
              chip_override = MedicaidRegistry[:eligibility_override].settings(:mitc_override_not_lawfully_present_chip_eligible).item
              tthm[:product_eligibility_determination][:is_medicaid_chip_eligible] = true if chip_override
            end
          end
        end
        ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(mm_app_hash)
      end

      def pregnancy_override?(thhm)
        is_pregnant = applicant_by_reference(thhm.applicant_reference.person_hbx_id)&.pregnancy_information&.is_pregnant
        is_pregnant && MedicaidGatewayRegistry[:eligibility_override].settings(:mitc_override_not_lawfully_present_pregnant).item
      end

      def under_twenty_one_override?(thhm)
        dob = thhm.applicant_reference.dob
        age = ((Time.zone.now - dob.to_time) / 1.year.seconds).floor
        age < 21 && MedicaidGatewayRegistry[:eligibility_override].settings(:mitc_override_not_lawfully_present_under_twenty_one).item
      end

      def applicant_by_reference(person_hbx_id)
        @mm_application.applicants.detect do |applicant|
          applicant.person_hbx_id.to_s == person_hbx_id.to_s
        end
      end

      def only_medicaid_ineligible_due_to_immigration?(thhm)
        ineligibility_reasons = thhm.product_eligibility_determination.magi_medicaid_ineligibility_reasons
        ineligibility_reasons&.include?("Applicant did not meet citizenship/immigration requirements") && ineligibility_reasons.count == 1
      end

      def only_chip_ineligible_due_to_immigration?(thhm)
        ineligibility_reasons = thhm.product_eligibility_determination.chip_ineligibility_reasons
        ineligibility_reasons&.include?("Applicant did not meet citizenship/immigration requirements") && ineligibility_reasons.count == 1
      end
    end
  end
end
