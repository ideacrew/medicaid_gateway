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
    end
  end
end

# TODO
#   1. Fix the Operation's name
#     This Operation is to calculate THH size, AnnualIncome and Fpl values
#     class CalculateThhSizeIncomeAndFpl
#     class CalculateTaxHouseholdLevelValues