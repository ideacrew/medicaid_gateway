# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  module AptcCsr
    # This Operation is to compute the APTC and CSR values for a given TaxHousehold
    class ComputeAptcAndCsr
      include Dry::Monads[:result, :do]

      def call(params)
        # { tax_household: @tax_household,
        #   aptc_household: aptc_household,
        #   application: @application }

        aptc_household = yield calculate_expected_contribution(params)
        aptc_household = yield calculate_benchmark_plan_amount(aptc_household)
        aptc_household = yield calculate_aptc(aptc_household)
        aptc_household = yield calculate_csr(aptc_household)

        Success(aptc_household)
      end

      private

      def calculate_expected_contribution(params)
        @tax_household = params[:tax_household]
        @application = params[:application]
        aptc_household = params[:aptc_household]
        fpl_percentage = aptc_household[:fpl_percent]

        applicable_percentage =
          if fpl_percentage < 150
            BigDecimal('0')
          elsif fpl_percentage >= 150 && fpl_percentage < 200
            ((fpl_percentage - BigDecimal('150')) / BigDecimal('50')) * BigDecimal('2')
          elsif fpl_percentage >= 200 && fpl_percentage < 250
            (((fpl_percentage - BigDecimal('200')) / BigDecimal('50')) * BigDecimal('2')) + BigDecimal('2')
          elsif fpl_percentage >= 250 && fpl_percentage < 300
            (((fpl_percentage - BigDecimal('250')) / BigDecimal('50')) * BigDecimal('2')) + BigDecimal('4')
          elsif fpl_percentage >= 300 && fpl_percentage < 400
            (((fpl_percentage - BigDecimal('300')) / BigDecimal('100')) * BigDecimal('2.5')) + BigDecimal('6')
          else
            # covers 400 and above
            BigDecimal('8.5')
          end.div(BigDecimal('100'), 3)
        expected_contribution = aptc_household[:annual_tax_household_income] * applicable_percentage
        aptc_household[:total_expected_contribution_amount] = expected_contribution
        Success(aptc_household)
      end

      def calculate_benchmark_plan_amount(aptc_household)
        ::Eligibilities::AptcCsr::CalculateBenchmarkPlanAmount.new.call({ aptc_household: aptc_household,
                                                                          tax_household: @tax_household,
                                                                          application: @application })
      end

      def calculate_aptc(aptc_household)
        total_benchmark_amount = aptc_household[:total_benchmark_plan_monthly_premium_amount] * 12
        total_contribution_amount = aptc_household[:total_expected_contribution_amount]
        compared_result = total_benchmark_amount - total_contribution_amount
        aptc =
          if compared_result > 0
            correct_aptc_if_qsehra(compared_result, aptc_household) / 12
          else
            BigDecimal('0')
          end
        aptc_household[:maximum_aptc_amount] = aptc.round
        aptc_household[:is_aptc_calculated] = true
        Success(aptc_household)
      end

      def correct_aptc_if_qsehra(compared_result, aptc_household)
        amount = total_monthly_qsehra_amount(aptc_household)
        return compared_result if amount.zero?

        corrected_aptc = compared_result - amount
        corrected_aptc > 0 ? corrected_aptc : BigDecimal('0')
      end

      # Check qsehra for APTC eligible members only
      def total_monthly_qsehra_amount(aptc_household)
        aptc_eligible_members = aptc_household[:members].select do |member|
          member[:aptc_eligible] == true
        end
        aptc_eligible_members.inject(BigDecimal('0')) do |total, member|
          applicant = applicant_by_reference(member[:member_identifier])
          total + applicant.monthly_qsehra_amount
        end
      end

      def applicant_by_reference(person_hbx_id)
        @application.applicants.detect do |applicant|
          applicant.person_hbx_id.to_s == person_hbx_id.to_s
        end
      end

      def calculate_csr(aptc_household)
        aptc_household[:members].each do |member|
          next member if member[:csr_eligible] == false
          applicant = applicant_by_reference(member[:member_identifier])
          fpl_level = aptc_household[:fpl_percent]
          csr = find_csr(applicant, fpl_level)
          member[:csr] = csr
        end

        aptc_household[:csr_annual_income_limit] = calculate_csr_annual_income_limit(aptc_household)

        Success(aptc_household)
      end

      def calculate_csr_annual_income_limit(aptc_household)
        fpl = aptc_household[:fpl]
        2.5 * (fpl[:annual_poverty_guideline] * (fpl[:annual_per_person_amount] * fpl[:household_size]))
      end

      # def calculate_aptc_annual_income_limit(aptc_household)
      #   fpl = aptc_household[:fpl]
      #   2.5 * (fpl[:annual_poverty_guideline] * (fpl[:annual_per_person_amount] * fpl[:household_size]))
      # end

      # rubocop:disable Style/IfInsideElse
      def find_csr(applicant, fpl_level)
        if applicant.attested_for_aian?
          (fpl_level <= 300.0) ? '100' : 'limited'
        else
          if fpl_level <= 150
            '94'
          elsif fpl_level > 150 && fpl_level <= 200
            '87'
          elsif fpl_level > 200 && fpl_level <= 250
            '73'
          else
            '0'
          end
        end
      end
      # rubocop:enable Style/IfInsideElse
    end
  end
end

# Pending Tasks:
#   1. Any configuration for calculate_expected_contribution?
#   2. Any configuration for calculate_csr fpl_percentage range?
