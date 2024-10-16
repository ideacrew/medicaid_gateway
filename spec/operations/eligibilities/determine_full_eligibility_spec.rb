# frozen_string_literal: true

require 'rails_helper'
require "#{Rails.root}/spec/shared_contexts/eligibilities/magi_medicaid_application_data.rb"
Dir["#{Rails.root}/spec/shared_contexts/eligibilities/cms/me_simple_scenarios/*.rb"].sort.each { |file| require file }
Dir["#{Rails.root}/spec/shared_contexts/eligibilities/cms/me_complex_scenarios/*.rb"].sort.each { |file| require file }
Dir["#{Rails.root}/spec/shared_contexts/eligibilities/cms/me_test_scenarios/*.rb"].sort.each { |file| require file }
Dir["#{Rails.root}/spec/shared_contexts/eligibilities/dc_test_scenarios/*.rb"].sort.each { |file| require file }
Dir["#{Rails.root}/spec/shared_contexts/eligibilities/esi_affordability/*.rb"].sort.each { |file| require file }
Dir["#{Rails.root}/spec/shared_contexts/eligibilities/gap_filling/*.rb"].sort.each { |file| require file }
Dir["#{Rails.root}/spec/shared_contexts/eligibilities/totally_ineligible/*.rb"].sort.each { |file| require file }
require 'aca_entities/magi_medicaid/contracts/create_federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/contracts/federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/federal_poverty_level'
require 'aca_entities/operations/magi_medicaid/create_federal_poverty_level'

