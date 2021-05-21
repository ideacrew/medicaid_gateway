# frozen_string_literal: true

require 'rails_helper'
require "#{MitcService::Engine.root}/spec/shared_contexts/magi_medicaid_application_data.rb"
require "#{MitcService::Engine.root}/spec/shared_contexts/cms/me_simple_scenarios/test_case_a.rb"
require 'aca_entities/magi_medicaid/contracts/create_federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/contracts/federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/federal_poverty_level'
require 'aca_entities/operations/magi_medicaid/create_federal_poverty_level'

RSpec.describe ::MitcService::DetermineFullEligibility do
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

  context 'cms simle test_case_a' do
    include_context 'cms ME simple_scenarios test_case_a'

    before do
      allow(HTTParty).to receive(:post).and_return(mitc_response)
      @result = subject.call(input_application)
      @application = @result.success
      @thh = @application.tax_households.first
    end

    it 'should not return any APTC for given TaxHousehold' do
      expect(@thh.max_aptc).to be_zero
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

    it 'should not return any MedicaidChip determination for TaxHouseholdMembers' do
      @thh.tax_household_members.each do |thhm|
        ped = thhm.product_eligibility_determination
        expect(ped.is_medicaid_chip_eligible).not_to eq(true)
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

    it 'should return is_eligible_for_non_magi_reasons determination for dwayne' do
      dwayne_ped = @thh.tax_household_members.detect do |thhm|
        thhm.applicant_reference.person_hbx_id == dwayne[:person_hbx_id]
      end.product_eligibility_determination

      expect(dwayne_ped.is_eligible_for_non_magi_reasons).to eq(true)
    end

    it 'should not return is_eligible_for_non_magi_reasons determination for betty' do
      dwayne_ped = @thh.tax_household_members.detect do |thhm|
        thhm.applicant_reference.person_hbx_id == betty[:person_hbx_id]
      end.product_eligibility_determination

      expect(dwayne_ped.is_eligible_for_non_magi_reasons).not_to eq(true)
    end
  end
end
