# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

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

    # rubocop:disable Metrics/CyclomaticComplexity
    def calculate_expected_contribution(params)
      @tax_household = params[:tax_household]
      @application = params[:application]
      aptc_household = params[:aptc_household]
      fpl_percentage = aptc_household[:fpl_percent]

      applicable_percentage =
        if fpl_percentage < 133 || (fpl_percentage >= 133 && fpl_percentage < 150)
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
          BigDecimal('8.5')
        end.floor(2)

      expected_contribution = aptc_household[:annual_tax_household_income] * applicable_percentage
      aptc_household[:total_expected_contribution_amount] = expected_contribution
      Success(aptc_household)
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def calculate_benchmark_plan_amount(aptc_household)
      ::AptcCsr::CalculateBenchmarkPlanAmount.new.call({ aptc_household: aptc_household,
                                                         tax_household: @tax_household,
                                                         application: @application })
    end

    def calculate_aptc(aptc_household)
      total_benchmark_amount = aptc_household[:total_benchmark_plan_monthly_premium_amount] * 12
      total_contribution_amount = aptc_household[:total_expected_contribution_amount]
      compared_result = total_benchmark_amount - total_contribution_amount
      aptc = (compared_result > 0) ? (compared_result / 12) : 0
      aptc_household[:maximum_aptc_amount] = aptc
      Success(aptc_household)
    end

    def calculate_csr(aptc_household)
      fpl_percentage = aptc_household[:fpl_percent]
      aptc_household[:csr_percentage] = if fpl_percentage <= 150
                                          94
                                        elsif fpl_percentage > 150 && fpl_percentage <= 200
                                          87
                                        elsif fpl_percentage > 200 && fpl_percentage <= 250
                                          73
                                        else
                                          0
                                        end

      Success(aptc_household)
    end
  end
end
