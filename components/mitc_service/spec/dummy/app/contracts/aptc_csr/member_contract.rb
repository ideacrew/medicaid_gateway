# frozen_string_literal: true

module AptcCsr
  # Schema and validation rules for {AptcCsr::Member}
  class MemberContract < Dry::Validation::Contract
    # @!method call(opts)
    # @param [Hash] opts the parameters to validate using this contract
    # @option opts [String] :member_identifier required
    # @option opts [Integer] :household_count required
    # @option opts [BigDecimal] :annual_household_income_contribution optional
    # @option opts [String] :tax_filer_status required
    # @option opts [Bool] :is_applicant required
    # @option opts [Bool] :is_mec_eligible optional
    # @option opts [BigDecimal] :benchmark_plan_monthly_premium_amount optional
    # @option opts [Bool] :aptc_eligible optional
    # @option opts [Bool] :totally_ineligible optional
    # @option opts [Bool] :uqhp_eligible optional
    # @option opts [Bool] :csr_eligible optional
    # @option opts [String] :csr optional
    # @return [Dry::Monads::Result]
    params do
      required(:member_identifier).filled(:string)
      required(:household_count).filled(:integer)
      optional(:annual_household_income_contribution).maybe(Types::Money)
      required(:tax_filer_status).filled(Types::TaxFilerKind)
      required(:is_applicant).filled(:bool)
      optional(:is_mec_eligible).maybe(:bool)
      optional(:benchmark_plan_monthly_premium_amount).maybe(Types::Money)

      optional(:aptc_eligible).maybe(:bool)
      optional(:totally_ineligible).maybe(:bool)
      optional(:uqhp_eligible).maybe(:bool)
      optional(:csr_eligible).maybe(:bool)

      optional(:csr).maybe(Types::CsrKind)
    end
  end
end
