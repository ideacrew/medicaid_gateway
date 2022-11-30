# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/eligibilities/magi_medicaid_application_data')
require 'aca_entities/magi_medicaid/contracts/create_federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/contracts/federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/federal_poverty_level'
require 'aca_entities/operations/magi_medicaid/create_federal_poverty_level'

describe Eligibilities::AptcCsr::DetermineMemberEligibility do
  include_context 'setup magi_medicaid application with two applicants'

  context 'with one applicant being pregnant' do
    let(:pregnancy_information2) do
      { is_pregnant: true,
        is_post_partum_period: false,
        expected_children_count: 1,
        pregnancy_due_on: Date.today.next_month }
    end

    let(:input_application) do
      app_params = mm_application_entity.to_h
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
  end

  context 'with income' do
    context 'with start date on first of current year and end date in future year' do
      let(:income) do
        { kind: "wages_and_salaries",
          amount: "1000.0",
          amount_tax_exempt: "0.0",
          frequency_kind: "Monthly",
          start_on: "#{Date.today.year}-01-01",
          end_on: "#{Date.today + 2.years.year}-01-01",
          is_projected: false,
          employer: {
            employer_name: "Test LLC"
          } }
      end

      let(:input_application) do
        app_params = mm_application_entity.to_h
        app_params[:applicants].first[:incomes] = [income]
        ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
      end

      let(:input_tax_household) do
        input_application.tax_households.first
      end

      let(:input_params) do
        { magi_medicaid_tax_household: input_tax_household,
          magi_medicaid_application: input_application }
      end


      it 'should calculate the annual tax household income correctly' do
        result = subject.call(input_params)
        annual_thh_income = result.success[:aptc_household].annual_tax_household_income.to_f.ceil
        expect(annual_thh_income).to eq 12000
      end
    end

    context 'with start date on first of current year and end date less than current year end on' do
      let(:income) do
        { kind: "wages_and_salaries",
          amount: "1000.0",
          amount_tax_exempt: "0.0",
          frequency_kind: "Monthly",
          start_on: "#{Date.today.year}-01-01",
          end_on: Date.today.beginning_of_year + 8.months,
          is_projected: false,
          employer: {
            employer_name: "Test LLC"
          } }
      end

      let(:input_application) do
        app_params = mm_application_entity.to_h
        app_params[:applicants].first[:incomes] = [income]
        ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
      end

      let(:input_tax_household) do
        input_application.tax_households.first
      end

      let(:input_params) do
        { magi_medicaid_tax_household: input_tax_household,
          magi_medicaid_application: input_application }
      end


      it 'should calculate the annual tax household income correctly' do
        result = subject.call(input_params)
        annual_thh_income = result.success[:aptc_household].annual_tax_household_income.to_f.ceil
        expect(annual_thh_income).to eq 8022
      end
    end

    context 'with start date on first of current year and end date on year end date' do
      let(:income) do
        { kind: "wages_and_salaries",
          amount: "1000.0",
          amount_tax_exempt: "0.0",
          frequency_kind: "Monthly",
          start_on: "#{Date.today.year}-01-01",
          end_on: Date.today.end_of_year,
          is_projected: false,
          employer: {
            employer_name: "Test LLC"
          } }
      end

      let(:input_application) do
        app_params = mm_application_entity.to_h
        app_params[:applicants].first[:incomes] = [income]
        ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
      end

      let(:input_tax_household) do
        input_application.tax_households.first
      end

      let(:input_params) do
        { magi_medicaid_tax_household: input_tax_household,
          magi_medicaid_application: input_application }
      end


      it 'should calculate the annual tax household income correctly' do
        result = subject.call(input_params)
        annual_thh_income = result.success[:aptc_household].annual_tax_household_income.to_f.ceil
        expect(annual_thh_income).to eq 12000
      end
    end

    context 'with start date on first of current year and no end date' do
      let(:income) do
        { kind: "wages_and_salaries",
          amount: "1000.0",
          amount_tax_exempt: "0.0",
          frequency_kind: "Monthly",
          start_on: "#{Date.today.year}-01-01",
          end_on: nil,
          is_projected: false,
          employer: {
            employer_name: "Test LLC"
          } }
      end

      let(:input_application) do
        app_params = mm_application_entity.to_h
        app_params[:applicants].first[:incomes] = [income]
        ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
      end

      let(:input_tax_household) do
        input_application.tax_households.first
      end

      let(:input_params) do
        { magi_medicaid_tax_household: input_tax_household,
          magi_medicaid_application: input_application }
      end


      it 'should calculate the annual tax household income correctly' do
        result = subject.call(input_params)
        annual_thh_income = result.success[:aptc_household].annual_tax_household_income.to_f.ceil
        expect(annual_thh_income).to eq 12000
      end
    end
  end
end
