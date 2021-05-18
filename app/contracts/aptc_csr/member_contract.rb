# frozen_string_literal: true

module AptcCsr
  # Schema and validation rules for {AptcCsr::Member}
  class MemberContract < Dry::Validation::Contract
    # @!method call(opts)
    # @param [Hash] opts the parameters to validate using this contract
    # @option opts [Integer] :member_identifier required
    # @return [Dry::Monads::Result]
    params do
      required(:member_identifier).filled(:integer)
      required(:household_count).filled(:integer)
      optional(:annual_household_income_contribution).maybe(Types::Money)
      required(:tax_filer_status).filled(Types::TaxFilerKind)
      required(:medicaid_eligibility_category).filled(Types::MedicaidEligibilityCategory)
      required(:medicaid_fpl).filled(Types::FplKind)
      required(:is_applicant).filled(:bool)
      optional(:is_mec_eligible).maybe(:bool)
      optional(:benchmark_plan_monthly_premium_amount).maybe(Types::Money)
      optional(:aptc_eligible).maybe(:bool)
      required(:medicaid_eligible).filled(:bool)
    end
  end
end
