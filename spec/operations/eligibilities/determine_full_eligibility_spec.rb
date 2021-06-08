# frozen_string_literal: true

require 'rails_helper'
require "#{Rails.root}/spec/shared_contexts/eligibilities/magi_medicaid_application_data.rb"
Dir["#{Rails.root}/spec/shared_contexts/eligibilities/cms/me_simple_scenarios/*.rb"].sort.each { |file| require file }
require 'aca_entities/magi_medicaid/contracts/create_federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/contracts/federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/federal_poverty_level'
require 'aca_entities/operations/magi_medicaid/create_federal_poverty_level'

RSpec.describe ::Eligibilities::DetermineFullEligibility, dbclean: :after_each do
  it 'should be a container-ready operation' do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  let(:medicaid_request_payload) do
    ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
  end

  let(:medicaid_app) do
    FactoryBot.create(:application,
                      application_identifier: application_entity.hbx_id,
                      application_request_payload: input_application.to_json,
                      application_response_payload: nil,
                      medicaid_request_payload: medicaid_request_payload.to_json,
                      medicaid_response_payload: nil)
  end

  let(:input_params) do
    { medicaid_application_id: medicaid_app.application_identifier,
      medicaid_response_payload: mitc_response }
  end

  # Dwayne is UQHP eligible and eligible for non_magi_reasons
  context 'cms simle test_case_a' do
    include_context 'cms ME simple_scenarios test_case_a'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
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

    context 'for persistence' do
      before do
        medicaid_app.reload
        @aptc_household = medicaid_app.aptc_households.first
      end

      it 'should match with hbx_id' do
        expect(medicaid_app.application_identifier).to eq(application_entity.hbx_id)
      end

      it 'should match with application request payload' do
        expect(medicaid_app.application_request_payload).to eq(input_application.to_json)
      end

      it 'should match with application response payload' do
        expect(medicaid_app.application_response_payload).to eq(@application.to_json)
      end

      it 'should match with medicaid request payload' do
        expect(medicaid_app.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end

      it 'should match with medicaid response payload' do
        expect(medicaid_app.medicaid_response_payload).to eq(mitc_response.to_json)
      end

      it 'should match total_household_count' do
        expect(@aptc_household.total_household_count).to eq(2)
      end

      it 'should match annual_tax_household_income' do
        expect(@aptc_household.annual_tax_household_income).to eq(31_176.0)
      end

      it 'should match is_aptc_calculated' do
        expect(@aptc_household.is_aptc_calculated).to be_nil
      end

      it 'should match maximum_aptc_amount' do
        expect(@aptc_household.maximum_aptc_amount).to be_nil
      end

      it 'should match total_expected_contribution_amount' do
        expect(@aptc_household.total_expected_contribution_amount).to be_nil
      end

      it 'should match total_benchmark_plan_monthly_premium_amount' do
        expect(@aptc_household.total_benchmark_plan_monthly_premium_amount).to be_nil
      end

      it 'should match assistance_year' do
        expect(@aptc_household.assistance_year).to eq(Date.today.year)
      end

      it 'should match fpl_percent' do
        expect(@aptc_household.fpl_percent).to eq(180.83)
      end
    end
  end

  # Aisha is MagiMedicaid eligible
  context 'cms simle test_case_c' do
    include_context 'cms ME simple_scenarios test_case_c'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @thh = @application.tax_households.first
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

    context 'for persistence' do
      before { medicaid_app.reload }

      it 'should match with hbx_id' do
        expect(medicaid_app.application_identifier).to eq(application_entity.hbx_id)
      end

      it 'should match with application request payload' do
        expect(medicaid_app.application_request_payload).to eq(input_application.to_json)
      end

      it 'should match with application response payload' do
        expect(medicaid_app.application_response_payload).to eq(@application.to_json)
      end

      it 'should match with medicaid request payload' do
        expect(medicaid_app.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end

      it 'should match with medicaid response payload' do
        expect(medicaid_app.medicaid_response_payload).to eq(mitc_response.to_json)
      end
    end
  end

  # Gerald is APTC and CSR eligible
  context 'cms simle test_case_d' do
    include_context 'cms ME simple_scenarios test_case_d'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @thh = @application.tax_households.first
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

    context 'for persistence' do
      before do
        medicaid_app.reload
        @aptc_household = medicaid_app.aptc_households.first
        @bcm = @aptc_household.benchmark_calculation_members.first
        @ahm = @aptc_household.aptc_household_members.first
      end

      it 'should match with hbx_id' do
        expect(medicaid_app.application_identifier).to eq(application_entity.hbx_id)
      end

      it 'should match with application request payload' do
        expect(medicaid_app.application_request_payload).to eq(input_application.to_json)
      end

      it 'should match with application response payload' do
        expect(medicaid_app.application_response_payload).to eq(@application.to_json)
      end

      it 'should match with medicaid request payload' do
        expect(medicaid_app.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end

      it 'should match with medicaid response payload' do
        expect(medicaid_app.medicaid_response_payload).to eq(mitc_response.to_json)
      end

      it 'should match total_household_count' do
        expect(@aptc_household.total_household_count).to eq(1)
      end

      it 'should match annual_tax_household_income' do
        expect(@aptc_household.annual_tax_household_income).to eq(16_000.0)
      end

      it 'should match is_aptc_calculated' do
        expect(@aptc_household.is_aptc_calculated).to be_truthy
      end

      it 'should match maximum_aptc_amount' do
        expect(@aptc_household.maximum_aptc_amount).to eq(496.0)
      end

      it 'should match total_expected_contribution_amount' do
        expect(@aptc_household.total_expected_contribution_amount).to eq(0.0)
      end

      it 'should match total_benchmark_plan_monthly_premium_amount' do
        expect(@aptc_household.total_benchmark_plan_monthly_premium_amount).to eq(496.02)
      end

      it 'should match assistance_year' do
        expect(@aptc_household.assistance_year).to eq(Date.today.year)
      end

      it 'should match fpl_percent' do
        expect(@aptc_household.fpl_percent).to eq(125.39)
      end

      it 'should match member_identifier' do
        expect(@bcm.member_identifier).to eq(application_entity.applicants.first.person_hbx_id)
      end

      it 'should match relationship_kind_to_primary' do
        expect(@bcm.relationship_kind_to_primary).to eq('self')
      end

      it 'should match member_premium' do
        expect(@bcm.member_premium).to eq(496.02)
      end

      it 'should match member_premium' do
        expect(@ahm.member_identifier).to eq(application_entity.applicants.first.person_hbx_id)
      end

      it 'should match household_count' do
        expect(@ahm.household_count).to eq(1)
      end

      it 'should match annual_household_income_contribution' do
        expect(@ahm.annual_household_income_contribution).to eq(16_000.0)
      end

      it 'should match tax_filer_status' do
        expect(@ahm.tax_filer_status).to eq('tax_filer')
      end

      it 'should match is_applicant' do
        expect(@ahm.is_applicant).to eq(true)
      end

      it 'should match benchmark_plan_monthly_premium_amount' do
        expect(@ahm.benchmark_plan_monthly_premium_amount).to eq(496.02)
      end

      it 'should match aptc_eligible' do
        expect(@ahm.aptc_eligible).to eq(true)
      end

      it 'should match totally_ineligible' do
        expect(@ahm.totally_ineligible).to be_falsey
      end

      it 'should match uqhp_eligible' do
        expect(@ahm.uqhp_eligible).to be_falsey
      end

      it 'should match csr_eligible' do
        expect(@ahm.csr_eligible).to eq(true)
      end

      it 'should match csr' do
        expect(@ahm.csr).to eq('94')
      end
    end
  end
end
