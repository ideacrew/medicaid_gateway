# frozen_string_literal: true

require 'types'

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
    # @option opts [BigDecimal] :benchmark_plan_monthly_premium_amount optional
    # @option opts [Integer] :age_of_applicant required
    # @option opts [Bool] :aptc_eligible optional
    # @option opts [Bool] :totally_ineligible optional
    # @option opts [Bool] :uqhp_eligible optional
    # @option opts [Bool] :magi_medicaid_eligible optional
    # @option opts [Bool] :csr_eligible optional
    # @option opts [String] :csr optional
    # @return [Dry::Monads::Result]
    params do
      required(:member_identifier).filled(:string)
      required(:household_count).filled(:integer)
      optional(:annual_household_income_contribution).maybe(::Types::Money)
      required(:tax_filer_status).filled(Types::TaxFilerKind)
      required(:is_applicant).filled(:bool)
      optional(:benchmark_plan_monthly_premium_amount).maybe(::Types::Money)
      required(:age_of_applicant).maybe(:integer)

      optional(:aptc_eligible).maybe(:bool)
      optional(:totally_ineligible).maybe(:bool)
      optional(:uqhp_eligible).maybe(:bool)
      optional(:magi_medicaid_eligible).maybe(:bool)
      optional(:csr_eligible).maybe(:bool)

      optional(:csr).maybe(Types::CsrKind)

      optional(:member_determinations).array(MemberDeterminationContract.params)
    end

    rule do
      if more_than_one_determination?(values)
        msg = 'Member is eligible for more than one eligibilities:'\
              ' [:aptc_eligible, :totally_ineligible, :uqhp_eligible]'
        base.failure(msg)
      end
    end

    def more_than_one_determination?(values)
      [values[:aptc_eligible], values[:totally_ineligible], values[:uqhp_eligible]].count(true) > 1
    end

    rule(:csr) do
      key.failure('csr is expected when member is csr eligible') if values[:csr_eligible] && value.blank?
    end
  end
end
