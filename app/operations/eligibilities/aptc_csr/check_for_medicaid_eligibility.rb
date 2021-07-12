# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  module AptcCsr
    # This Operation is to check if all members are eligible for Medicaid
    class CheckForMedicaidEligibility
      include Dry::Monads[:result, :do]

      # @param [Hash] opts The options to check for MedicaidEligibility
      # @option opts [AcaEntities::MagiMedicaid::TaxHoushold] :magi_medicaid_tax_household
      # @option opts [AcaEntities::MagiMedicaid::Application] :magi_medicaid_application(includes MAGI Medicaid Deteminations)
      # @return [Dry::Result]
      # This class is PRIVATE. Can only be called from AptcCsr::DetermineEligibility
      def call(params)
        # { tax_household: @tax_household,
        #   application: @application }
        aptc_household = yield calculate_thh_size(params)
        aptc_household = yield calculate_annual_income(aptc_household)
        aptc_household = yield calculate_fpl(aptc_household)
        aptc_household = yield determine_medicaid_eligibility(aptc_household)

        Success(aptc_household)
      end

      private

      def calculate_thh_size(params)
        @application = params[:application]
        @tax_household = params[:tax_household]

        thhms = @tax_household.tax_household_members.inject([]) do |members, thhm|
          applicant = applicant_by_reference(thhm.applicant_reference.person_hbx_id)
          members << { member_identifier: thhm.applicant_reference.person_hbx_id,
                       household_count: BigDecimal('1'),
                       tax_filer_status: applicant.tax_filer_kind,
                       magi_medicaid_eligible: thhm.product_eligibility_determination.is_magi_medicaid,
                       is_applicant: applicant.is_applying_coverage,
                       age_of_applicant: applicant.age_of_applicant }
          members
        end
        aptc_household = {
          members: thhms,
          assistance_year: @application.assistance_year,
          total_household_count: thhms.inject(0) { |sum, hash| sum + hash[:household_count] }
        }
        Success(aptc_household)
      end

      def applicant_by_reference(person_hbx_id)
        @application.applicants.detect do |applicant|
          applicant.person_hbx_id.to_s == person_hbx_id.to_s
        end
      end

      def calculate_annual_income(aptc_household)
        ::Eligibilities::AptcCsr::CalculateTaxHouseholdIncome.new.call({ application: @application,
                                                                         tax_household: @tax_household,
                                                                         aptc_household: aptc_household })
      end

      def calculate_fpl(aptc_household)
        ::Eligibilities::AptcCsr::CalculateFplPercentage.new.call({ application: @application,
                                                                    tax_household: @tax_household,
                                                                    aptc_household: aptc_household })
      end

      # Medicaid Gap Filling
      def determine_medicaid_eligibility(aptc_household)
        return Success(aptc_household) unless annual_income_less_than_100_percent_fpl?(aptc_household)

        @tax_household.tax_household_members.each do |thhm|
          member = member_by_reference(aptc_household, thhm.applicant_reference.person_hbx_id)
          check_and_update_magi_medicaid_eligibility(member, thhm)
        end

        Success(aptc_household)
      end

      def check_and_update_magi_medicaid_eligibility(member, thhm)
        applicant = applicant_by_reference(thhm.applicant_reference.person_hbx_id)

        if denied_due_to_income?(thhm) && !recent_medicaid_denial_or_termination?(applicant)
          member[:aptc_eligible] = false
          member[:magi_medicaid_eligible] = true
          member[:csr_eligible] = false
        elsif not_denied_due_to_income?(thhm) &&
              recent_medicaid_denial_or_termination?(applicant) &&
              not_denied_due_to_immigration?(applicant.medicaid_and_chip)
          member[:aptc_eligible] = false
          member[:magi_medicaid_eligible] = false
          member[:csr_eligible] = false
        end
      end

      def not_denied_due_to_immigration?(medicaid_and_chip)
        medicaid_and_chip[:ineligible_due_to_immigration_in_last_5_years] == false
      end

      def recent_medicaid_denial_or_termination?(applicant)
        return unless applicant.medicaid_and_chip
        date_for_comparision = Date.today - 90.days
        medicaid_or_chip_denial?(date_for_comparision, applicant.medicaid_and_chip) ||
          medicaid_or_chip_termination?(date_for_comparision, applicant.medicaid_and_chip)
      end

      def medicaid_or_chip_denial?(date_for_comparision, medicaid_and_chip)
        medicaid_and_chip[:not_eligible_in_last_90_days] &&
          medicaid_and_chip[:denied_on] &&
          date_for_comparision < medicaid_and_chip[:denied_on]
      end

      # Medicaid/Chip ended in the last 90 days without any HH Income or Size change.
      # As change in HH Income or Size triggers a new determination and hence no MedicaidGapFilling.
      def medicaid_or_chip_termination?(date_for_comparision, medicaid_and_chip)
        medicaid_and_chip[:ended_as_change_in_eligibility] &&
          !medicaid_and_chip[:hh_income_or_size_changed] &&
          date_for_comparision < medicaid_and_chip[:medicaid_or_chip_coverage_end_date]
      end

      # Checks if MagiMedicaid not denied due to income and we need not look at MedicaidChip
      def not_denied_due_to_income?(thhm)
        thhm.medicaid_cd_for_income&.indicator_code == true
      end

      # Checks if MagiMedicaid got denied due to income and we need not look at MedicaidChip
      def denied_due_to_income?(thhm)
        thhm.medicaid_cd_for_income&.indicator_code == false
      end

      # finds matching ::AptcCsr::Member
      def annual_income_less_than_100_percent_fpl?(aptc_household)
        annual_income = aptc_household[:annual_tax_household_income]
        fpl_data = aptc_household[:fpl]
        hh_annual_poverty_guideline = fpl_data[:annual_poverty_guideline] +
                                      ((aptc_household[:total_household_count] - 1) * fpl_data[:annual_per_person_amount])
        annual_income < hh_annual_poverty_guideline
      end

      # finds matching ::AptcCsr::Member
      def member_by_reference(aptc_household, person_hbx_id)
        aptc_household[:members].detect do |mmbr|
          mmbr[:member_identifier] == person_hbx_id.to_s
        end
      end
    end
  end
end
