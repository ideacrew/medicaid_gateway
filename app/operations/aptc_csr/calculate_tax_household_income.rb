# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module AptcCsr
  # This Operation is for calculating the eligible
  # annual income of applicant that is used to compute APTC
  class CalculateTaxHouseholdIncome
    include Dry::Monads[:result, :do]

    # @param [Hash] opts The options to calculate the eligible annual income
    # @option opts [AcaEntities::MagiMedicaid::TaxHoushold] :magi_medicaid_tax_household
    # @option opts [AcaEntities::MagiMedicaid::Application] :magi_medicaid_application
    # @return [Dry::Result]
    # This class is PRIVATE. Can only be called from AptcCsr::CheckForMedicaidEligibility
    def call(params)
      # { application: @application,
      #   tax_household: @tax_household,
      #   aptc_household: aptc_household }

      income_threshold = yield find_income_threshold(params)
      aptc_household = yield calculate_annual_thh_income(income_threshold)
      Success(aptc_household)
    end

    private

    def find_income_threshold(params)
      @application = params[:application]
      @tax_household = params[:tax_household]
      @aptc_household = params[:aptc_household]
      ::AptcCsr::FindIncomeThreshold.new.call(@application.assistance_year)
    end

    def calculate_annual_thh_income(income_threshold)
      @tax_household.tax_household_members.each do |thhm|
        member_identifier = thhm.applicant_reference.person_hbx_id
        applicant = applicant_by_reference(member_identifier)
        member = matching_aptc_member(@aptc_household, member_identifier)
        member[:annual_household_income_contribution] = calculate_member_income(applicant, thhm, income_threshold)
      end
      @aptc_household[:annual_tax_household_income] =
        @aptc_household[:members].inject(0) {|total, member| total + member[:annual_household_income_contribution]}

      Success(@aptc_household)
    end

    def calculate_member_income(applicant, thhm, income_threshold)
      return BigDecimal('0') unless applicant.incomes.present?
      applicant.incomes.inject(BigDecimal('0')) do |annual_total, income|
        annual_total + eligible_earned_annual_income(applicant, income, income_threshold)
      end
    end

    def eligible_earned_annual_income(applicant, income, income_threshold)
      return BigDecimal('0') unless income_for_current_year?(income)
      annual_tot = compute_annual_income(income)
      return annual_tot unless applicant.is_claimed_as_tax_dependent

      if income.earned?
        income_threshold[:earned_income] > annual_tot ? BigDecimal('0') : annual_tot
      else
        # income.unearned?
        income_threshold[:unearned_income] > annual_tot ? BigDecimal('0') : annual_tot
      end
    end

    def compute_annual_income(income)
      income_end_date = calculate_end_date(income)
      income_start_date = calculate_start_date(income)
      income_per_day = calculate_income_per_day(income)

      ((income_end_date.yday - income_start_date.yday + 1) * income_per_day).round(2)
    end

    def calculate_income_per_day(income)
      no_of_days = @assistance_year_end.yday
      annual_amnt = case income.frequency_kind.downcase
                    when 'weekly'
                      income.amount * 52
                    when 'monthly'
                      income.amount * 12
                    when 'annually', 'once'
                      income.amount
                    when 'biweekly'
                      income.amount * 26
                    when 'quarterly'
                      income.amount * 4
                    when 'semimonthly'
                      income.amount * 24
                    when 'hourly'
                      income.amount * 40 * 52
                    when 'daily'
                      income.amount * 5 * 52
                    when 'semiannually'
                      income.amount * 2
                    when '13xperyear'
                      income.amount * 13
                    when '11xperyear'
                      income.amount * 11
                    when '10xperyear'
                      income.amount * 10
                    else
                      0
                    end
      income_per_day = annual_amnt / no_of_days
      BigDecimal(income_per_day.to_s)
    end

    def calculate_start_date(income)
      if income.start_on >= @assistance_year_start
        income.start_on
      else
        @assistance_year_start
      end
    end

    def calculate_end_date(income)
      return income.end_on if income.end_on.present?
      @assistance_year_end
    end

    def income_for_current_year?(income)
      @assistance_year_start = Date.new(@application.assistance_year)
      @assistance_year_end = @assistance_year_start.end_of_year
      if income.end_on.present?
        ((income.start_on)..(income.end_on)).cover?(@assistance_year_start)
      else
        (@assistance_year_start..@assistance_year_end).cover?(income.start_on)
      end
    end

    def applicant_by_reference(person_hbx_id)
      @application.applicants.detect do |applicant|
        applicant.person_hbx_id.to_s == person_hbx_id.to_s
      end
    end

    def matching_aptc_member(aptc_household, member_identifier)
      aptc_household[:members].detect { |aptc_mem| aptc_mem[:member_identifier].to_s == member_identifier.to_s }
    end
  end
end

# Questions:
#   1. How can I know if a tax dependent's Income does not meet the IRS thresholds to also have to file a tax return?
#   2. Verify the annual_income_calculation
