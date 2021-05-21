# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'components/mitc_service/spec/shared_contexts/magi_medicaid_application_data')
require File.join(Rails.root, 'spec/shared_contexts/aptc_csr/two_applicants_data')
require 'aca_entities/magi_medicaid/contracts/create_federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/contracts/federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/federal_poverty_level'
require 'aca_entities/operations/magi_medicaid/create_federal_poverty_level'

describe AptcCsr::DetermineEligibility do
  context 'with one applicant being pregnant' do
    include_context 'setup magi_medicaid application with two applicants'
    let(:pregnancy_information2) do
      { is_pregnant: true,
        is_post_partum_period: false,
        expected_children_count: 1,
        pregnancy_due_on: Date.today.next_month }
    end

    let(:input_application) do
      app_params = mm_application_entity_with_mitc.to_h
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

    # it 'should return with aptc and csr determinations' do
    #   expect(@matching_th.max_aptc).to eq(@aptc_household.maximum_aptc_amount)
    #   expect(@matching_th.csr).to eq(@aptc_household.csr_percentage)
    # end

    # it 'should return a valid aptc amount' do
    #   expect(@matching_th.max_aptc).to eq(955.5)
    # end

    # it 'should return a valid csr amount' do
    #   expect(@matching_th.csr).to eq(94)
    # end
  end

  # context '2 applicants tiffany and thomas' do
  #   include_context 'setup magi_medicaid application with two applicants tiffany and thomas'
  #   let(:input_params) do
  #     { magi_medicaid_tax_household: input_tax_household,
  #       magi_medicaid_application: input_application }
  #   end

  #   before do
  #     @result = subject.call(input_params)
  #     @application = @result.success[:magi_medicaid_application]
  #     @aptc_household = @result.success[:aptc_household]
  #     @matching_th = @application.tax_households.detect do |thh|
  #       thh.hbx_id.to_s == input_tax_household.hbx_id.to_s
  #     end
  #   end

  #   it 'should return success' do
  #     expect(@result).to be_success
  #   end

  #   context 'should load all the required data on to MagiMedicaidApplication' do
  #     before do
  #       @tiffany_ped = @matching_th.tax_household_members.detect do |thhm|
  #         thhm.applicant_reference.person_hbx_id.to_s == tiffany[:person_hbx_id].to_s
  #       end.product_eligibility_determination

  #       @thomas_ped = @matching_th.tax_household_members.detect do |thhm|
  #         thhm.applicant_reference.person_hbx_id.to_s == thomas[:person_hbx_id].to_s
  #       end.product_eligibility_determination
  #     end

  #     it 'should return expected max aptc' do
  #       expect(@matching_th.max_aptc).to eq(183.00)
  #     end

  #     it 'should update insurance_assistance_eligiblility for THH' do
  #       expect(@matching_th.is_insurance_assistance_eligible).to eq('Yes')
  #     end

  #     it 'should return tiffany is eligible for aptc' do
  #       expect(@tiffany_ped.is_ia_eligible).to eq(true)
  #       expect(@tiffany_ped.is_medicaid_chip_eligible).to eq(false)
  #     end

  #     # Do we want to populate MedicaidEligibility in MedicaidGateway Engine?
  #     # it 'should return tiffany is eligible for medicaid' do
  #     #   expect(@tiffany_ped.is_ia_eligible).to eq(false)
  #     #   expect(@tiffany_ped.is_medicaid_chip_eligible).to eq(true)
  #     # end
  #   end

  #   context 'should load all the required data on to AptcHousehold' do
  #     it 'should return expected max aptc' do
  #       expect(@aptc_household.maximum_aptc_amount).to eq(183.00)
  #     end

  #     it 'should return expected is_aptc_calculated' do
  #       expect(@aptc_household.is_aptc_calculated).to eq(true)
  #     end

  #     it 'should return expected total_expected_contribution_amount' do
  #       expect(@aptc_household.total_expected_contribution_amount).to eq(3_761.42)
  #     end

  #     it 'should return expected total_benchmark_plan_monthly_premium_amount' do
  #       expect(@aptc_household.total_benchmark_plan_monthly_premium_amount * 12).to eq(5_952.24)
  #     end

  #     # it 'should return expected fpl_percent' do
  #     #   expect(@aptc_household.fpl_percent).to eq(256.00)
  #     # end

  #     # it 'should have only one member in aptc_calculation_members' do
  #     #   expect(@aptc_household.aptc_calculation_members.count).to eq(1)
  #     #   expect(@aptc_household.aptc_calculation_members.first.member_identifier.to_s).to eq(tiffany[:person_hbx_id].to_s)
  #     # end

  #     context 'aptc_household members' do
  #       before do
  #         @member_tiffany = @aptc_household.members.detect do |mmbr|
  #           mmbr.member_identifier.to_s == tiffany[:person_hbx_id].to_s
  #         end
  #         @member_thomas = @aptc_household.members.detect do |mmbr|
  #           mmbr.member_identifier.to_s == thomas[:person_hbx_id].to_s
  #         end
  #       end

  #       # it 'should return tiffany as aptc member' do
  #       #   expect(@member_tiffany.aptc_eligible).to eq(true)
  #       # end

  #       it 'should return thomas as non-aptc member' do
  #         expect(@member_thomas.aptc_eligible).to eq(false)
  #         # expect(@member_thomas.medicaid_eligible).to eq(true)
  #       end

  #       # it 'should return correct value for tiffany medicaid_fpl' do
  #       #   expect(@member_tiffany.medicaid_fpl).to eq(221)
  #       # end

  #       # it 'should return correct value for thomas medicaid_fpl' do
  #       #   expect(@member_thomas.medicaid_fpl).to eq(324)
  #       # end

  #       # it 'should set correct value for tiffany benchmark_plan_monthly_premium_amount' do
  #       #   expect(@member_tiffany.benchmark_plan_monthly_premium_amount * 12).to eq(5_952.24)
  #       # end
  #     end
  #   end
  # end
end
