# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::AptcCsr::MemberContract, dbclean: :around_each do
  let(:required_params) do
    { member_identifier: '95',
      household_count: 1,
      tax_filer_status: 'tax_filer',
      is_applicant: true,
      age_of_applicant: 22 }
  end

  let(:optional_params) do
    { annual_household_income_contribution: 1_000.67,
      benchmark_plan_monthly_premium_amount: 234.23,
      aptc_eligible: true,
      totally_ineligible: false,
      uqhp_eligible: false,
      csr_eligible: true,
      csr: '73',
      member_determinations: [{
        kind: 'Insurance Assistance Determination',
        is_eligible: true,
        determination_reasons: [:income_above_threshold]
      }] }
  end

  let(:all_params) do
    required_params.merge(optional_params)
  end

  context 'with invalid data' do
    context 'no params' do
      it 'should return failure with errors with keys' do
        expect(subject.call({}).errors.to_h.keys).to eq(required_params.keys)
      end
    end

    context 'eligible for more than one determination' do
      before do
        input_params = all_params.merge({ totally_ineligible: true })
        @result = subject.call(input_params)
      end

      it 'should return failure with error message' do
        err_msg = 'Member is eligible for more than one eligibilities: [:aptc_eligible, :totally_ineligible, :uqhp_eligible]'
        expect(@result.errors.to_h.values.flatten).to include(err_msg)
      end
    end

    context 'csr eligible but no csr' do
      before do
        input_params = all_params.merge({ csr: nil })
        @result = subject.call(input_params)
      end

      it 'should return failure with error message' do
        err_msg = 'csr is expected when member is csr eligible'
        expect(@result.errors.to_h[:csr]).to include(err_msg)
      end
    end
  end

  context 'with valid data' do
    before { @result = subject.call(all_params) }

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should return all params' do
      expect(@result.to_h).to eq all_params
    end
  end
end
