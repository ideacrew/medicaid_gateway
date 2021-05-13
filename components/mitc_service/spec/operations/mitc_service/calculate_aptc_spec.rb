# frozen_string_literal: true

require 'rails_helper'
require "#{MitcService::Engine.root}/spec/shared_contexts/magi_medicaid_application_data.rb"

RSpec.describe ::MitcService::CalculateAptc do
  include_context 'setup magi_medicaid application with two applicants'

  before do
    @result = subject.call(input_params)
  end

  context 'with valid inputs' do
    # context 'expected_contribution < benchmark_plan_amount' do
    #   let(:input_params) do
    #     app = mm_application_entity_with_mitc
    #     { fpl_percent: 190.05,
    #       qualified_members: app.tax_households.first.tax_household_members,
    #       magi_medicaid_application: app,
    #       magi_medicaid_tax_household: app.tax_households.first }
    #   end

    #   it 'should return success' do
    #     expect(@result).to be_success
    #   end

    #   it 'should return success with non zero aptc value' do
    #     expect(@result.success).not_to be_zero
    #   end
    # end

    context 'expected_contribution > benchmark_plan_amount' do
      let(:input_params) do
        app = mm_application_entity_with_mitc
        { fpl_percent: 500.05,
          qualified_members: app.tax_households.first.tax_household_members,
          magi_medicaid_application: app,
          magi_medicaid_tax_household: app.tax_households.first }
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return success with aptc value of zero' do
        expect(@result.success).to be_zero
      end
    end
  end
end
