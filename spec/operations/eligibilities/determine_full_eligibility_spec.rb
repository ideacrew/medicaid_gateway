# frozen_string_literal: true

require 'rails_helper'
require "#{Rails.root}/spec/shared_contexts/eligibilities/magi_medicaid_application_data.rb"
Dir["#{Rails.root}/spec/shared_contexts/eligibilities/cms/me_simple_scenarios/*.rb"].sort.each { |file| require file }
require 'aca_entities/magi_medicaid/contracts/create_federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/contracts/federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/federal_poverty_level'
require 'aca_entities/operations/magi_medicaid/create_federal_poverty_level'

RSpec.describe ::Eligibilities::DetermineFullEligibility do
  it 'should be a container-ready operation' do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  context 'with MagiMedicaidApplication hash' do
    include_context 'setup magi_medicaid application with two applicants'

    before do
      allow(HTTParty).to receive(:post).and_return(mitc_response)
      @result = subject.call(magi_medicaid_application)
    end

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should return success with MagiMedicaidApplication' do
      expect(@result.success).to be_a(::AcaEntities::MagiMedicaid::Application)
    end
  end

  # Dwayne is UQHP eligible and eligible for non_magi_reasons
  context 'cms simle test_case_a' do
    include_context 'cms ME simple_scenarios test_case_a'

    before do
      allow(HTTParty).to receive(:post).and_return(mitc_response)
      @result = subject.call(input_application)
      @application = @result.success
      @thh = @application.tax_households.first
      @dwayne_ped = @thh.tax_household_members.detect do |thhm|
        thhm.applicant_reference.person_hbx_id == dwayne[:person_hbx_id]
      end.product_eligibility_determination
      @betty_ped = @thh.tax_household_members.detect do |thhm|
        thhm.applicant_reference.person_hbx_id == betty[:person_hbx_id]
      end.product_eligibility_determination
    end

    it 'should not return any APTC for given TaxHousehold' do
      expect(@thh.max_aptc).to be_nil
    end

    it 'should not return any Aptc determination for TaxHouseholdMembers' do
      @thh.tax_household_members.each do |thhm|
        ped = thhm.product_eligibility_determination
        expect(ped.is_ia_eligible).not_to eq(true)
      end
    end

    it 'should not return any MedicaidChip determination for TaxHouseholdMembers' do
      @thh.tax_household_members.each do |thhm|
        ped = thhm.product_eligibility_determination
        expect(ped.is_medicaid_chip_eligible).not_to eq(true)
      end
    end

    it 'should not return any MagiMedicaid determination for TaxHouseholdMembers' do
      @thh.tax_household_members.each do |thhm|
        ped = thhm.product_eligibility_determination
        expect(ped.is_magi_medicaid).not_to eq(true)
      end
    end

    it 'should not return any TotallyIneligible determination for TaxHouseholdMembers' do
      @thh.tax_household_members.each do |thhm|
        ped = thhm.product_eligibility_determination
        expect(ped.is_totally_ineligible).not_to eq(true)
      end
    end

    it 'should not return any WithoutAssistance determination for TaxHouseholdMembers' do
      @thh.tax_household_members.each do |thhm|
        ped = thhm.product_eligibility_determination
        expect(ped.is_without_assistance).not_to eq(true)
      end
    end

    it 'should not return any MagiMedicaid determination for TaxHouseholdMembers' do
      @thh.tax_household_members.each do |thhm|
        ped = thhm.product_eligibility_determination
        expect(ped.is_magi_medicaid).not_to eq(true)
      end
    end

    it 'should not return any Csr determination for TaxHouseholdMembers' do
      @thh.tax_household_members.each do |thhm|
        ped = thhm.product_eligibility_determination
        expect(ped.is_csr_eligible).not_to eq(true)
        expect(ped.csr).to be_nil
      end
    end

    it 'dwayne is eligible for both is_eligible_for_non_magi_reasons & uqhp_eligible' do
      expect(@dwayne_ped.is_eligible_for_non_magi_reasons).to eq(true)
      expect(@dwayne_ped.is_uqhp_eligible).to eq(true)
    end

    it 'betty is not eligible for both is_eligible_for_non_magi_reasons & uqhp_eligible' do
      expect(@betty_ped.is_eligible_for_non_magi_reasons).not_to eq(true)
      expect(@betty_ped.is_uqhp_eligible).not_to eq(true)
    end
  end

  # Aisha is MagiMedicaid eligible
  context 'cms simle test_case_c' do
    include_context 'cms ME simple_scenarios test_case_c'

    before do
      allow(HTTParty).to receive(:post).and_return(mitc_response)
      @thh = subject.call(input_application).success.tax_households.first
      @aisha_ped = @thh.tax_household_members.first.product_eligibility_determination
    end

    it 'should not return any APTC for given TaxHousehold' do
      expect(@thh.max_aptc).to be_nil
    end

    it 'should not return any Aptc determination for aisha' do
      expect(@aisha_ped.is_ia_eligible).not_to eq(true)
    end

    it 'should not return any MedicaidChip determination for aisha' do
      expect(@aisha_ped.is_medicaid_chip_eligible).not_to eq(true)
    end

    it 'should not return any eligibility for NonMagiReasons for aisha' do
      expect(@aisha_ped.is_eligible_for_non_magi_reasons).not_to eq(true)
    end

    it 'should not return any TotallyIneligible determination for aisha' do
      expect(@aisha_ped.is_totally_ineligible).not_to eq(true)
    end

    it 'should only return MagiMedicaid determination for aisha' do
      expect(@aisha_ped.is_magi_medicaid).to eq(true)
    end

    it 'should not return any Csr determination for aisha' do
      expect(@aisha_ped.is_csr_eligible).not_to eq(true)
      expect(@aisha_ped.csr).to be_nil
    end

    it 'should not return determination for is_magi_medicaid determination' do
      expect(@aisha_ped.is_magi_medicaid).to eq(true)
    end
  end

  # Gerald is APTC and CSR eligible
  context 'cms simle test_case_d' do
    include_context 'cms ME simple_scenarios test_case_d'

    before do
      allow(HTTParty).to receive(:post).and_return(mitc_response)
      result = subject.call(input_application)
      @thh = result.success.tax_households.first
      @gerald_ped = @thh.tax_household_members.first.product_eligibility_determination
    end

    it 'should return any APTC for given TaxHousehold' do
      expect(@thh.max_aptc).to eq(496.00)
      expect(@thh.max_aptc).not_to be_nil
    end

    it 'should return any Aptc determination for gerald' do
      expect(@gerald_ped.is_ia_eligible).to eq(true)
    end

    it 'should not return any MedicaidChip determination for gerald' do
      expect(@gerald_ped.is_medicaid_chip_eligible).not_to eq(true)
    end

    it 'should not return any eligibility for NonMagiReasons for gerald' do
      expect(@gerald_ped.is_eligible_for_non_magi_reasons).not_to eq(true)
    end

    it 'should not return any TotallyIneligible determination for gerald' do
      expect(@gerald_ped.is_totally_ineligible).not_to eq(true)
    end

    it 'should not return MagiMedicaid determination for gerald' do
      expect(@gerald_ped.is_magi_medicaid).not_to eq(true)
    end

    it 'should not return UQHP determination for gerald' do
      expect(@gerald_ped.is_uqhp_eligible).not_to eq(true)
    end

    it 'should return any Csr determination for gerald' do
      expect(@gerald_ped.is_csr_eligible).to eq(true)
      expect(@gerald_ped.csr).to eq('94')
    end
  end
end
