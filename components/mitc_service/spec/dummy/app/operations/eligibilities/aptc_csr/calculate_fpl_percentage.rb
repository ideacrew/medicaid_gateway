# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  module AptcCsr
    # This Operation is for calculating the fpl_percentage
    # for the given TaxHousehold that is used to compute APTC
    class CalculateFplPercentage
      include Dry::Monads[:result, :do]

      # @param [Hash] opts The options to calculate the fpl_percentage
      # @option opts [AcaEntities::MagiMedicaid::TaxHoushold] :magi_medicaid_tax_household
      # @option opts [AcaEntities::MagiMedicaid::Application] :magi_medicaid_application
      # @option opts [Hash] :aptc_household
      # @return [Dry::Result]
      # This class is PRIVATE. Can only be called from AptcCsr::CheckForMedicaidEligibility
      def call(params)
        # { application: @application,
        #   tax_household: @tax_household,
        #   aptc_household: aptc_household }
        fpl_data, aptc_household = yield calculate_fpl_percent(params)
        fpl_entity = yield init_fpl_entity(fpl_data, aptc_household)
        aptc_household = yield add_fpl_info_to_aptc_household(fpl_entity, aptc_household)

        Success(aptc_household)
      end

      private

      def calculate_fpl_percent(params)
        @application = params[:application]
        @tax_household = params[:tax_household]
        aptc_household = params[:aptc_household]
        fpl_year = find_fpl_year

        fpl_data = ::Types::FederalPovertyLevels.detect do |fpl_hash|
          fpl_hash[:medicaid_year] == fpl_year
        end
        total_annual_poverty_guideline = fpl_data[:annual_poverty_guideline] +
                                         ((aptc_household[:total_household_count] - 1) * fpl_data[:annual_per_person_amount])
        fpl_percent = aptc_household[:annual_tax_household_income].div(total_annual_poverty_guideline, 0) * 100
        aptc_household[:fpl_percent] = fpl_percent.floor(2)
        Success([fpl_data, aptc_household])
      end

      # FplYear is always previous year irrespective of when the User is applying for assistance
      def find_fpl_year
        @application.assistance_year - 1
      end

      def init_fpl_entity(fpl_data, aptc_household)
        input_data = { state_code: @application.us_state,
                       household_size: aptc_household[:total_household_count],
                       medicaid_year: @application.assistance_year,
                       annual_poverty_guideline: fpl_data[:annual_poverty_guideline],
                       annual_per_person_amount: fpl_data[:annual_per_person_amount] }
        ::AcaEntities::Operations::MagiMedicaid::CreateFederalPovertyLevel.new.call(input_data)
      end

      def add_fpl_info_to_aptc_household(fpl_entity, aptc_household)
        aptc_household[:fpl] = fpl_entity.to_h
        Success(aptc_household)
      end
    end
  end
end
