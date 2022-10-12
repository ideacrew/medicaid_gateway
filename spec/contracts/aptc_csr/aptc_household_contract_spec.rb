# frozen_string_literal: true

# rubocop:disable Layout/LineLength
require 'rails_helper'
require 'aca_entities/magi_medicaid/contracts/create_federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/contracts/federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/federal_poverty_level'
require 'aca_entities/operations/magi_medicaid/create_federal_poverty_level'

RSpec.describe ::AptcCsr::AptcHouseholdContract, dbclean: :around_each do
  let(:fpl) do
    { state_code: 'ME',
      household_size: 1,
      medicaid_year: Date.today.year,
      annual_poverty_guideline: 12_000,
      annual_per_person_amount: 4_800,
      monthly_poverty_guideline: 1_000,
      monthly_per_person_amount: 400,
      aptc_effective_start_on: Date.today.prev_day,
      aptc_effective_end_on: Date.today.end_of_year }
  end

  let(:input_params) do
    { total_household_count: 1,
      annual_tax_household_income: aptc_member[:annual_household_income_contribution],
      is_aptc_calculated: true,
      maximum_aptc_amount: 100.88,
      total_expected_contribution_amount: 130.88,
      total_benchmark_plan_monthly_premium_amount: aptc_member[:benchmark_plan_monthly_premium_amount] * 12,
      assistance_year: Date.today.year,
      fpl: fpl,
      fpl_percent: 256.00,
      benchmark_calculation_members: [{ member_identifier: aptc_member[:member_identifier],
                                        relationship_kind_to_primary: 'self',
                                        member_premium: aptc_member[:benchmark_plan_monthly_premium_amount] }],
      members: [aptc_member],
      tax_household_identifier: '9876',
      eligibility_date: Date.today.next_month.beginning_of_month }
  end

  context 'with valid data' do
    let(:aptc_member) do
      { member_identifier: '95',
        household_count: 1,
        tax_filer_status: 'tax_filer',
        is_applicant: true,
        annual_household_income_contribution: 1_000.67,
        benchmark_plan_monthly_premium_amount: 234.23,
        age_of_applicant: 22,
        aptc_eligible: true,
        totally_ineligible: false,
        uqhp_eligible: false,
        csr_eligible: true,
        csr: '73' }
    end

    before { @result = subject.call(input_params) }

    it 'should return success' do
      expect(@result).to be_success
    end
  end

  context 'with invalid data' do
    context 'no params' do
      let(:errs) do
        { :annual_tax_household_income => ["is missing", "must be a decimal"],
          :assistance_year => ["is missing", "must be an integer"],
          :eligibility_date => ["is missing", "must be a date"],
          :fpl => [["is missing"],
                   { :state_code => ["must be one of: AL, AK, AS, AZ, AR, CA, CO, CT, DE, DC, FM, FL, GA, GU, HI, ID, IL, IN, IA, KS, KY, LA, ME, MH, MD, MA, MI, MN, MS, MO, MT, NE, NV, NH, NJ, NM, NY, NC, ND, MP, OH, OK, OR, PW, PA, PR, RI, SC, SD, TN, TX, UT, VT, VI, VA, WA, WV, WI, WY"] }],
          :fpl_percent => ["is missing", "must be a decimal"],
          :members => ["is missing", "must be an array"],
          :total_household_count => ["is missing", "must be an integer"] }
      end
      it 'should return failure with errors' do
        expect(subject.call({}).errors.to_h).to eq(errs)
      end
    end

    context 'eligible for more than one determination' do
      let(:aptc_member) do
        { member_identifier: '95',
          household_count: 1,
          tax_filer_status: 'tax_filer',
          is_applicant: true,
          annual_household_income_contribution: 1_000.67,
          benchmark_plan_monthly_premium_amount: 234.23,
          age_of_applicant: 22,
          aptc_eligible: true,
          totally_ineligible: true,
          uqhp_eligible: false,
          csr_eligible: true,
          csr: '73' }
      end

      before do
        @result = subject.call(input_params)
      end

      it 'should return failure for member 1' do
        expect(@result.errors.to_h[:members][0]).not_to be_empty
      end
    end

    context 'csr eligible but no csr' do
      let(:aptc_member) do
        { member_identifier: '95',
          household_count: 1,
          tax_filer_status: 'tax_filer',
          is_applicant: true,
          annual_household_income_contribution: 1_000.67,
          benchmark_plan_monthly_premium_amount: 234.23,
          age_of_applicant: 22,
          aptc_eligible: true,
          totally_ineligible: false,
          uqhp_eligible: false,
          csr_eligible: true,
          csr: nil }
      end

      before do
        @result = subject.call(input_params)
      end

      it 'should return failure for member 1' do
        expect(@result.errors.to_h[:members][0]).not_to be_empty
      end
    end
  end
end
# rubocop:enable Layout/LineLength
