# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module AptcCsr
  # This Operation is for finding the correct Income Threshold based on the input year
  class FindIncomeThreshold
    include Dry::Monads[:result, :do]

    # @param [Integer] The input year(integer) to find the income threshold
    # @return [Dry::Result]
    def call(year)
      year = yield validate_input(year)
      result = yield find_income_threshold(year)

      Success(result)
    end

    private

    def validate_input(year)
      # TODO: do we want to have a range of years which we support?
      if year.is_a?(Integer)
        Success(year)
      else
        Failure("Invalid input: #{year}, must be an year.")
      end
    end

    def find_income_threshold(year)
      income_threshold = Types::IncomeThresholds.detect do |i_threshold|
        i_threshold.keys.first == year
      end

      return Success(income_threshold[year]) if income_threshold.present?
      Failure("Cannot find Income Threshold for the given input year: #{year}.")
    end
  end
end

# Questions:
#   1. Do we want to have a range of years which we support?
#   2. Resource Registry configuration for IncomeThresholds
