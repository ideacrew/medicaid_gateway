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

    let(:input_params) do
      { magi_medicaid_tax_household: input_application.tax_households.first,
        magi_medicaid_application: input_application }
    end

    before do
      @result = subject.call(input_params)
    end

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should return success with response hash' do
      expect(@result.success).to eq({ aptc_eligible: true, tax_household_fpl: BigDecimal('360.0') })
    end
  end
end
