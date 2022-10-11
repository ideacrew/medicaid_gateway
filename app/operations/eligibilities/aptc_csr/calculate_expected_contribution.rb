# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  module AptcCsr
    # This Operation is to calculate expected contribution for a given TaxHousehold
    class CalculateExpectedContribution
      include Dry::Monads[:result, :do]

      def call(params)
        # { aptc_household: aptc_household }

        aptc_household = yield calculate_expected_contribution(params)

        Success(aptc_household)
      end

      private

      def calculate_expected_contribution(params)
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
    end
  end
end
