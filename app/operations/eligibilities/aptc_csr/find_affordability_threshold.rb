# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  module AptcCsr
    # This Operation is for fetching the Affordability Threshold(Required Contribution Percentage) based on the input year.
    class FindAffordabilityThreshold
      include Dry::Monads[:result, :do]

      # @param [Integer] The input year(integer) to find the affordability threshold
      # @return [Dry::Result]
      def call(year)
        year = yield validate_input(year)
        result = yield find_affordability_threshold(year)

        Success(result)
      end

      private

      def validate_input(year)
        if year.is_a?(Integer)
          Success(year)
        else
          Failure("Invalid input: #{year}, must be an year.")
        end
      end

      def find_affordability_threshold(year)
        affordability_threshold = Types::AffordabilityThresholds.detect do |aff_threshold|
          aff_threshold.keys.first == year
        end

        return Success(affordability_threshold[year]) if affordability_threshold.present?
        Failure("Cannot find Affordability Threshold for the given input year: #{year}.")
      end
    end
  end
end
