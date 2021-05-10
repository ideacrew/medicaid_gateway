# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module MitcService
  # This class is for calculating APTC and CSR values for TaxHouseholds
  class CalculateAptcAndCsr
    include Dry::Monads[:result, :do]

    # @param [Hash] opts The options to determine additional determinations
    # @option opts [Hash] :params MitC eligibility response payload
    # @return [Dry::Monads::Result]
    def call(params)
      # 1. Check for Medicaid eligibility

      _medicaid_eligible = yield check_for_medicaid_eligibility(params)

      Success({})
    end

    private

    def check_for_medicaid_eligibility(params)
      medicaid_househod_size = calculate_medicaid_household_size(params)
      annual_income = calculate_annual_income(params)
      _value_to_compare_with_medicaid_fpl_levels = calculate_the_value_to_compare_with_medicaid_fpl_levels(params,
                                                                                                           annual_income,
                                                                                                           medicaid_househod_size)
      Success({})
    end

    def calculate_medicaid_household_size(_params)
      Success 1
      # TODO: Logic to calculate medicaid_household_size
    end

    def calculate_annual_income(_params)
      Success 40_000
      # BigDecimal(fpl[:annual_poverty_guideline].to_s).div(
      #   months_in_year,
      #   2
      # )
      # /12_880
      # TODO: Add logic to calculate annual income
    end

    def calculate_the_value_to_compare_with_medicaid_fpl_levels(_params, _annual_income, _medicaid_househod_size)
      Success 'asjhg'
    end

  end
end
