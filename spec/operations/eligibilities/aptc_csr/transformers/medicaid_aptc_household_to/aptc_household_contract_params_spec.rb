# frozen_string_literal: true

require 'rails_helper'

describe Eligibilities::AptcCsr::Transformers::MedicaidAptcHouseholdTo::AptcHouseholdContractParams do
  describe '#call?' do
    let(:application) { FactoryBot.create(:application, :with_aptc_households) }

    before do
      @result = subject.call(medicaid_aptc_household)
    end

    context 'with valid aptc_household' do
      let(:medicaid_aptc_household) { application.aptc_households.first }

      it 'should return success' do
        expect(@result.success?).to eq(true)
      end
    end

    context 'with invalid aptc_household' do
      let(:medicaid_aptc_household) do
        aptc_hh = application.aptc_households.first
        aptc_hh.update_attributes!(total_household_count: nil)
        aptc_hh
      end

      it 'should return failure' do
        expect(@result.failure?).to eq(true)
        expect(@result.failure.errors.to_h).not_to be_empty
      end
    end
  end
end
