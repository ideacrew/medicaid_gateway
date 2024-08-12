# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BenchmarkEhbPremiumHelper, type: :helper do
  let(:effective_year) { Date.today.year }
  let(:at_least_one_silver_feature) do
    double
  end
  let(:year_level_config_setting) do
    double(
      item: year_level_config
    )
  end

  before do
    allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(
      :atleast_one_silver_plan_donot_cover_pediatric_dental_cost
    ).and_return(top_level_config)
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:atleast_one_silver_plan_donot_cover_pediatric_dental_cost).and_return(
      at_least_one_silver_feature
    )
    allow(at_least_one_silver_feature).to receive(:settings).with(any_args).and_return(nil)
    allow(at_least_one_silver_feature).to receive(:settings).with(effective_year.to_s.to_sym).and_return(year_level_config_setting)
  end

  describe '#slcsapd_enabled?' do
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

  describe '#use_non_dynamic_slcsp?' do
    let(:mm_application) { OpenStruct.new(tax_households: [tax_household], aptc_effective_date: Date.today, assistance_year: effective_year) }
    let(:tax_household) { OpenStruct.new(aptc_csr_eligible_members: [OpenStruct.new(applicant_reference: OpenStruct.new(dob: dob))]) }

    context 'RR config turned OFF' do
      let(:top_level_config) { false }
      let(:year_level_config) { false }
      let(:dob) { Date.today - 15.years }

      it 'should return true' do
        expect(helper.use_non_dynamic_slcsp?(mm_application)).to be_truthy
      end
    end

    context 'RR config turned ON and tax_households do not have aptc_csr eligible children' do
      let(:top_level_config) { true }
      let(:year_level_config) { true }
      let(:dob) { Date.today - 19.years }

      before { allow(helper).to receive(:no_thh_has_aptc_eligible_children?).with(mm_application).and_return(true) }

      it 'should return true' do
        expect(helper.use_non_dynamic_slcsp?(mm_application)).to be_truthy
      end
    end
  end
end
