# frozen_string_literal: true

require 'types'
require 'aca_entities/magi_medicaid/contracts/create_federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/contracts/federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/federal_poverty_level'
require 'aca_entities/operations/magi_medicaid/create_federal_poverty_level'

module AptcCsr
  # Schema and validation rules for {AptcCsr::AptcHousehold}
  class AptcHouseholdContract < Dry::Validation::Contract
    # @!method call(opts)
    # @param [Hash] opts the parameters to validate using this contract
    # @option opts [Integer] :total_household_count required
    # @option opts [BigDecimal] :csr_annual_income_limit optional
    # @return [Dry::Monads::Result]
    params do
      required(:total_household_count).filled(:integer)
      required(:annual_tax_household_income).filled(::Types::Money)
      optional(:csr_annual_income_limit).maybe(::Types::Money)
      optional(:is_aptc_calculated).maybe(:bool)
      optional(:maximum_aptc_amount).maybe(::Types::Money)
      optional(:total_expected_contribution_amount).maybe(::Types::Money)
      optional(:total_benchmark_plan_monthly_premium_amount).maybe(::Types::Money)
      required(:assistance_year).filled(:integer)
      required(:fpl).filled(::AcaEntities::MagiMedicaid::Contracts::FederalPovertyLevelContract.params)
      required(:fpl_percent).filled(::Types::Money)
      optional(:benchmark_calculation_members).array(BenchmarkCalculationMemberContract.params)
      required(:members).array(MemberContract.params)
      optional(:tax_household_identifier).maybe(:string)

      required(:eligibility_date).filled(:date)
    end

    rule(:members).each do |index:|
      if key? && value
        if value.is_a?(Hash)
          result = MemberContract.new.call(value)
          key([:members, index]).failure(text: 'invalid member', error: result.errors.to_h) if result&.failure?
        else
          key([:members, index]).failure(text: 'invalid members. Expected a hash.')
        end
      end
    end
  end
end
