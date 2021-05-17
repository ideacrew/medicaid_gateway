# frozen_string_literal: true

module AptcCsr
  # Schema and validation rules for {AptcCsr::AptcHousehold}
  class AptcHouseholdContract < Dry::Validation::Contract
    # @!method call(opts)
    # @param [Hash] opts the parameters to validate using this contract
    # @option opts [Integer] :total_household_count required
    # @return [Dry::Monads::Result]
    params do
      required(:total_household_count).filled(:integer)
      required(:annual_tax_household_income).filled(Types::Money)
      required(:are_all_members_medicaid_eligible).filled(:bool)
      optional(:is_aptc_calculated).maybe(:bool)
      optional(:maximum_aptc_amount).maybe(Types::Money)
      optional(:total_expected_contribution_amount).maybe(Types::Money)
      required(:total_benchmark_plan_monthly_premium_amount).filled(Types::Money)
      optional(:csr_percentage).maybe(:integer)
      required(:assistance_year).filled(:integer)
      required(:fpl_percent).filled(Types::Money)
      optional(:aptc_calculation_members).array(AptcCalculationMemberContract.params)
      required(:members).array(MemberContract.params)
    end
  end
end