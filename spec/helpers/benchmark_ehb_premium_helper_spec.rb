# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BenchmarkEhbPremiumHelper, type: :helper do
  let(:effective_year) { Date.today.year }

  describe '#slcsapd_enabled?' do
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

  describe '#thh_has_aptc_eligible_children?' do
    let(:applicant_reference) { { first_name: 'first', last_name: 'last', dob: dob, person_hbx_id: '95' } }

    let(:product_eligibility_determination) do
      { is_ia_eligible: is_ia_eligible, is_medicaid_chip_eligible: false, is_non_magi_medicaid_eligible: false, is_totally_ineligible: false,
        is_without_assistance: false, is_magi_medicaid: false, magi_medicaid_monthly_household_income: 6474.42, medicaid_household_size: 1,
        magi_medicaid_monthly_income_limit: 3760.67, magi_as_percentage_of_fpl: 10.0, magi_medicaid_category: 'parent_caretaker' }
    end

    let(:tax_household_member) do
      { product_eligibility_determination: product_eligibility_determination, applicant_reference: applicant_reference }
    end

    let(:thh_params) do
      { max_aptc: 100.56, hbx_id: '12345', is_insurance_assistance_eligible: 'Yes', yearly_expected_contribution: BigDecimal('102.78'),
        tax_household_members: [tax_household_member], annual_tax_household_income: 50_000.00 }
    end

    let(:tax_household) do
      validated_params = ::AcaEntities::MagiMedicaid::Contracts::TaxHouseholdContract.new.call(thh_params).to_h
      ::AcaEntities::MagiMedicaid::TaxHousehold.new(validated_params)
    end

    context 'with aptc_csr eligible child member' do
      let(:dob) { Date.today - 15.years }
      let(:is_ia_eligible) { true }

      it 'should return truthy value' do
        expect(helper.thh_has_aptc_eligible_children?(tax_household, Date.today)).to be_truthy
      end
    end

    context 'with aptc_csr eligible child member' do
      let(:dob) { Date.today - 19.years }
      let(:is_ia_eligible) { true }

      it 'should return non truthy value' do
        expect(helper.thh_has_aptc_eligible_children?(tax_household, Date.today)).not_to be_truthy
      end
    end

    context 'without any aptc_csr eligible members' do
      let(:dob) { Date.today - 15.years }
      let(:is_ia_eligible) { false }

      it 'should return non truthy value' do
        expect(helper.thh_has_aptc_eligible_children?(tax_household, Date.today)).not_to be_truthy
      end
    end
  end

  describe '#no_thh_has_aptc_eligible_children?' do
    let(:mm_application) { OpenStruct.new(tax_households: [tax_household], aptc_effective_date: Date.today) }
    let(:tax_household) { OpenStruct.new(aptc_csr_eligible_members: [OpenStruct.new(applicant_reference: OpenStruct.new(dob: dob))]) }

    context 'tax_household with aptc_csr eligible children' do
      let(:dob) { Date.today - 15.years }

      it 'should return non truthy value' do
        expect(helper.no_thh_has_aptc_eligible_children?(mm_application)).not_to be_truthy
      end
    end

    context 'tax_household with aptc_csr eligible children' do
      let(:dob) { Date.today - 19.years }

      it 'should return non truthy value' do
        expect(helper.no_thh_has_aptc_eligible_children?(mm_application)).to be_truthy
      end
    end
  end

  describe '#use_non_dynamic_slcsp?' do
    before do
      MedicaidGatewayRegistry[:atleast_one_silver_plan_donot_cover_pediatric_dental_cost].feature.stub(:is_enabled).and_return(top_level_config)
      MedicaidGatewayRegistry[:atleast_one_silver_plan_donot_cover_pediatric_dental_cost].settings(
        effective_year.to_s.to_sym
      ).stub(:item).and_return(year_level_config)
    end

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

      it 'should return true' do
        expect(helper.use_non_dynamic_slcsp?(mm_application)).to be_truthy
      end
    end
  end
end
