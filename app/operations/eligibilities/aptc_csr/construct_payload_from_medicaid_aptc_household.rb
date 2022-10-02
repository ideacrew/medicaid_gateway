# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  module AptcCsr
    # This operation is to construct AptcHousehold Enti
    class InitAptcHousehold
      include Dry::Monads[:result, :do]

      def call(aptc_household_params)
        aptc_household = yield validate_aptc_household(aptc_household_params)
        aptc_household_entity = yield init_aptc_household(aptc_household)

        Success(aptc_household_entity)
      end

      private

      def validate_aptc_household(aptc_household_params)
        result = ::AptcCsr::AptcHouseholdContract.new.call(aptc_household_params)
        if result.success?
          Success(result.to_h)
        else
          Failure(result)
        end
      end

      def init_aptc_household(aptc_household)
        Success(::AptcCsr::AptcHousehold.new(aptc_household))
      end
    end
  end
end
