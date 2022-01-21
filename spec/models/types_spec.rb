# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types do
  describe 'constant FederalPovertyLevels' do
    def fetch_fpl_data(year)
      ::Types::FederalPovertyLevels.detect do |fpl_hash|
        fpl_hash[:medicaid_year] == year
      end
    end

    context 'for year 2022' do
      before do
        @fpl_data = fetch_fpl_data(2022)
      end

      it 'should return annual_poverty_guideline as expected' do
        expect(@fpl_data[:annual_poverty_guideline]).to eq(BigDecimal(13_590.to_s))
      end

      it 'should return annual_per_person_amount as expected' do
        expect(@fpl_data[:annual_per_person_amount]).to eq(BigDecimal(4_720.to_s))
      end
    end

    context 'for year 2021' do
      before do
        @fpl_data = fetch_fpl_data(2021)
      end

      it 'should return annual_poverty_guideline as expected' do
        expect(@fpl_data[:annual_poverty_guideline]).to eq(BigDecimal(12_880.to_s))
      end

      it 'should return annual_per_person_amount as expected' do
        expect(@fpl_data[:annual_per_person_amount]).to eq(BigDecimal(4_540.to_s))
      end
    end
  end
end
