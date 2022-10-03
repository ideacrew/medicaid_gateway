# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Medicaid::AptcHousehold, type: :model do
  context 'associations' do
    context 'embeds_many :benchmark_calculation_members' do
      before do
        @association = described_class.reflect_on_association(:benchmark_calculation_members)
      end

      it "should return association's class as EmbedsMany" do
        expect(@association.class).to eq(Mongoid::Association::Embedded::EmbedsMany)
      end

      it "should return association's name as benchmark_calculation_members" do
        expect(@association.name).to eq(:benchmark_calculation_members)
      end
    end

    context 'embeds_many :aptc_household_members' do
      before do
        @association = described_class.reflect_on_association(:aptc_household_members)
      end

      it "should return association's class as EmbedsMany" do
        expect(@association.class).to eq(Mongoid::Association::Embedded::EmbedsMany)
      end

      it "should return association's name as aptc_household_members" do
        expect(@association.name).to eq(:aptc_household_members)
      end
    end
  end

  context 'valid params' do
    let(:fpl) do
      { state_code: "DC",
        household_size: 1,
        medicaid_year: Date.today.year,
        annual_poverty_guideline: 12_760.0,
        annual_per_person_amount: 4480.0,
        monthly_poverty_guideline: 1100.0,
        monthly_per_person_amount: 370.0,
        aptc_effective_start_on: Date.new(Date.today.year, 11, 1),
        aptc_effective_end_on: Date.new(Date.today.year + 1, 10, 31) }
    end
    let(:input_params) do
      { total_household_count: 1,
        annual_tax_household_income: 10_000.89,
        is_aptc_calculated: true,
        maximum_aptc_amount: 345.78,
        total_expected_contribution_amount: 5_000.34,
        total_benchmark_plan_monthly_premium_amount: 355.5,
        assistance_year: Date.today.year,
        fpl: fpl,
        fpl_percent: 256.00,
        eligibility_date: Date.today.next_month.beginning_of_month }
    end
    let(:application) { FactoryBot.create(:application, :with_aptc_households) }

    before do
      @aptc_household = application.aptc_households.build(input_params)
      application.save!
    end

    it 'should be findable' do
      expect(application.reload.aptc_households.find(@aptc_household.id)).to be_a(::Medicaid::AptcHousehold)
    end

    it 'should store created_at timestamps' do
      expect(application.aptc_households.pluck(:created_at).compact.count).to eq(2)
    end

    it 'should be able to calculate the expected contribution percentage' do
      expect(@aptc_household.contribution_percent.to_i).to eq(49)
    end
  end
end
