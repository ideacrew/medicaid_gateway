# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'components/mitc_service/spec/shared_contexts/magi_medicaid_application_data')

describe AptcCsr::DetermineEligibility do
  include_context 'setup magi_medicaid application with two applicants'

  context 'with one applicant being pregnant' do
    let(:pregnancy_information2) do
      { is_pregnant: true,
        is_post_partum_period: false,
        expected_children_count: 1,
        pregnancy_due_on: Date.today.next_month }
    end

    let(:input_application) do
      app_params = mm_application_entity_with_mitc.to_h
      app_params[:applicants].second[:pregnancy_information] = pregnancy_information2
      ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
    end

    let(:input_tax_household) do
      input_application.tax_households.first
    end

    let(:input_params) do
      { magi_medicaid_tax_household: input_tax_household,
        magi_medicaid_application: input_application }
    end

    before do
      @result = subject.call(input_params)
      magi_medicaid_application = @result.success[:magi_medicaid_application]
      @aptc_household = @result.success[:aptc_household]
      @matching_th = magi_medicaid_application.tax_households.detect do |thh|
        thh.hbx_id.to_s == input_tax_household.hbx_id.to_s
      end
    end

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should return a hash with keys' do
      expect(@result.success.keys).to include(:magi_medicaid_application)
      expect(@result.success.keys).to include(:aptc_household)
    end

    it 'should return with aptc and csr determinations' do
      expect(@matching_th.max_aptc).to eq(@aptc_household.maximum_aptc_amount)
      expect(@matching_th.csr).to eq(@aptc_household.csr_percentage)
    end

    it 'should return a valid aptc amount' do
      expect(@matching_th.max_aptc).to eq(992.04)
    end

    it 'should return a valid csr amount' do
      expect(@matching_th.csr).to eq(94)
    end
  end
end