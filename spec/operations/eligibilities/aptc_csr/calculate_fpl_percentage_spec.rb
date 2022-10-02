# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/eligibilities/magi_medicaid_application_data')
require 'types'
require 'aca_entities/magi_medicaid/contracts/create_federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/contracts/federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/federal_poverty_level'
require 'aca_entities/operations/magi_medicaid/create_federal_poverty_level'

describe Eligibilities::AptcCsr::CalculateFplPercentage do
  before do
    MedicaidGatewayRegistry[:atleast_one_silver_plan_donot_cover_pediatric_dental_cost].feature.stub(:is_enabled).and_return(false)
  end

  include_context 'setup magi_medicaid application with two applicants'

  let(:input_application) do
    mm_application_entity
  end

  let(:input_tax_household) do
    input_application.tax_households.first
  end

  let(:input_params) do
    { magi_medicaid_tax_household: input_tax_household,
      magi_medicaid_application: input_application }
  end

  let(:eligibility) { Eligibilities::AptcCsr::DetermineMemberEligibility.new.call(input_params) }

  let(:fpl_data) { ::Types::FederalPovertyLevels.detect { |fpl_hash| fpl_hash[:medicaid_year] == Date.today.year - 1 } }

  let(:feature_ns) { double }

  let(:overrides) do
    [
      {
        medicaid_year: Date.today.year - 1,
        annual_poverty_guideline: BigDecimal(1_500.to_s),
        annual_per_person_amount: BigDecimal(300.to_s)
      }
    ]
  end

  let(:override_data) { overrides.detect { |fpl_hash| fpl_hash[:medicaid_year] == Date.today.year - 1 } }

  context 'with default FPL' do
    before do
      magi_medicaid_application = eligibility.success[:magi_medicaid_application]
      aptc_household = eligibility.success[:aptc_household]
      matching_th = magi_medicaid_application.tax_households.detect do |thh|
        thh.hbx_id.to_s == input_tax_household.hbx_id.to_s
      end
      @result = subject.call(application: magi_medicaid_application, tax_household: matching_th, aptc_household: aptc_household.to_h)
    end

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should have an annual poverty level equal to the default FPL' do
      expect(@result.success[:fpl][:annual_poverty_guideline]).to eq fpl_data[:annual_poverty_guideline]
    end

    it 'should have an annual per person amount to the default FPL' do
      expect(@result.success[:fpl][:annual_per_person_amount]).to eq fpl_data[:annual_per_person_amount]
    end
  end

  context 'with overrides enabled' do
    before do
      allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:fpl_overrides).and_return(true)
      allow(MedicaidGatewayRegistry[:fpl_overrides]).to receive(:item).and_return(overrides)
      magi_medicaid_application = eligibility.success[:magi_medicaid_application]
      aptc_household = eligibility.success[:aptc_household]
      matching_th = magi_medicaid_application.tax_households.detect do |thh|
        thh.hbx_id.to_s == input_tax_household.hbx_id.to_s
      end
      @result = subject.call(application: magi_medicaid_application, tax_household: matching_th, aptc_household: aptc_household.to_h)
    end

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should have an annual poverty level equal to use the override rather than the default FPL' do
      expect(@result.success[:fpl][:annual_poverty_guideline]).to eq override_data[:annual_poverty_guideline]
      expect(@result.success[:fpl][:annual_poverty_guideline]).to_not eq fpl_data[:annual_poverty_guideline]
    end

    it 'should have an annual per person amount to use the override rather than the default FPL' do
      expect(@result.success[:fpl][:annual_per_person_amount]).to eq override_data[:annual_per_person_amount]
      expect(@result.success[:fpl][:annual_per_person_amount]).to_not eq fpl_data[:annual_per_person_amount]
    end
  end
end