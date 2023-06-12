# frozen_string_literal: true

require 'rails_helper'
require "#{Rails.root}/spec/shared_contexts/eligibilities/magi_medicaid_application_data.rb"

RSpec.describe ::MitcService::AddMitcDeterminationToApplication do
  include_context 'setup magi_medicaid application with two applicants'

  let(:mm_application) do
    ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(magi_medicaid_application).success
  end

  let(:input_params) do
    { magi_medicaid_application: mm_application, mitc_response: mitc_response }
  end

  let(:override_rules) { ::AcaEntities::MagiMedicaid::Types::EligibilityOverrideRule.values }

  it 'should be a container-ready operation' do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  context 'success' do
    before do
      @result = subject.call(input_params)
    end

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should return the MagiMedicaidApplication entity' do
      expect(@result.success).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context "member determinations" do

      it "should create only one member determination object for medicaid/chip eligibility for each member" do
        @result.success.tax_households.first.tax_household_members.each do |member|
          member_determinations = member.product_eligibility_determination.member_determinations
          mdcr_chip_determ = member_determinations.select {|md| md[:kind] == 'Medicaid/CHIP Determination' }
          expect(mdcr_chip_determ.count).to eq(1)
          expect(mdcr_chip_determ.first).to be_a(::AcaEntities::MagiMedicaid::MemberDetermination)
        end
      end

      it "should create only one member determination object for total ineligibility for each member" do
        @result.success.tax_households.first.tax_household_members.each do |member|
          member_determinations = member.product_eligibility_determination.member_determinations
          mdcr_chip_determ = member_determinations.select {|md| md[:kind] == 'Total Ineligibility Determination' }
          expect(mdcr_chip_determ.count).to eq(1)
          expect(mdcr_chip_determ.first).to be_a(::AcaEntities::MagiMedicaid::MemberDetermination)
        end
      end

      it "should create an override object for each override rule" do
        member_determs = @result.success.tax_households.first.tax_household_members.first.product_eligibility_determination.member_determinations
        eligibility_overrides = member_determs.first.eligibility_overrides
        expect(eligibility_overrides.count).to eq(override_rules.count)
        override_rules.each do |rule|
          eligibility_override = eligibility_overrides.detect { |override| override.override_rule == rule }
          expect(eligibility_override.present?).to be_truthy
        end
      end
    end
  end

  context 'failure' do
    context 'missing params' do
      let(:error_msg) { 'Input hash does not have one/both the keys :magi_medicaid_application, :mitc_response' }

      it 'should return failure with error message for no params' do
        expect(subject.call({}).failure).to eq(error_msg)
      end

      it 'should return failure with error message for missing magi_medicaid_application key' do
        expect(subject.call({ mitc_response: 'mitc_response' }).failure).to eq(error_msg)
      end

      it 'should return failure with error message for missing mitc_response key' do
        expect(subject.call({ magi_medicaid_application: 'magi_medicaid_application' }).failure).to eq(error_msg)
      end
    end

    context 'bad input value' do
      let(:error_msg) { 'Given value for key :magi_medicaid_application is not a ::AcaEntities::MagiMedicaid::Application' }

      it 'should return failure with error message' do
        expect(subject.call({ magi_medicaid_application: 'magi_medicaid_application',
                              mitc_response: mitc_response }).failure).to eq(error_msg)
      end
    end

    context "application submitted during open enrollment with same assistance year" do

      let(:input_application) do
        app_params = mm_application_entity.to_h
        app_params[:aptc_effective_date] = app_params[:oe_start_on]
        app_params[:assistance_year] = app_params[:oe_start_on].year
        ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
      end

      let(:input_params) do
        { magi_medicaid_application: input_application, mitc_response: mitc_response }
      end

      before do
        allow(Date).to receive(:today).and_return mm_application[:oe_start_on]
        @result = subject.call(input_params)
      end

      it "should have eligibility determination start on date match application effective date" do
        expect(@result.success[:tax_households].first.effective_on).to eql(input_application[:aptc_effective_date])
      end
    end

    context "application submitted outside of open enrollment" do
      let(:input_application) do
        app_params = mm_application_entity.to_h
        app_params[:aptc_effective_date] = app_params[:oe_start_on]
        app_params[:assistance_year] = app_params[:oe_start_on].year
        ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
      end

      let(:input_tax_household) do
        input_application.tax_households.first
      end

      let(:input_params) do
        { magi_medicaid_application: input_application,
          mitc_response: mitc_response }
      end

      let(:next_month_start_on) { Date.today.next_month.beginning_of_month }

      before do
        allow(Date).to receive(:today).and_return Date.new(input_application[:assistance_year], 3, 13)
        @result = subject.call(input_params)
      end

      it "should have eligibility determination start on date be first of next month" do
        expect(@result.success[:tax_households].first.effective_on).to eql(next_month_start_on)
      end
    end

    context "application submitted in following year for prior assistance year" do
      let(:input_application) do
        app_params = mm_application_entity.to_h
        app_params[:aptc_effective_date] = app_params[:oe_start_on].end_of_year
        app_params[:assistance_year] = app_params[:oe_start_on].year
        ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
      end

      let(:input_params) do
        { magi_medicaid_application: input_application,
          mitc_response: mitc_response }
      end

      before do
        allow(Date).to receive(:today).and_return input_application[:oe_start_on].next_year.beginning_of_year
        @result = subject.call(input_params)
      end

      it "should have eligibility determination start on date be last day of application assistance year" do
        expect(@result.success[:tax_households].first.effective_on).to eql(input_application[:aptc_effective_date])
      end
    end

    context "application submitted during January of open enrollment for the same year" do
      let(:input_application) do
        app_params = mm_application_entity.to_h
        app_params[:aptc_effective_date] = app_params[:oe_start_on].beginning_of_year + 1.month
        app_params[:assistance_year] = app_params[:oe_start_on].year
        app_params[:oe_start_on] = app_params[:oe_start_on] - 1.year
        ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
      end

      let(:input_tax_household) do
        input_application.tax_households.first
      end

      let(:input_params) do
        { magi_medicaid_application: input_application,
          mitc_response: mitc_response }
      end

      before do
        allow(Date).to receive(:today).and_return Date.new(input_application[:assistance_year])
        @result = subject.call(input_params)
      end

      it "should have eligibility determination be first day of next month" do
        expect(@result.success[:tax_households].first.effective_on).to eql(input_application[:aptc_effective_date])
      end
    end
  end
end
