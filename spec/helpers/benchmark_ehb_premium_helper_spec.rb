# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BenchmarkEhbPremiumHelper, type: :helper do
  describe '#slcsapd_enabled?' do
    let(:effective_year) { Date.today.year }

    before do
      MedicaidGatewayRegistry[:atleast_one_silver_plan_donot_cover_pediatric_dental_cost].feature.stub(:is_enabled).and_return(top_level_config)
      MedicaidGatewayRegistry[:atleast_one_silver_plan_donot_cover_pediatric_dental_cost].settings(
        effective_year.to_s.to_sym
      ).stub(:item).and_return(year_level_config)
    end

    context 'top level feature is turned off' do
      let(:top_level_config) { false }
      let(:year_level_config) { false }

      it 'should return non truthy value' do
        expect(helper.slcsapd_enabled?(effective_year)).not_to be_truthy
      end
    end

    context 'top level feature is turned on and year level is turned off' do
      let(:top_level_config) { true }
      let(:year_level_config) { false }

      it 'should return non truthy value' do
        expect(helper.slcsapd_enabled?(effective_year)).not_to be_truthy
      end
    end

    context 'top level feature is turned on and year level is turned on' do
      let(:top_level_config) { true }
      let(:year_level_config) { true }

      it 'should return truthy value' do
        expect(helper.slcsapd_enabled?(effective_year)).to be_truthy
      end
    end

    context 'top level feature is turned on and year level config is missing' do
      let(:top_level_config) { true }
      let(:year_level_config) { true }

      it 'should return non truthy value' do
        expect(helper.slcsapd_enabled?(2019)).not_to be_truthy
      end
    end
  end
end
