# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  module AptcCsr
    module Transformers
      module MedicaidAptcHouseholdTo
        # This transformer is used to transform ::Medicaid::AptcHousehold to ::AptcCsr::AptcHouseholdContract
        class AptcHouseholdContractParams
          include Dry::Monads[:result, :do]

          def call(medicaid_aptc_household)
            input_payload = yield construct_payload(medicaid_aptc_household)
            validated_params = yield validate_params(input_payload)

            Success(validated_params)
          end

          private

          def construct_payload(medicaid_aptc_household)
            input_payload = {
              total_household_count: medicaid_aptc_household.total_household_count,
              annual_tax_household_income: medicaid_aptc_household.annual_tax_household_income,
              csr_annual_income_limit: medicaid_aptc_household.csr_annual_income_limit,
              is_aptc_calculated: medicaid_aptc_household.is_aptc_calculated,
              maximum_aptc_amount: medicaid_aptc_household.maximum_aptc_amount,
              total_expected_contribution_amount: medicaid_aptc_household.total_expected_contribution_amount,
              total_benchmark_plan_monthly_premium_amount: medicaid_aptc_household.total_benchmark_plan_monthly_premium_amount,
              assistance_year: medicaid_aptc_household.assistance_year,
              fpl: construct_fpl_payload(medicaid_aptc_household.fpl),
              fpl_percent: medicaid_aptc_household.fpl_percent,
              benchmark_calculation_members: construct_benchmark_calculation_members(
                medicaid_aptc_household.benchmark_calculation_members
              ),
              members: construct_members_payload(medicaid_aptc_household.aptc_household_members),
              eligibility_date: medicaid_aptc_household.eligibility_date
            }

            Success(input_payload)
          end

          def construct_fpl_payload(fpl)
            {
              state_code: fpl[:state_code],
              household_size: fpl[:household_size],
              medicaid_year: fpl[:medicaid_year],
              annual_poverty_guideline: fpl[:annual_poverty_guideline],
              annual_per_person_amount: fpl[:annual_per_person_amount],
              monthly_poverty_guideline: fpl[:monthly_poverty_guideline],
              monthly_per_person_amount: fpl[:monthly_per_person_amount],
              aptc_effective_start_on: fpl[:aptc_effective_start_on].to_date,
              aptc_effective_end_on: fpl[:aptc_effective_end_on].to_date
            }
          end

          def construct_benchmark_calculation_members(benchmark_calculation_members)
            benchmark_calculation_members.inject([]) do |benchmark_members_params, benchmark|
              benchmark_members_params << {
                member_identifier: benchmark.member_identifier,
                relationship_kind_to_primary: benchmark.relationship_kind_to_primary,
                member_premium: benchmark.member_premium
              }
            end
          end

          def construct_members_payload(members)
            members.inject([]) do |members_params, member|
              members_params << {
                member_identifier: member.member_identifier,
                household_count: member.household_count,
                annual_household_income_contribution: member.annual_household_income_contribution,
                tax_filer_status: member.tax_filer_status,
                is_applicant: member.is_applicant,
                benchmark_plan_monthly_premium_amount: member.benchmark_plan_monthly_premium_amount,
                age_of_applicant: member.age_of_applicant,
                aptc_eligible: member.aptc_eligible,
                totally_ineligible: member.totally_ineligible,
                uqhp_eligible: member.uqhp_eligible,
                magi_medicaid_eligible: member.magi_medicaid_eligible,
                csr_eligible: member.csr_eligible,
                csr: member.csr
              }
            end
          end

          def validate_params(input_payload)
            result = ::AptcCsr::AptcHouseholdContract.new.call(input_payload)
            if result.success?
              Success(result.to_h)
            else
              Failure(result)
            end
          end
        end
      end
    end
  end
end