RSpec.describe ::Eligibilities::DetermineFullEligibility, dbclean: :after_each do
  before do
    allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).and_call_original
    allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:atleast_one_silver_plan_donot_cover_pediatric_dental_cost).and_return(false)
  end

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

    it 'should not update hbx_id for given TaxHousehold' do
      expect(@thh.hbx_id).to eq(tax_hh[:hbx_id])
    end

    it 'should not return any APTC for given TaxHousehold' do
      expect(@thh.max_aptc).to be_nil
    end

    it 'should add effective_on for TaxHousehold' do
      expect(@thh.effective_on).to be_a(Date)
    end

    it 'should add determined_on for TaxHousehold' do
      expect(@thh.determined_on).to eq(Date.today)
    end

    it 'should not add csr_annual_income_limit for TaxHousehold' do
      expect(@thh.csr_annual_income_limit).to be_nil
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

      it 'should return a valid fpl_percent' do
        expect(@aptc_household.fpl_percent).not_to be_zero
        expect(@aptc_household.fpl_percent).not_to be_nil
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

    it 'should not update hbx_id for given TaxHousehold' do
      expect(@thh.hbx_id).to eq(tax_hh[:hbx_id])
    end

    it 'should not return any APTC for given TaxHousehold' do
      expect(@thh.max_aptc).to be_nil
    end

    it 'should add effective_on for TaxHousehold' do
      expect(@thh.effective_on).to be_a(Date)
    end

    it 'should add determined_on for TaxHousehold' do
      expect(@thh.determined_on).to eq(Date.today)
    end

    it 'should not add csr_annual_income_limit for TaxHousehold' do
      expect(@thh.csr_annual_income_limit).to be_nil
    end

    it 'should not return any Aptc determination for aisha' do
      expect(@aisha_ped.is_ia_eligible).not_to eq(true)
    end

    it 'should not return any MedicaidChip determination for aisha' do
      expect(@aisha_ped.is_medicaid_chip_eligible).not_to eq(true)
    end

    # Indicator Code for Category determination 'Medicaid Non-MAGI Referral' is set to 'Y'.
    it 'returns NonMagiReasons eligibility for aisha' do
      expect(@aisha_ped.is_eligible_for_non_magi_reasons).to eq(true)
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

  # Applicant is only medicaid ineligible due to not being lawfully present but they are in between 18-20
  context "cms simle test_case_c_eligibility_override" do
    include_context "cms ME simple_scenarios test_case_c_eligibility_override"

    before do
      allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:eligibility_override).and_return(true)
      under_twenty_one_override_flag = MedicaidGatewayRegistry[:eligibility_override].setting(:mitc_override_not_lawfully_present_under_twenty_one)
      allow(under_twenty_one_override_flag).to receive(:item).and_return("true")
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @thh = @application.tax_households.first
      @aisha_ped = @thh.tax_household_members.first.product_eligibility_determination
    end

    it "should apply override and return determination for is_magi_medicaid determination" do
      expect(@aisha_ped.is_magi_medicaid).to eq(true)
    end
  end

  # applicant otherwise eligible for medicaid, but they are incarcerated
  context "cms simle test_case_c incarcerated" do
    include_context 'cms ME simple_scenarios test_case_c_incarcerated'

    before do
      allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).and_call_original
      allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:medicaid_eligible_incarcerated).and_return(true)
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @thh = @application.tax_households.first
      @aisha_ped = @thh.tax_household_members.first.product_eligibility_determination
    end

    it "should be magi medicaid eligible" do
      expect(@aisha_ped.is_magi_medicaid).to eq(true)
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

    it 'should not update hbx_id for given TaxHousehold' do
      expect(@thh.hbx_id).to eq(tax_hh[:hbx_id])
    end

    it 'should return any APTC for given TaxHousehold' do
      expect(@thh.max_aptc).to eq(496.00)
      expect(@thh.max_aptc).not_to be_nil
    end

    it 'should add effective_on for TaxHousehold' do
      expect(@thh.effective_on).to be_a(Date)
    end

    it 'should add determined_on for TaxHousehold' do
      expect(@thh.determined_on).to eq(Date.today)
    end

    it 'should add csr_annual_income_limit for TaxHousehold' do
      expect(@thh.csr_annual_income_limit).not_to be_nil
      expect(@thh.csr_annual_income_limit).to be_a(BigDecimal)
    end

    it 'should return any Aptc determination for gerald' do
      expect(@gerald_ped.is_ia_eligible).to eq(true)
    end

    it 'should not return any MedicaidChip determination for gerald' do
      expect(@gerald_ped.is_medicaid_chip_eligible).not_to eq(true)
    end

    # Indicator Code for Category determination 'Medicaid Non-MAGI Referral' is set to 'Y'.
    it 'returns NonMagiReasons eligibility for gerald' do
      expect(@gerald_ped.is_eligible_for_non_magi_reasons).to eq(true)
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

      it 'should return valid fpl_percent' do
        expect(@aptc_household.fpl_percent).not_to be_zero
        expect(@aptc_household.fpl_percent).not_to be_nil
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

  # Clayton	Morgan family
  context 'cms simle test_case_g' do
    include_context 'cms ME simple_scenarios test_case_g'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
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
    end
  end

  # LailaE family with APTC determinations for all the applicants who are applying for coverage
  context 'cms simle test_case_e' do
    include_context 'cms ME simple_scenarios test_case_e'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      before do
        @non_applicant = @application.applicants.detect { |appli| !appli.is_applying_coverage }
      end

      it 'should return correct determination' do
        @new_thhms.each do |thhm|
          if @non_applicant.person_hbx_id.to_s == thhm.applicant_reference.person_hbx_id.to_s
            expect(thhm.product_eligibility_determination.is_ia_eligible).to eq(false)
          else
            expect(thhm.product_eligibility_determination.is_ia_eligible).to eq(true)
          end
        end
      end
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
    end
  end

  # Soren Sharp family. Soren, Mia are APTC eligible, Christian, Monika are Medicaid eligible
  context 'cms simle test_case_f with state ME' do
    include_context 'cms ME simple_scenarios test_case_f'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:soren_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002516'
        end.product_eligibility_determination
      end

      let(:mia_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002517'
        end.product_eligibility_determination
      end

      let(:christian_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002518'
        end.product_eligibility_determination
      end

      let(:monika_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002519'
        end.product_eligibility_determination
      end

      it 'should return aptc result for Soren' do
        expect(soren_ped.is_ia_eligible).to eq(true)
      end

      it 'should return aptc result for Mia' do
        expect(mia_ped.is_ia_eligible).to eq(true)
      end

      it 'should return aptc result for Christian' do
        expect(christian_ped.is_medicaid_chip_eligible).to eq(true)
      end

      it 'should return medicaid_chip result for Monika' do
        expect(monika_ped.is_medicaid_chip_eligible).to eq(true)
      end
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
    end
  end

  # Betty	CurtisH family, Betty is MagiMedicaid eligible & Dwayne is Aptc eligible
  context 'cms simle test_case_h with state ME' do
    include_context 'cms ME simple_scenarios test_case_h'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:betty_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002629'
        end.product_eligibility_determination
      end

      let(:dwayne_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002630'
        end.product_eligibility_determination
      end

      it 'should return magi_medicaid result for betty' do
        expect(betty_ped.is_magi_medicaid).to eq(true)
      end

      it 'should return aptc result for dwayne' do
        expect(dwayne_ped.is_ia_eligible).to eq(true)
      end
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
    end
  end

  # Jane Doe
  context 'cms complex test_case_d with state ME' do
    include_context 'cms ME complex_scenarios test_case_d'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:jane_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002507'
        end.product_eligibility_determination
      end

      let(:jim_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002536'
        end.product_eligibility_determination
      end

      let(:baby_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002537'
        end.product_eligibility_determination
      end

      it 'should return uqhp result for jane' do
        expect(jane_ped.is_uqhp_eligible).to eq(true)
      end

      it 'should return uqhp result for jim' do
        expect(jim_ped.is_uqhp_eligible).to eq(true)
      end

      it 'should return medicaid_chip result for baby' do
        expect(baby_ped.is_medicaid_chip_eligible).to eq(true)
      end
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
    end
  end

  # Aisha is eligible for MagiMedicaid because of Medicaid Gap Filling
  # Medicaid Gap Filling case, medicaid_or_chip_denial
  context 'cms simple test_case_c_1 with state ME' do
    include_context 'cms ME simple_scenarios test_case_c_1'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:aisha_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1624987842340466'
        end.product_eligibility_determination
      end

      it 'should return magi medicaid result for aisha' do
        expect(aisha_ped.is_magi_medicaid).to eq(true)
      end

      it 'should return gap filling result for aisha' do
        expect(aisha_ped.is_gap_filling).to eq(true)
      end
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
    end
  end

  # SBMaya should be eligible for MagiMedicaid because of Medicaid Gap Filling,
  # but just because SBMaya attested that her medicaid_or_chip_termination in the last 90 days,
  # she is eligible for aqhp.
  context 'cms simple test_case_1_mgf_aqhp with state ME' do
    include_context 'cms ME simple_scenarios test_case_1_mgf_aqhp'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:sbmaya_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002733'
        end.product_eligibility_determination
      end

      it 'should return uqhp result for sbmaya' do
        expect(sbmaya_ped.is_uqhp_eligible).to eq(true)
      end
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
    end
  end

  # Fix MitC depending income counting issue
  context 'cms complex test_case_e with state ME' do
    include_context 'cms ME complex_scenarios test_case_e'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:grandpa_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002556'
        end.product_eligibility_determination
      end

      let(:sonny_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002557'
        end.product_eligibility_determination
      end

      let(:baby_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002558'
        end.product_eligibility_determination
      end

      it 'should return aqhp, csr & non_magi referral result for grandpa' do
        expect(grandpa_ped.is_ia_eligible).to eq(true)
        expect(grandpa_ped.is_csr_eligible).to eq(true)
        expect(grandpa_ped.is_eligible_for_non_magi_reasons).to eq(true)
      end

      it 'should return aqhp, csr & not non_magi referral result for sonny' do
        expect(sonny_ped.is_ia_eligible).to eq(true)
        expect(sonny_ped.is_csr_eligible).to eq(true)
        expect(sonny_ped.is_eligible_for_non_magi_reasons).to eq(false)
      end

      it 'should return both(Magi & Chip) medicaid results for baby' do
        expect(baby_ped.is_medicaid_chip_eligible).to eq(true)
        expect(baby_ped.is_magi_medicaid).to eq(true)
      end
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
    end
  end

  # Medicaid gap filling for Simple test_case_k
  context 'cms simple test_case_k with state ME' do
    include_context 'cms ME simple_scenarios test_case_k'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:sb_sarah_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002587'
        end.product_eligibility_determination
      end

      it 'should return aqhp result for SBSarah' do
        expect(sb_sarah_ped.is_ia_eligible).to eq(true)
        expect(sb_sarah_ped.is_csr_eligible).to eq(true)
      end
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
    end
  end

  # Non-MAGI referral missing if already eligible for MAGI Medicaid
  # Complex TestCaseE1
  context 'cms complex test_case_e_1 with state ME' do
    include_context 'cms ME complex_scenarios test_case_e_1'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:grandpa_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002556'
        end.product_eligibility_determination
      end

      let(:sonny_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002557'
        end.product_eligibility_determination
      end

      let(:baby_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002558'
        end.product_eligibility_determination
      end

      it 'should return aqhp, csr & non_magi_referral result for grandpa' do
        expect(grandpa_ped.is_ia_eligible).to eq(true)
        expect(grandpa_ped.is_csr_eligible).to eq(true)
        expect(grandpa_ped.is_eligible_for_non_magi_reasons).to eq(true)
      end

      it 'should return aqhp, csr result for sonny' do
        expect(sonny_ped.is_ia_eligible).to eq(true)
        expect(sonny_ped.is_csr_eligible).to eq(true)
      end

      it 'should return magi_medicaid/medicaid_chip & non_magi_referral result for baby' do
        expect(baby_ped.is_medicaid_chip_eligible).to eq(true)
        expect(baby_ped.is_magi_medicaid).to eq(true)
        expect(baby_ped.is_eligible_for_non_magi_reasons).to eq(true)
      end
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
    end
  end

  # US citizen applicant with income under 100% getting APTC instead of UQHP
  context 'cms me_test_scenarios test_one state ME' do
    include_context 'cms ME me_test_scenarios test_one'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:maya_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002733'
        end.product_eligibility_determination
      end

      it 'should return uqhp result for maya' do
        expect(maya_ped.is_uqhp_eligible).to eq(true)
      end
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
    end
  end

  # Medicaid eligibility for I-766 lawfully present immigrant due to Medicaid gap fill
  # Should not get Medicaid, but just because we are mocking for Mitc immigration_status
  # we are getting Medicaid from Mitc.
  context 'cms me_test_scenarios test_one state ME' do
    include_context 'cms ME me_test_scenarios test_two'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:brenda_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1005120'
        end.product_eligibility_determination
      end

      it 'should return is_magi_medicaid result for brenda' do
        expect(brenda_ped.is_magi_medicaid).to eq(true)
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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
    end
  end

  # Fix Eligibility response error 999
  # Child claimed by married filing separately parent given APTC,
  # but should be UQHP because of rule check_for_married_filing_separate
  context 'cms me_test_scenarios test_three state ME' do
    include_context 'cms ME me_test_scenarios test_three'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:kid_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002514'
        end.product_eligibility_determination
      end

      it 'should return uqhp result for kid' do
        expect(kid_ped.is_uqhp_eligible).to eq(true)
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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
    end
  end

  # Primary should get APTC instead of UQHP
  # We should not run Family Affordability test as the application's assistance year equal or less than 2022.
  context 'cms me_test_scenarios test_four state ME' do
    include_context 'cms ME me_test_scenarios test_four'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:jane_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002507'
        end.product_eligibility_determination
      end

      let(:jim_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002536'
        end.product_eligibility_determination
      end

      let(:baby_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002537'
        end.product_eligibility_determination
      end

      it 'should return aqhp, csr result for jane' do
        expect(jane_ped.is_ia_eligible).to eq(true)
        expect(jane_ped.is_csr_eligible).to eq(true)
        expect(jane_ped.csr).to eq('0')
      end

      it 'should return uqhp result for jim' do
        expect(jim_ped.is_uqhp_eligible).to eq(true)
      end

      it 'should return is_medicaid_chip_eligible result for baby' do
        expect(baby_ped.is_medicaid_chip_eligible).to eq(true)
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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
    end
  end

  # Child claimed by married filing separately parent given APTC,
  # but should be UQHP because of rule check_for_married_filing_separate
  context 'cms me_test_scenarios test_5 state ME' do
    include_context 'cms ME me_test_scenarios test_5'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:kid_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002514'
        end.product_eligibility_determination
      end

      it 'should return is_uqhp_eligible result for kid' do
        expect(kid_ped.is_uqhp_eligible).to eq(true)
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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
    end
  end

  # AI/AN member given eligibility of 87% CSR instead of 100%
  # CSR is 100 if attested to indian_tribe_member for Alex and if not it is 87
  context 'cms me_test_scenarios test_6 state ME' do
    include_context 'cms ME me_test_scenarios test_6'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:alex_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002502'
        end.product_eligibility_determination
      end

      let(:lynn_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002503'
        end.product_eligibility_determination
      end

      it 'should return aqhp, csr result for alex' do
        expect(alex_ped.is_ia_eligible).to eq(true)
        expect(alex_ped.is_csr_eligible).to eq(true)
        expect(alex_ped.csr).to eq('100')
      end

      it 'should return is_magi_medicaid result for lynn' do
        expect(lynn_ped.is_magi_medicaid).to eq(true)
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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
    end
  end

  # AI/AN member given eligibility of 87% CSR instead of 100%
  # SystemDate: xx/xx/2021
  # OEStartOn: xx/xx/2021
  #   Application:
  #     assistance_year: 2022
  context 'cms me_test_scenarios test_five state ME' do
    include_context 'cms ME me_test_scenarios test_five'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
      @thh = @application.tax_households.first
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    it 'should return tax households with correct effective dates' do
      expect(@thh.effective_on.year).to eq(@application.assistance_year)
      expect(@thh.effective_on.year).to eq(Date.today.year.next)
    end

    context 'for tax_household_members' do
      let(:alex_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002502'
        end.product_eligibility_determination
      end

      let(:lynn_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1002503'
        end.product_eligibility_determination
      end

      it 'should return aqhp, csr result for alex' do
        expect(alex_ped.is_ia_eligible).to eq(true)
        expect(alex_ped.is_csr_eligible).to eq(true)
        expect(alex_ped.csr).to eq('100')
      end

      it 'should return is_magi_medicaid result for lynn' do
        expect(lynn_ped.is_magi_medicaid).to eq(true)
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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
    end
  end

  # This test is to make sure the deduction amounts are reduced from annual_tax_household_income
  context 'cms me_test_scenarios test_six state ME' do
    include_context 'cms ME me_test_scenarios test_six'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
      @thh = @application.tax_households.first
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    it 'should return tax households with correct effective dates' do
      expect(@thh.effective_on.year).to eq(@application.assistance_year)
      expect(@thh.effective_on.year).to eq(Date.today.year.next)
    end

    context 'for tax_household_members' do
      let(:kyle_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1000590'
        end.product_eligibility_determination
      end

      let(:austin_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1000602'
        end.product_eligibility_determination
      end

      it 'should return aqhp, csr result for kyle' do
        expect(kyle_ped.is_ia_eligible).to eq(true)
        expect(kyle_ped.is_csr_eligible).to eq(true)
        expect(kyle_ped.csr).to eq('87')
      end

      it 'should not return any member determinations for austin' do
        expect(austin_ped.to_h.values).not_to include(true)
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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

      it 'should match with medicaid response payload' do
        expect(medicaid_app.medicaid_response_payload).to eq(mitc_response.to_json)
      end

      it 'should store annual_tax_household_income' do
        expect(medicaid_app.aptc_households.first.annual_tax_household_income).to eq(33_600.0)
      end

      it 'should return annual_tax_household_income matching with calculated income' do
        annual_income = @application.applicants.first.incomes.first.amount.to_f * 12
        annual_deduction = @application.applicants.first.deductions.first.amount.to_f * 12
        calculated_annual_income = annual_income - annual_deduction
        expect(medicaid_app.aptc_households.first.annual_tax_household_income).to eq(calculated_annual_income)
      end
    end
  end

  # This test is to make sure the deduction amounts are reduced from annual_tax_household_income
  context 'cms me_test_scenarios test_seven state ME' do
    include_context 'cms ME me_test_scenarios test_seven'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
      @thh = @application.tax_households.first
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    it 'should return tax households with correct effective dates' do
      expect(@thh.effective_on.year).to eq(@application.assistance_year)
      expect(@thh.effective_on.year).to eq(Date.today.year.next)
    end

    context 'for tax_household_members' do
      it 'should return all members as eligible for insurance assistance' do
        expect(@new_thhms.flat_map(&:product_eligibility_determination).map(&:is_ia_eligible).uniq).to eq([true])
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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

      it 'should match with medicaid response payload' do
        expect(medicaid_app.medicaid_response_payload).to eq(mitc_response.to_json)
      end
    end
  end

  # TaxHousehold effective date calculation
  context 'cms me_test_scenarios test_eight state ME' do
    include_context 'cms ME me_test_scenarios test_eight'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
      @thh = @application.tax_households.first
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    it 'should return tax households with correct effective dates' do
      expect(@thh.effective_on.year).to eq(@application.assistance_year)
      expect(@thh.effective_on.year).to eq(Date.today.year.next)
    end

    context 'for tax_household_members' do
      it 'should return member as eligible for Insurance Assistance' do
        expect(@new_thhms.first.product_eligibility_determination.is_ia_eligible).to be_truthy
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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

      it 'should match with medicaid response payload' do
        expect(medicaid_app.medicaid_response_payload).to eq(mitc_response.to_json)
      end
    end
  end

  # BenchmarkPremium health_and_dental_slcsp_premiums
  # Adult = IA & Child <19 = IA
  context 'cms me_test_scenarios test_nine state ME' do
    before do
      allow(Date).to receive(:today).and_return(Date.new(2021, 11, 2))
    end

    include_context 'cms ME me_test_scenarios test_nine'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
      @thh = @application.tax_households.first
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    it 'should return tax households with correct effective dates' do
      expect(@thh.effective_on.year).to eq(@application.assistance_year)
      expect(@thh.effective_on.year).to eq(Date.today.year.next)
    end

    context 'for tax_household_members' do
      let(:first_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1006404'
        end.product_eligibility_determination
      end

      let(:second_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1006405'
        end.product_eligibility_determination
      end

      it 'should return aqhp, csr result for first applicant' do
        expect(first_ped.is_ia_eligible).to eq(true)
        expect(first_ped.is_csr_eligible).to eq(true)
        expect(first_ped.csr).to eq('73')
      end

      it 'should return aqhp, csr result for second applicant' do
        expect(second_ped.is_ia_eligible).to eq(true)
        expect(second_ped.is_csr_eligible).to eq(true)
        expect(second_ped.csr).to eq('73')
      end

      it 'should return max_aptc' do
        expect(@thh.max_aptc).to eq(641.0)
        expect(@thh.max_aptc).not_to eq(581.0)
      end

      it 'should add yearly_expected_contribution for TaxHousehold' do
        expect(@thh.yearly_expected_contribution).not_to eq(0.0)
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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

      it 'should match with medicaid response payload' do
        expect(medicaid_app.medicaid_response_payload).to eq(mitc_response.to_json)
      end
    end
  end

  # BenchmarkPremium health_and_ped_dental_slcsp_premiums
  # Non-applicant adult = N/a & Child <19 = IA
  context 'cms me_test_scenarios test_ten state ME' do
    before do
      allow(Date).to receive(:today).and_return(Date.new(2021, 11, 2))
    end

    include_context 'cms ME me_test_scenarios test_ten'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
      @thh = @application.tax_households.first
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    it 'should return tax households with correct effective dates' do
      expect(@thh.effective_on.year).to eq(@application.assistance_year)
      expect(@thh.effective_on.year).to eq(Date.today.year.next)
    end

    context 'for tax_household_members' do
      let(:first_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1006410'
        end.product_eligibility_determination
      end

      let(:second_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1006411'
        end.product_eligibility_determination
      end

      it 'should not return any determination for first applicant as this member is non-applicant' do
        expect(first_ped.to_h.values.uniq).not_to include(true)
      end

      it 'should return is_magi_medicaid result for second applicant' do
        expect(second_ped.is_ia_eligible).to eq(true)
        expect(second_ped.is_csr_eligible).to eq(true)
        expect(second_ped.csr).to eq('73')
      end

      it 'should return max_aptc' do
        expect(@thh.max_aptc).to eq(154.0)
        expect(@thh.max_aptc).not_to eq(124.0)
      end

      it 'should add yearly_expected_contribution for TaxHousehold' do
        expect(@thh.yearly_expected_contribution).not_to eq(0.0)
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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

      it 'should match with medicaid response payload' do
        expect(medicaid_app.medicaid_response_payload).to eq(mitc_response.to_json)
      end
    end
  end

  # BenchmarkPremium health_and_ped_dental_slcsp_premiums
  # Adult = M/C & Child <19 = IA
  context 'cms me_test_scenarios test_eleven state ME' do
    before do
      allow(Date).to receive(:today).and_return(Date.new(2021, 11, 2))
    end

    include_context 'cms ME me_test_scenarios test_eleven'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
      @thh = @application.tax_households.first
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    it 'should return tax households with correct effective dates' do
      expect(@thh.effective_on.year).to eq(@application.assistance_year)
      expect(@thh.effective_on.year).to eq(Date.today.year.next)
    end

    context 'for tax_household_members' do
      let(:first_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1006420'
        end.product_eligibility_determination
      end

      let(:second_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1006422'
        end.product_eligibility_determination
      end

      it 'should return is_magi_medicaid result for first applicant' do
        expect(first_ped.is_magi_medicaid).to eq(true)
      end

      it 'should return is_ia_eligible, is_csr_eligible & csr result for second applicant' do
        expect(second_ped.is_ia_eligible).to eq(true)
        expect(second_ped.is_csr_eligible).to eq(true)
        expect(second_ped.csr).to eq('94')
      end

      it 'should return max_aptc' do
        expect(@thh.max_aptc).to eq(292.0)
        expect(@thh.max_aptc).not_to eq(262.0)
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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

      it 'should match with medicaid response payload' do
        expect(medicaid_app.medicaid_response_payload).to eq(mitc_response.to_json)
      end
    end
  end

  # NonApplicant with partial answers to Applicant related questions
  context 'cms me_test_scenarios test_twelve state ME' do
    before do
      allow(Date).to receive(:today).and_return(Date.new(2021, 11, 2))
    end

    include_context 'cms ME me_test_scenarios test_twelve'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
      @thh = @application.tax_households.first
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    it 'should return tax households with correct effective dates' do
      expect(@thh.effective_on.year).to eq(@application.assistance_year)
      expect(@thh.effective_on.year).to eq(Date.today.year.next)
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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

      it 'should match with medicaid response payload' do
        expect(medicaid_app.medicaid_response_payload).to eq(mitc_response.to_json)
      end
    end
  end

  # Ichra Affordable test
  context 'cms me_test_scenarios test_thirteen state ME' do
    include_context 'cms ME me_test_scenarios test_thirteen'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
      @thh = @application.tax_households.first
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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

      it 'should match with medicaid response payload' do
        expect(medicaid_app.medicaid_response_payload).to eq(mitc_response.to_json)
      end
    end
  end

  # Multiple Spouses case
  # A is spouse to B, C is spouse to D and both C, D are tax dependents to A
  context 'cms me_test_scenarios test_14 state ME' do
    include_context 'cms ME me_test_scenarios test_14'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
      @thh = @application.tax_households.first
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:first_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1039699'
        end.product_eligibility_determination
      end

      let(:second_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1039708'
        end.product_eligibility_determination
      end

      it 'should return APTC and CSR determinations for first applicant' do
        expect(first_ped.is_ia_eligible).to eq(true)
        expect(first_ped.is_csr_eligible).to eq(true)
        expect(first_ped.csr).to eq('87')
      end

      it 'should return APTC and CSR determinations for second applicant' do
        expect(second_ped.is_ia_eligible).to eq(true)
        expect(second_ped.is_csr_eligible).to eq(true)
        expect(second_ped.csr).to eq('87')
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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

      it 'should match with medicaid response payload' do
        expect(medicaid_app.medicaid_response_payload).to eq(mitc_response.to_json)
      end
    end
  end

  # Parent is getting APTC/CSR as expected. Child is getting UQHP instead of APTC/CSR
  # when a person answered 'yes' to Will this person file taxes for 2021? *
  # And answered 'no' to Will this person be claimed as a tax dependent for 2021? *
  # Then the person passes tax_filing rule to be eligible for APTC/CSR
  context 'cms me_test_scenarios test_7 state ME' do
    include_context 'cms ME me_test_scenarios test_7'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:parent_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1003362'
        end.product_eligibility_determination
      end

      let(:child_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '1003363'
        end.product_eligibility_determination
      end

      it 'should return aqhp, csr result for parent' do
        expect(parent_ped.is_ia_eligible).to eq(true)
        expect(parent_ped.is_csr_eligible).to eq(true)
        expect(parent_ped.csr).to eq('94')
      end

      it 'should return is_magi_medicaid result for child' do
        expect(child_ped.is_ia_eligible).to eq(true)
        expect(child_ped.is_csr_eligible).to eq(true)
        expect(child_ped.csr).to eq('87')
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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
    end
  end

  # Someone who is incarcerated should not be found to be Medicaid Eligible
  # note: this scenario only holds true when medicaid_eligible_incarcerated is disabled
  context 'dc_test_scenarios oc_10' do
    include_context 'dc_test_scenarios oc_10'

    before do
      allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).and_call_original
      allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:medicaid_eligible_incarcerated).and_return(false)
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '212'
        end.product_eligibility_determination
      end

      it 'should not return medicaid, aqhp, or csr result' do
        expect(ped.is_ia_eligible).to eq(false)
        expect(ped.is_magi_medicaid).to eq(false)
        expect(ped.is_medicaid_chip_eligible).to eq(false)
        expect(ped.is_csr_eligible).to eq(false)
        expect(ped.is_totally_ineligible).to eq(true)
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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
    end
  end

  # Someone who has an affordable past esi benefit should still be ATPC eligible
  context 'dc_test_scenarios past_benefit' do
    include_context 'dc_test_scenarios past_benefit'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
      @aptc_household = @result.success[:aptc_household]
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '212'
        end.product_eligibility_determination
      end

      it 'should return aqhp and get an aptc amount' do
        expect(@application.tax_households.first.max_aptc).not_to be_nil
        expect(ped.is_ia_eligible).to eq(true)
      end

    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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
    end
  end

  # The expected results is for the consumer to be eligible for UQHP due to indicating they will not file taxes
  context 'dc_test_scenarios primary non tax filer' do
    include_context 'dc_test_scenarios primary_non_tax_filer'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @thh = @application.tax_households.first
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
      @primary_hbx_id = @application.applicants.detect(&:is_primary_applicant).person_hbx_id
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_households' do
      it 'should not return any APTC for given TaxHousehold' do
        expect(@thh.max_aptc).to be_nil
      end
    end

    context 'for tax_household_members' do
      let(:primary_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == @primary_hbx_id
        end.product_eligibility_determination
      end

      it 'should return primary as uqhp eligible' do
        expect(primary_ped.is_uqhp_eligible).to eq(true)
      end

      it 'should not return primary as csr eligible' do
        expect(primary_ped.is_csr_eligible).to eq(false)
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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
    end
  end

  # Expected outcome is UQHP b/c person is above the 65 age limit, and they reported that they have Medicare
  context 'dc_test_scenarios oc_1' do
    include_context 'dc_test_scenarios oc_1'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '99'
        end.product_eligibility_determination
      end

      it 'should not return aqhp or csr eligible' do
        expect(ped.is_ia_eligible).to eq(false)
        expect(ped.is_csr_eligible).to eq(false)
      end

      it 'should not return medicaid/chip eligible' do
        expect(ped.is_magi_medicaid).to eq(false)
        expect(ped.is_medicaid_chip_eligible).to eq(false)
      end

      it 'should return uqhp eligible' do
        expect(ped.is_uqhp_eligible).to eq(true)
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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
    end
  end

  # Any member of the tax household may enroll in a QHP through any of the Exchanges for which one of the tax filers meets the residency standard,
  # so dependent can receive an APTC determination, if eligible (not a DC resident so therefore immediately not eligible for Medicaid)
  context 'dc_test_scenarios qa_core_3_magi_020' do
    include_context 'dc_test_scenarios qa_core_3_magi_020'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:primary_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '21210142'
        end.product_eligibility_determination
      end

      let(:spouse_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '21210143'
        end.product_eligibility_determination
      end

      let(:child_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '21210144'
        end.product_eligibility_determination
      end

      context 'primary determinations' do
        it 'should not return aqhp or csr eligible' do
          expect(primary_ped.is_ia_eligible).to eq(false)
          expect(primary_ped.is_csr_eligible).to eq(false)
        end

        it 'should return medicaid eligible' do
          expect(primary_ped.is_magi_medicaid).to eq(true)
        end

        it 'should not return uqhp eligible' do
          expect(primary_ped.is_uqhp_eligible).to eq(nil)
        end
      end

      context 'spouse determinations' do
        it 'should not return aqhp or csr eligible' do
          expect(spouse_ped.is_ia_eligible).to eq(false)
          expect(spouse_ped.is_csr_eligible).to eq(false)
        end

        it 'should return medicaid eligible' do
          expect(spouse_ped.is_magi_medicaid).to eq(true)
        end

        it 'should not return uqhp eligible' do
          expect(spouse_ped.is_uqhp_eligible).to eq(nil)
        end
      end

      # APTC Household income is less than 100% FPL
      context 'child determinations' do
        it 'should not return aqhp or csr eligible' do
          expect(child_ped.is_ia_eligible).to eq(false)
          expect(child_ped.is_csr_eligible).to eq(false)
        end

        it 'should not return medicaid eligible' do
          expect(child_ped.is_magi_medicaid).to eq(false)
        end

        it 'should return uqhp eligible' do
          expect(child_ped.is_uqhp_eligible).to eq(true)
        end
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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
    end
  end

  # Any member of the tax household may enroll in a QHP through any of the Exchanges for which one of the tax filers meets the residency standard,
  # so dependent should receive UQHP determination, if eligible (not a DC resident so therefore immediately not eligible for Medicaid)
  context 'dc_test_scenarios qa_core_4_magi_ua_009' do
    include_context 'dc_test_scenarios qa_core_4_magi_ua_009'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:primary_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '21210282'
        end.product_eligibility_determination
      end

      let(:spouse_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '21210283'
        end.product_eligibility_determination
      end

      let(:child_1_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '21210284'
        end.product_eligibility_determination
      end

      let(:child_2_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '21210285'
        end.product_eligibility_determination
      end

      context 'primary determinations' do
        it 'should not return aqhp or csr eligible' do
          expect(primary_ped.is_ia_eligible).to eq(false)
          expect(primary_ped.is_csr_eligible).to eq(false)
        end

        it 'should not return medicaid eligible' do
          expect(primary_ped.is_magi_medicaid).to eq(false)
        end

        it 'should return uqhp eligible' do
          expect(primary_ped.is_uqhp_eligible).to eq(true)
        end
      end

      context 'spouse determinations' do
        it 'should not return aqhp or csr eligible' do
          expect(spouse_ped.is_ia_eligible).to eq(false)
          expect(spouse_ped.is_csr_eligible).to eq(false)
        end

        it 'should not return medicaid eligible' do
          expect(spouse_ped.is_magi_medicaid).to eq(false)
        end

        it 'should return uqhp eligible' do
          expect(spouse_ped.is_uqhp_eligible).to eq(true)
        end
      end

      context 'child 1 determinations' do
        it 'should not return aqhp or csr eligible' do
          expect(child_1_ped.is_ia_eligible).to eq(false)
          expect(child_1_ped.is_csr_eligible).to eq(false)
        end

        it 'should not return medicaid eligible' do
          expect(child_1_ped.is_magi_medicaid).to eq(false)
        end

        it 'should return uqhp eligible' do
          expect(child_1_ped.is_uqhp_eligible).to eq(true)
        end
      end

      context 'child 2 determinations' do
        it 'should not return aqhp or csr eligible' do
          expect(child_2_ped.is_ia_eligible).to eq(false)
          expect(child_2_ped.is_csr_eligible).to eq(false)
        end

        it 'should return medicaid eligible' do
          expect(child_2_ped.is_magi_medicaid).to eq(true)
        end

        it 'should not return uqhp eligible' do
          expect(child_2_ped.is_uqhp_eligible).to eq(nil)
        end
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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
    end
  end

  # Expected outcome is UQHP for person 1 b/c person is eligible for americorps_health_benefits, but is_ia for person 2
  context 'dc_test_scenarios americorps' do
    include_context 'dc_test_scenarios americorps'

    before do
      allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).and_call_original
      allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:additional_ineligible_types).and_return(true)
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '99'
        end.product_eligibility_determination
      end

      let(:ped2) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '100'
        end.product_eligibility_determination
      end

      it 'should not return aqhp or csr eligible for person 1' do
        expect(ped.is_ia_eligible).to eq(false)
        expect(ped.is_csr_eligible).to eq(false)
      end

      it 'should return uqhp eligible for person 1' do
        expect(ped.is_uqhp_eligible).to eq(true)
      end

      it 'should return aqhp eligible for person 2' do
        expect(ped2.is_ia_eligible).to eq(true)
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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
    end
  end

  # Expected outcome is APTC because applicant is temporarily out of state (therefore Medicaid ineligible)
  context 'dc_test_scenarios oc_5' do
    include_context 'dc_test_scenarios oc_5'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @thh = @application.tax_households.first
      @new_thhms = @thh.tax_household_members
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for tax_household_members' do
      let(:ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '21210135'
        end.product_eligibility_determination
      end

      it 'should return aptc eligible' do
        expect(ped.is_ia_eligible).to eq(true)
      end

      it 'should return max_aptc' do
        expect(@thh.max_aptc).not_to eq(nil)
      end

      it 'should not return medicaid/chip eligible' do
        expect(ped.is_magi_medicaid).to eq(false)
        expect(ped.is_medicaid_chip_eligible).to eq(false)
      end

      it 'should not return uqhp eligible' do
        expect(ped.is_uqhp_eligible).to eq(nil)
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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
    end
  end

  # ESI affordability test_1_10103187
  context 'esi_affordability test_1_10103187' do
    include_context 'esi_affordability test_1_10103187'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @peds = @application.tax_households.first.tax_household_members.flat_map(&:product_eligibility_determination)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for product_eligibility_determinations' do
      it 'should return uqhp eligible for primary' do
        expect(@peds.first.is_uqhp_eligible).to eq(true)
      end

      it 'should return aptc eligible for spouse' do
        expect(@peds[1].is_ia_eligible).to eq(true)
      end

      it 'should return aptc eligible for dependent' do
        expect(@peds[2].is_ia_eligible).to eq(true)
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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
    end
  end

  # ESI affordability test_10103188
  context 'esi_affordability test_10103188' do
    include_context 'esi_affordability test_10103188'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @peds = @application.tax_households.first.tax_household_members.flat_map(&:product_eligibility_determination)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for product_eligibility_determinations' do
      it 'should return uqhp eligible for primary' do
        expect(@peds.first.is_uqhp_eligible).to eq(true)
      end

      it 'should return uqhp eligible for spouse' do
        expect(@peds[1].is_uqhp_eligible).to eq(true)
      end

      it 'should return aptc eligible for dependent' do
        expect(@peds[2].is_ia_eligible).to eq(true)
      end
    end

    context 'for persistence' do
      before do
        medicaid_app.reload
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
    end
  end

  # ESI affordability test_10103189
  context 'esi_affordability test_10103189' do
    include_context 'esi_affordability test_10103189'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @peds = @application.tax_households.first.tax_household_members.flat_map(&:product_eligibility_determination)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for product_eligibility_determinations' do
      it 'should return uqhp determinations for all members' do
        expect(@peds.map(&:is_uqhp_eligible)).to eq([true, true, true])
      end
    end
  end

  # ESI affordability test_10103192
  context 'esi_affordability test_10103192' do
    include_context 'esi_affordability test_10103192'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @peds = @application.tax_households.first.tax_household_members.flat_map(&:product_eligibility_determination)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for product_eligibility_determinations' do
      it 'should return aqhp determinations for all members' do
        expect(@peds.map(&:is_ia_eligible)).to eq([true, true, true])
      end
    end
  end

  # Family ESI affordability test_10103192
  context 'esi_affordability test_10103192' do
    include_context 'esi_affordability test_10103192'
    let(:health_plan_meets_mvs_and_affordable) { [true, nil].sample }

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @peds = @application.tax_households.first.tax_household_members.flat_map(&:product_eligibility_determination)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for product_eligibility_determinations' do
      it 'should return ineligible aqhp determinations for primary' do
        expect(@peds.map(&:is_ia_eligible)).to eq([false, true, true])
        expect(@peds.map(&:is_uqhp_eligible)).to eq([true, nil, nil])
      end
    end
  end

  # ESI affordability test_10103191
  context 'esi_affordability test_10103191' do
    include_context 'esi_affordability test_10103191'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @peds = @application.tax_households.first.tax_household_members.flat_map(&:product_eligibility_determination)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for product_eligibility_determinations' do
      it 'should return aqhp determinations for all members' do
        expect(@peds.map(&:is_ia_eligible)).to eq([true, true, true])
      end
    end
  end

  # Family ESI affordability test_10103191
  context 'esi_affordability test_10103191' do
    include_context 'esi_affordability test_10103191'
    let(:health_plan_meets_mvs_and_affordable) { [true, nil].sample }

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @peds = @application.tax_households.first.tax_household_members.flat_map(&:product_eligibility_determination)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for product_eligibility_determinations' do
      it 'should return ineligible aqhp determinations for primary and spouse' do
        expect(@peds.map(&:is_ia_eligible)).to eq([false, false, true])
        expect(@peds.map(&:is_uqhp_eligible)).to eq([true, true, nil])
      end
    end
  end

  # ESI affordability test_10103190
  context 'esi_affordability test_10103190' do
    include_context 'esi_affordability test_10103190'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @peds = @application.tax_households.first.tax_household_members.flat_map(&:product_eligibility_determination)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for product_eligibility_determinations' do
      it 'should return aqhp determinations for all members' do
        expect(@peds.map(&:is_ia_eligible)).to eq([true, true, true])
      end
    end
  end

  # Family ESI affordability test_10103190
  context 'esi_affordability test_10103190' do
    include_context 'esi_affordability test_10103190'
    let(:health_plan_meets_mvs_and_affordable) { [true, nil].sample }

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @peds = @application.tax_households.first.tax_household_members.flat_map(&:product_eligibility_determination)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for product_eligibility_determinations' do
      it 'should return all members ineligible for aqhp and eligible for uqhp' do
        expect(@peds.map(&:is_ia_eligible)).to eq([false, false, false])
        expect(@peds.map(&:is_uqhp_eligible)).to eq([true, true, true])
      end
    end
  end

  # unqualified immigrant getting eligibility results
  # 2 Domestic partners: Primary is a non tax filer income $130,000, Partner is an unqualified immigrant
  context 'totally_inelgible_domestic_partner state ME' do
    include_context 'cms ME me_test_scenarios totally_inelgible_domestic_partner'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @new_thhms = @application.tax_households.flat_map(&:tax_household_members)
    end

    it 'should return application' do
      expect(@application).to be_a(::AcaEntities::MagiMedicaid::Application)
    end

    context 'for product_eligibility_determinations' do
      let(:primary_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '10101903'
        end.product_eligibility_determination
      end

      let(:partner_ped) do
        @new_thhms.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == '10101905'
        end.product_eligibility_determination
      end

      it 'should return primary eligible for uqhp' do
        expect(primary_ped.is_ia_eligible).to eq(false)
        expect(primary_ped.is_uqhp_eligible).to eq(true)
        expect(primary_ped.is_totally_ineligible).to eq(nil)
      end

      it 'should return partner totally_ineligible' do
        expect(partner_ped.is_ia_eligible).to eq(false)
        expect(partner_ped.is_uqhp_eligible).to eq(nil)
        expect(partner_ped.is_totally_ineligible).to eq(true)
      end
    end

  end

  # Family ESI affordability test_10103190 esi_covered
  context 'esi_affordability test_10103190 esi_covered' do
    include_context 'esi_affordability test_10103190'
    let(:primary_benefit) do
      { "name" => nil,
        "kind" => "employer_sponsored_insurance",
        "status" => "is_eligible",
        "is_employer_sponsored" => false,
        "employer" => { "employer_name" => "MM", "employer_id" => "57-1036710" },
        "esi_covered" => 'self',
        "is_esi_waiting_period" => is_esi_waiting_period,
        "is_esi_mec_met" => is_esi_mec_met,
        "employee_cost" => employee_cost,
        "employee_cost_frequency" => "Weekly",
        "start_on" => start_of_year.to_s,
        "end_on" => nil,
        "submitted_at" => start_of_year.to_s,
        "hra_kind" => nil,
        "health_plan_meets_mvs_and_affordable" => false }
    end

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @peds = @application.tax_households.first.tax_household_members.flat_map(&:product_eligibility_determination)
    end

    context "Minimum value standard: is_esi_mec_met: false" do
      let(:is_esi_mec_met) { false }
      let(:is_esi_waiting_period) { true }
      let(:employee_cost) { "1000.0" }

      it 'should return all members eligible for aqhp' do
        expect(@peds.map(&:is_ia_eligible)).to eq([true, true, true])
      end
    end

    context "Waiting period: is_esi_waiting_period: true, start_on date is later than eligibility date" do
      let(:is_esi_mec_met) { true }
      let(:is_esi_waiting_period) { true }
      let(:employee_cost) { "1000.0" }

      it 'should return all members eligible for aqhp' do
        expect(@peds.map(&:is_ia_eligible)).to eq([true, true, true])
      end
    end

    context "Determine affordability: employee premium as a percent of income > affordability threshold" do
      let(:is_esi_mec_met) { true }
      let(:is_esi_waiting_period) { false }
      let(:employee_cost) { "1000.0" }

      it 'should return all members eligible for aqhp' do
        expect(@peds.map(&:is_ia_eligible)).to eq([true, true, true])
      end
    end

    context "Determine affordability: employee premium as a percent of income < affordability threshold" do
      let(:is_esi_mec_met) { true }
      let(:is_esi_waiting_period) { false }
      let(:employee_cost) { "10.0" }

      it 'should return all members eligible for aqhp except for the employee' do
        expect(@peds.map(&:is_ia_eligible)).to eq([false, true, true])
      end
    end
  end

  # esi_affordability test_3150481
  # 2022, health_plan_meets_mvs_and_affordable: true, esi_covered: 'family'
  context 'esi_affordability test_3150481' do
    include_context 'esi_affordability test_3150481'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @peds = @application.tax_households.first.tax_household_members.flat_map(&:product_eligibility_determination)
    end

    context 'for product_eligibility_determinations' do
      it 'should return all members ineligible for aqhp and eligible for uqhp' do
        expect(@peds.map(&:is_ia_eligible)).to eq([false, false, false])
        expect(@peds.map(&:is_uqhp_eligible)).to eq([true, true, true])
      end
    end
  end

  # 2022, health_plan_meets_mvs_and_affordable: true, esi_covered: 'self_and_spouse'
  context 'esi_affordability test_3150481' do
    include_context 'esi_affordability test_3150481'
    let(:esi_covered) { 'self_and_spouse' }

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @peds = @application.tax_households.first.tax_household_members.flat_map(&:product_eligibility_determination)
    end

    context 'for product_eligibility_determinations' do
      it 'should return employee ineligible for aqhp and eligible for uqhp' do
        expect(@peds.map(&:is_ia_eligible)).to eq([false, false, true])
        expect(@peds.map(&:is_uqhp_eligible)).to eq([true, true, nil])
      end
    end
  end

  # 2022, health_plan_meets_mvs_and_affordable: true, esi_covered: 'self'
  context 'esi_affordability test_3150481' do
    include_context 'esi_affordability test_3150481'
    let(:esi_covered) { 'self' }

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @peds = @application.tax_households.first.tax_household_members.flat_map(&:product_eligibility_determination)
    end

    context 'for product_eligibility_determinations' do
      it 'should return employee ineligible for aqhp and eligible for uqhp' do
        expect(@peds.map(&:is_ia_eligible)).to eq([false, true, true])
        expect(@peds.map(&:is_uqhp_eligible)).to eq([true, nil, nil])
      end
    end
  end

  # 2023, health_plan_meets_mvs_and_affordable: true, esi_covered: 'family'
  context 'esi_affordability test_3150481' do
    include_context 'esi_affordability test_3150481'
    let(:assistance_year) { 2023 }

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @peds = @application.tax_households.first.tax_household_members.flat_map(&:product_eligibility_determination)
    end

    context 'for product_eligibility_determinations' do
      it 'should return employee ineligible for aqhp and eligible for uqhp' do
        expect(@peds.map(&:is_ia_eligible)).to eq([false, false, false])
        expect(@peds.map(&:is_uqhp_eligible)).to eq([true, true, true])
      end
    end
  end

  # 2023, health_plan_meets_mvs_and_affordable: true, esi_covered: 'self'
  context 'esi_affordability test_3150481' do
    include_context 'esi_affordability test_3150481'
    let(:assistance_year) { 2023 }
    let(:health_plan_meets_mvs_and_affordable) { false }
    let(:esi_covered) { 'self' }

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @peds = @application.tax_households.first.tax_household_members.flat_map(&:product_eligibility_determination)
    end

    context 'for product_eligibility_determinations' do
      it 'should return employee ineligible for aqhp and eligible for uqhp' do
        expect(@peds.map(&:is_ia_eligible)).to eq([false, true, true])
        expect(@peds.map(&:is_uqhp_eligible)).to eq([true, nil, nil])
      end
    end
  end

  # 2023, health_plan_meets_mvs_and_affordable: true, esi_covered: 'self_and_spouse'
  context 'esi_affordability test_3150481' do
    include_context 'esi_affordability test_3150481'
    let(:assistance_year) { 2023 }
    let(:health_plan_meets_mvs_and_affordable) { false }
    let(:esi_covered) { 'self_and_spouse' }

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @peds = @application.tax_households.first.tax_household_members.flat_map(&:product_eligibility_determination)
    end

    context 'for product_eligibility_determinations' do
      it 'should return employee ineligible for aqhp and eligible for uqhp' do
        expect(@peds.map(&:is_ia_eligible)).to eq([false, true, true])
        expect(@peds.map(&:is_uqhp_eligible)).to eq([true, nil, nil])
      end
    end
  end

  # 3.2.2 Minimum federal poverty level
  context 'gap_filling test_2570928' do
    include_context 'gap_filling test_2570928'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @peds = @application.tax_households.first.tax_household_members.flat_map(&:product_eligibility_determination)
    end

    context 'for product_eligibility_determinations' do
      it 'should return member eligible for uqhp' do
        expect(@peds.map(&:is_uqhp_eligible)).to eq([true])
      end
    end
  end

  # Gap filling logic incorrectly overriding APTC eligibility where the household is not eligible for Medicaid
  # due to recent denial or immigration status
  context 'gap_filling test_1321470' do
    include_context 'gap_filling test_1321470'

    before do
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @peds = @application.tax_households.first.tax_household_members.flat_map(&:product_eligibility_determination)
    end

    context 'for product_eligibility_determinations' do
      it 'should return member eligible for Insurance Assistance' do
        expect(@peds.map(&:is_ia_eligible)).to eq([true, true, true, true])
      end
    end
  end

  # Incarcerated applicant who is NOT otherwise eligible for Medicaid should be totally ineligible
  context 'incarcerated applicant not eligible for Medicaid' do
    include_context 'totally_ineligible incarcerated_medicaid_ineligible'

    before do
      allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).and_call_original
      allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:medicaid_eligible_incarcerated).and_return(true)
      @result = subject.call(input_params)
      @application = @result.success[:payload]
      @ped = @application.tax_households.first.tax_household_members.first.product_eligibility_determination
    end

    it 'should return totally_ineligible as true' do
      expect(@ped.is_totally_ineligible).to eq(true)
    end
  end
end
