# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
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
        ::Eligibilities::AptcCsr::FindIncomeThreshold.new.call(@application.assistance_year)
      end

      def calculate_annual_thh_income(income_threshold)
        @tax_household.tax_household_members.each do |thhm|
          member_identifier = thhm.applicant_reference.person_hbx_id
          applicant = applicant_by_reference(member_identifier)
          member = matching_aptc_member(@aptc_household, member_identifier)
          member[:annual_household_income_contribution] = calculate_member_income(applicant, income_threshold)
        end
        @aptc_household[:annual_tax_household_income] =
          @aptc_household[:members].inject(0) {|total, member| total + member[:annual_household_income_contribution]}
        @aptc_household[:eligibility_date] = calculate_eligibility_date

        Success(@aptc_household)
      end

      def calculate_eligibility_date
        current_date = Date.today
        return Date.new(@application.assistance_year) if current_date.year < @application.assistance_year
        return @application.aptc_effective_date if current_date.year > @application.assistance_year

        oe_start_on = @application.oe_start_on
        end_of_assistance_year = Date.new(@application.assistance_year).end_of_year
        if (oe_start_on..end_of_assistance_year).cover?(current_date)
          @application.aptc_effective_date
        else
          current_date.next_month.beginning_of_month
        end
      end

      def calculate_member_income(applicant, income_threshold)
        member_income =
          if applicant.incomes.present?
            applicant.incomes.inject(BigDecimal('0')) do |annual_total, income|
              annual_total + eligible_earned_annual_income(applicant, income, income_threshold)
            end
          else
            BigDecimal('0')
          end

        member_deduction =
          if applicant.deductions.present?
            applicant.deductions.inject(BigDecimal('0')) do |annual_total, deduction|
              annual_total + eligible_annual_deduction(deduction)
            end
          else
            BigDecimal('0')
          end

        member_income - member_deduction
      end

      def eligible_annual_deduction(deduction)
        return BigDecimal('0') unless amount_for_current_year?(deduction)
        compute_annual_amount(deduction)
      end

      def eligible_earned_annual_income(applicant, income, income_threshold)
        return BigDecimal('0') unless amount_for_current_year?(income)
        annual_tot = compute_annual_amount(income)
        return annual_tot unless applicant.is_claimed_as_tax_dependent

        if income.earned?
          income_threshold[:earned_income] > annual_tot ? BigDecimal('0') : annual_tot
        else
          # income.unearned?
          income_threshold[:unearned_income] > annual_tot ? BigDecimal('0') : annual_tot
        end
      end

      def compute_annual_amount(evidence)
        evidence_end_date = calculate_end_date(evidence)
        evidence_start_date = calculate_start_date(evidence)
        year_difference = evidence_end_date.year - evidence_start_date.year
        days_in_start_year = Date.gregorian_leap?(evidence_start_date.year) ? 366 : 365
        start_day_of_year = evidence_start_date.yday
        end_day_of_year = evidence_end_date.yday + (year_difference * days_in_start_year)
        evidence_per_day = calculate_amount_per_day(evidence)

        ((end_day_of_year - start_day_of_year + 1) * evidence_per_day).round(2)
      end

      # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength
      def calculate_amount_per_day(evidence)
        no_of_days = @assistance_year_end.yday
        annual_amnt = case evidence.frequency_kind.downcase
                      when 'weekly'
                        evidence.amount * 52
                      when 'monthly'
                        evidence.amount * 12
                      when 'annually', 'once'
                        evidence.amount
                      when 'biweekly'
                        evidence.amount * 26
                      when 'quarterly'
                        evidence.amount * 4
                      when 'semimonthly'
                        evidence.amount * 24
                      when 'hourly'
                        evidence.amount * 40 * 52
                      when 'daily'
                        evidence.amount * 5 * 52
                      when 'semiannually'
                        evidence.amount * 2
                      when '13xperyear'
                        evidence.amount * 13
                      when '11xperyear'
                        evidence.amount * 11
                      when '10xperyear'
                        evidence.amount * 10
                      else
                        0
                      end
        amount_per_day = annual_amnt / no_of_days
        BigDecimal(amount_per_day.to_s)
      end
      # rubocop:enable Metrics/CyclomaticComplexity, Metrics/MethodLength

      def calculate_start_date(income)
        if income.start_on >= @assistance_year_start
          income.start_on
        else
          @assistance_year_start
        end
      end

      def calculate_end_date(income)
        return income.end_on if income.end_on.present? && (income.end_on <= @assistance_year_end)
        @assistance_year_end
      end

      def amount_for_current_year?(evidence)
        @assistance_year_start = Date.new(@application.assistance_year)
        @assistance_year_end = @assistance_year_start.end_of_year
        evidence_end = evidence.end_on || @assistance_year_end
        evidence_date_range = (evidence.start_on)..evidence_end
        year_date_range = @assistance_year_start..@assistance_year_end
        date_ranges_overlap?(evidence_date_range, year_date_range)
      end

      def date_ranges_overlap?(range_a, range_b)
        range_b.begin <= range_a.end && range_a.begin <= range_b.end
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
end
