# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/eligibilities/magi_medicaid_application_data')
require 'aca_entities/magi_medicaid/contracts/create_federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/contracts/federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/federal_poverty_level'
require 'aca_entities/operations/magi_medicaid/create_federal_poverty_level'

describe Eligibilities::AptcCsr::CalculateBenchmarkPlanAmount do
  context 'with one applicant being pregnant' do
    include_context 'setup magi_medicaid application with two applicants'

    let(:input_tax_household) do
      mm_application_entity.tax_households.first
    end

    let(:input_params) do
      { aptc_household:
        { :members =>
          [{
            :member_identifier => "95",
            :household_count => 1,
            :tax_filer_status => "tax_filer",
            :is_applicant => true,
            :age_of_applicant => 45,
            :annual_household_income_contribution => 0.0,
            :aptc_eligible => true,
            :csr_eligible => true,
            :benchmark_plan_monthly_premium_amount => 320.53
          }, {
            :member_identifier => "96",
            :household_count => 1,
            :tax_filer_status => "tax_filer",
            :is_applicant => true,
            :age_of_applicant => 43,
            :annual_household_income_contribution => 0.0,
            :aptc_eligible => true,
            :csr_eligible => true,
            :benchmark_plan_monthly_premium_amount => 320.63
          }],
          :assistance_year => 2021,
          :total_household_count => 1,
          :annual_tax_household_income => 0.0,
          :eligibility_date => Date.today,
          :fpl_percent => 0.0,
          :fpl =>
            {
              :state_code => "DC",
              :household_size => 2,
              :medicaid_year => 2021,
              :annual_poverty_guideline => 12_765.0,
              :annual_per_person_amount => 4484.0,
              :monthly_poverty_guideline => 1063.0,
              :monthly_per_person_amount => 374.0,
              :aptc_effective_start_on => Date.today,
              :aptc_effective_end_on => Date.today
            },
          :total_expected_contribution_amount => 0.0 },
        tax_household: input_tax_household,
        application: mm_application_entity }
    end

    before do
      @result = subject.call(input_params)
    end

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should return total_benchmark_plan_monthly_premium_amount value' do
      expect(@result.success.keys).to include(:total_benchmark_plan_monthly_premium_amount)
      expect(@result.success[:total_benchmark_plan_monthly_premium_amount]).not_to be_nil
    end

    it 'should return benchmark_calculation_members' do
      expect(@result.success.keys).to include(:benchmark_calculation_members)
      expect(@result.success[:benchmark_calculation_members]).not_to be_empty
    end
  end
end
