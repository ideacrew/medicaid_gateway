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
          mm_thh[:tax_household_members].each do |mm_thhm|
            applicant = applicant_by_reference(thhm.applicant_reference.person_hbx_id)
            if only_medicaid_ineligible_due_to_immigration(tthm)
              if applicant.pregnancy_information&.is_pregnant || member_under_twenty_one(tthm)
                thhm[:product_eligibility_determination][:is_magi_medicaid] = true
              end
            elsif only_chip_ineligible_due_to_immigration(tthm)
              tthm[:product_eligibility_determination][:is_medicaid_chip_eligible] = true
            end
          end
        end
        ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(mm_app_hash)
      end

      def applicant_by_reference(person_hbx_id)
        @mm_application.applicants.detect do |applicant|
          applicant.person_hbx_id.to_s == person_hbx_id.to_s
        end
      end

      def member_under_twenty_one(thhm)
        dob = thhm.applicant_reference.dob
        age = ((Time.zone.now - dob.to_time) / 1.year.seconds).floor
        return age < 21
      end

      def only_medicaid_ineligible_due_to_immigration(tthm)
        ineligibility_reasons = tthm.product_eligibility_determination.magi_medicaid_ineligibility_reasons
        ineligibility_reasons&.include?("Applicant did not meet citizenship/immigration requirements") && ineligibility_reasons.count == 1
      end

      def only_chip_ineligible_due_to_immigration(tthm)
        ineligibility_reasons = tthm.product_eligibility_determination.chip_ineligibility_reasons
        ineligibility_reasons&.include?("Applicant did not meet citizenship/immigration requirements") && ineligibility_reasons.count == 1
      end
    end
  end
end
