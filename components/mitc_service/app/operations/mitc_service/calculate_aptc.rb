# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module MitcService
  # This class is for calculating APTC value for MagiMedicaidTaxHousehold
  class CalculateAptc
    include Dry::Monads[:result, :do]

    # @param [Hash] opts The options to calculate APTC
    # @option opts [Float] :fpl_percent
    # @option opts [Array<AcaEntities::MagiMedicaid::TaxHouseholdMember>] :qualified_members
    # @option opts [AcaEntities::MagiMedicaid::Application] :magi_medicaid_application
    # @option opts [AcaEntities::MagiMedicaid::TaxHousehold] :magi_medicaid_tax_household
    # @return [Dry::Monads::Result]
    def call(params)
      # { fpl_percent: fpl_percent,
      #   qualified_members: qualified_members,
      #   magi_medicaid_application: @mm_application,
      #   magi_medicaid_tax_household: @mm_thh }

      expected_contribution = yield calculate_expected_contribution(params)
      benchmark_plan_amount = yield calculate_bechmark_plan_amount
      monthly_aptc = yield calculate_aptc(expected_contribution, benchmark_plan_amount)

      Success(monthly_aptc)
    end

    private

    def calculate_aptc(expected_contribution, benchmark_plan_amount)
      compared_value = (benchmark_plan_amount - expected_contribution)
      return Success(0) if compared_value <= 0
      adjusted_aptc = (compared_value / 12) - total_monthly_qsehra_amount
      Success((adjusted_aptc <= 0) ? 0 : adjusted_aptc)
    end

    def total_monthly_qsehra_amount
      @mm_application.applicants.inject(0) do |total_amount, applicant|
        total_amount + applicant.monthly_qsehra_amount
      end
    end

    def calculate_bechmark_plan_amount
      # 1. Adjust for household size
      # 2. Find annual SLCSP value for adjusted household size
      total_premium = total_adjusted_premium
      Success(total_premium)
    end

    def total_adjusted_premium
      # Calculate the benchmark plan amount
      # Setup BenchmarkProduct on MagiMedicaidApplication
      # thhms = @mm_thh.tax_household_members
      # @mm_application.benchmark_product.member_premium(effective_date, age)
      (425.47 + 496.02)
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def calculate_expected_contribution(params)
      # Where do we get this information from? DB or a Constant!?
      @fpl = params[:fpl_percent]
      @mm_thh = params[:magi_medicaid_tax_household]
      @mm_application = params[:magi_medicaid_application]
      @qualified_members = params[:qualified_members]

      if @mm_thh.tax_household_income.blank?
        return Failure("Unable to calculate expected contribution as tax_household_income: #{@mm_thh.tax_household_income}")
      end

      applicable_percentage = if @fpl < 133 || (@fpl >= 133 && @fpl < 150)
                                0
                              elsif @fpl >= 150 && @fpl < 200
                                ((@fpl - 150) / 50) * 2
                              elsif @fpl >= 200 && @fpl < 250
                                (((@fpl - 200) / 50) * 2) + 2
                              elsif @fpl >= 250 && @fpl < 300
                                (((@fpl - 250) / 50) * 2) + 4
                              elsif @fpl >= 300 && @fpl < 400
                                (((@fpl - 300) / 100) * 2.5) + 6
                              else
                                8.5
                              end

      Success((@mm_thh.tax_household_income * applicable_percentage) / 100)
    end
    # rubocop:enable Metrics/CyclomaticComplexity
  end
end
