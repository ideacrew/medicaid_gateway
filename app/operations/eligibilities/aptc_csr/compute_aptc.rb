# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  module AptcCsr
    # This Operation is to compute CSR values for each member of a given TaxHousehold
    class ComputeAptc
      include Dry::Monads[:result, :do]

      def call(params)
        # { application: @result_mm_application,
        #   medicaid_application: medicaid_application,
        #   tax_household: mm_thh }

        persisted_aptc_hh = yield find_aptc_household(params)
        aptc_household = yield fetch_aptc_household_contract_params(persisted_aptc_hh)
        aptc_household = yield calculate_benchmark_plan_amount(aptc_household)
        aptc_household = yield calculate_aptc(aptc_household)
        aptc_household_entity = yield init_aptc_household(aptc_household)
        _updated = yield update_medicaid_aptc_household(persisted_aptc_hh, aptc_household_entity)
        result = yield add_determination_to_application(aptc_household_entity)

        Success(result)
      end

      private

      def find_aptc_household(params)
        @tax_household = params[:tax_household]
        @application = params[:application]
        @medicaid_app = params[:medicaid_application]
        @household_benchmark_ehb_premium = params[:household_benchmark_ehb_premium]
        # BenchmarkHousehold

        persisted_aptc_hh = @medicaid_app.aptc_households.detect do |aptc_hh|
          thhms_person_hbx_ids = @tax_household.tax_household_members.map(&:applicant_reference).flat_map(&:person_hbx_id)
          aptc_hh.aptc_household_members.map(&:member_identifier) & thhms_person_hbx_ids
        end

        if persisted_aptc_hh.present?
          Success(persisted_aptc_hh)
        else
          Failure("Unable to find matching APTC Household for given THH hbx_id: #{@tax_household.hbx_id}")
        end
      end

      def fetch_aptc_household_contract_params(persisted_aptc_hh)
        Eligibilities::AptcCsr::Transformers::MedicaidAptcHouseholdTo::AptcHouseholdContractParams.new.call(persisted_aptc_hh)
      end

      def calculate_benchmark_plan_amount(aptc_household)
        if @household_benchmark_ehb_premium.present?
          aptc_household[:total_benchmark_plan_monthly_premium_amount] = @household_benchmark_ehb_premium
          return Success(aptc_household)
        end

        ::Eligibilities::AptcCsr::CalculateBenchmarkPlanAmount.new.call({ aptc_household: aptc_household,
                                                                          tax_household: @tax_household,
                                                                          application: @application })
      end

      def calculate_aptc(aptc_household)
        total_benchmark_amount = aptc_household[:total_benchmark_plan_monthly_premium_amount] * 12
        total_contribution_amount = aptc_household[:total_expected_contribution_amount]
        compared_result = total_benchmark_amount - total_contribution_amount
        aptc =
          if compared_result > 0
            correct_aptc_if_qsehra(compared_result, aptc_household) / 12
          else
            BigDecimal('0')
          end
        aptc_household[:maximum_aptc_amount] = aptc.round
        aptc_household[:is_aptc_calculated] = true
        Success(aptc_household)
      end

      def correct_aptc_if_qsehra(compared_result, aptc_household)
        amount = total_monthly_qsehra_amount(aptc_household)
        return compared_result if amount.zero?

        corrected_aptc = compared_result - (amount * 12.0)
        corrected_aptc > 0 ? corrected_aptc : BigDecimal('0')
      end

      # Check qsehra for APTC eligible members only
      def total_monthly_qsehra_amount(aptc_household)
        aptc_eligible_members = aptc_household[:members].select do |member|
          member[:aptc_eligible] == true
        end
        aptc_eligible_members.inject(BigDecimal('0')) do |total, member|
          applicant = applicant_by_reference(member[:member_identifier])
          total + applicant.monthly_qsehra_amount
        end
      end

      def applicant_by_reference(person_hbx_id)
        @application.applicants.detect do |applicant|
          applicant.person_hbx_id.to_s == person_hbx_id.to_s
        end
      end

      def init_aptc_household(aptc_household)
        ::Eligibilities::AptcCsr::InitAptcHousehold.new.call(aptc_household)
      end

      def update_medicaid_aptc_household(persisted_aptc_hh, aptc_household_entity)
        persisted_aptc_hh.total_benchmark_plan_monthly_premium_amount = aptc_household_entity.total_benchmark_plan_monthly_premium_amount
        persisted_aptc_hh.maximum_aptc_amount = aptc_household_entity.maximum_aptc_amount
        persisted_aptc_hh.is_aptc_calculated = aptc_household_entity.is_aptc_calculated
        aptc_household_entity.benchmark_calculation_members.each do |bcm|
          persisted_aptc_hh.benchmark_calculation_members.build(bcm.to_h)
        end

        Success(persisted_aptc_hh.save!)
      end

      def add_determination_to_application(aptc_household)
        mm_application_hash = @application.to_h
        mm_application_hash[:tax_households].each do |thh|
          next unless thh[:hbx_id].to_s == @tax_household.hbx_id.to_s
          thh[:max_aptc] = aptc_household.maximum_aptc_amount
          thh[:is_insurance_assistance_eligible] = aptc_household.is_aptc_calculated ? 'Yes' : 'No'
        end

        entity_result = ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(mm_application_hash)
        return entity_result if entity_result.failure?
        Success({ magi_medicaid_application: entity_result.success,
                  aptc_household: aptc_household })
      end
    end
  end
end
