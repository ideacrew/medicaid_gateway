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
        # aptc_household = yield compare_with_medicaid_fpl_levels(aptc_household)

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
                      is_applicant: applicant.is_applying_coverage }
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

      # def compare_with_medicaid_fpl_levels(aptc_household)
      #   @tax_household.tax_household_members.each do |thhm|
      #     appli_identifier = thhm.applicant_reference.person_hbx_id
      #     mec, medicaid_fpl = medicaid_eligibility_category_and_fpl(thhm.product_eligibility_determination.magi_medicaid_category)
      #     aptc_household[:members].each do |aptc_member|
      #       next unless aptc_member[:member_identifier] == appli_identifier
      #       medicaid_eligible = medicaid_fpl >= aptc_household[:fpl_percent]
      #       # Do we want to populate MedicaidEligibility in MedicaidGateway Engine?
      #       aptc_member.merge!({ medicaid_eligibility_category: mec,
      #                            medicaid_fpl: medicaid_fpl,
      #                            medicaid_eligible: medicaid_eligible,
      #                            aptc_eligible: medicaid_eligible ? false : nil })
      #     end
      #   end

      #   aptc_household[:are_all_members_medicaid_eligible] = aptc_household[:members].all? { |mem| mem[:medicaid_eligible] }
      #   Success(aptc_household)
      # end

      # def medicaid_eligibility_category_and_fpl(value)
      #   mec = Types::MedicaidEligibilityCategoriesMap.detect do |_mec_key, mec_value|
      #     mec_value[:mitc_key] == value
      #   end
      #   [mec.first, mec.second[:medicaid_fpl_percentage]]
      # end
    end
  end
end

# Pending Tasks:
#   1. calculate_annual_income
#   2. Do we want to populate MedicaidEligibility in MedicaidGateway Engine?
#   3. Check with Sarah about finding the correct FPL(Open Enrollment)
#   4. Fix the annual_income
