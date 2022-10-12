# frozen_string_literal: true

require 'rails_helper'
require 'types'
require "#{Rails.root}/spec/shared_contexts/eligibilities/magi_medicaid_application_data.rb"

RSpec.describe ::Medicaid::Application, type: :model, dbclean: :after_each do
  include_context 'setup magi_medicaid application with two applicants'
  let(:application) { FactoryBot.create(:application)}

  context 'associations' do
    context 'embeds_many :aptc_households' do
      before do
        @association = described_class.reflect_on_association(:aptc_households)
      end

      it "should return association's class as EmbedsMany" do
        expect(@association.class).to eq(Mongoid::Association::Embedded::EmbedsMany)
      end

      it "should return association's name as aptc_households" do
        expect(@association.name).to eq(:aptc_households)
      end
    end
  end

  context 'valid params' do
    let(:input_params) do
      { application_identifier: '100001',
        application_request_payload: "{\"us_state\":\"DC\",\"hbx_id\":\"200000123\"}",
        application_response_payload: "{\"us_state\":\"DC\",\"hbx_id\":\"200000123\"}",
        medicaid_request_payload: "{\"Applicants\":[{\"Person ID\":95}]}",
        medicaid_response_payload: "{\"Applicants\":[{\"Person ID\":95}]}" }
    end

    before do
      @application = described_class.new(input_params)
      @application.save!
    end

    it 'should be findable' do
      expect(described_class.find(@application.id)).to be_a(::Medicaid::Application)
    end
  end

  context 'with a detailed application response payload' do
    let(:magi_medicaid_application_json) do
      application = magi_medicaid_application
      # prepare a non-applicant for testing
      application[:applicants].last[:is_applying_coverage] = false
      JSON.generate(application)
    end
    let(:medicaid_applicants) do
      "[{\"Person ID\":#{applicant_hash[:person_hbx_id]}}, {\"Person ID\":#{applicant2_hash[:person_hbx_id]}}]"
    end
    let(:input_params) do
      { application_identifier: '100004',
        application_request_payload: magi_medicaid_application_json,
        application_response_payload: magi_medicaid_application_json,
        medicaid_request_payload: "{\"Applicants\":#{medicaid_applicants}",
        medicaid_response_payload: "{\"Applicants\":#{medicaid_applicants}}" }
    end

    before do
      application.update(input_params)
      @application_response_entity = application.application_response_entity
      @person_hbx_id = applicant_hash[:person_hbx_id]
      @tax_household_member = @application_response_entity.tax_households.first.tax_household_members.first
      @slcsp_premium = BigDecimal(benchmark_premium[:health_only_slcsp_premiums].first[:monthly_premium].to_s)
    end

    it 'should be able to generate the fpl data' do
      fpl_keys = ['medicaid_year', 'annual_poverty_guideline']
      expect(application.fpl.stringify_keys.keys).to eq(fpl_keys)
      expect(application.fpl.values.any?(&:nil?)).to eq(false)
    end

    it 'should find the assistance year from the application response payload' do
      expect(application.assistance_year).to eq(Date.today.year)
    end

    it 'should calculate the fpl year based on the assistance year' do
      expect(application.fpl_year).to eq(application.assistance_year - 1)
    end

    it 'should find the premium from the application response payload' do
      expect(application.benchmarks.first.monthly_premium).to eq(@slcsp_premium)
    end

    it 'should find the primary HBX ID from the application response payload' do
      expect(application.primary_hbx_id).to eq(@person_hbx_id)
    end

    it 'should find the submission date and time from the application response payload' do
      expect(application.submitted_at).to eq(Date.today.to_datetime)
    end

    it 'should find all the applicants from the application response payload' do
      expect(application.applicants.count).to eq(2)
    end

    it 'should find the hbx ids of applicants applying for coverage from the application response payload' do
      expect(application.applicants_applying_for_coverage).to eq([@person_hbx_id])
    end

    it 'should find non-magi medicaid eligibility for the applicant from the application response payload' do
      expect(@tax_household_member.product_eligibility_determination.is_non_magi_medicaid_eligible).to eq(false)
    end

    it 'should find the attestations for the applicant from the application response payload' do
      expect(application.attestation_for(@person_hbx_id)).to eq(attestation)
    end

    it 'should find the daily living help indicator for the applicant from the application response payload' do
      expect(application.daily_living_help?(@person_hbx_id)).to eq(false)
    end

    it 'should find the irs consent details from the application request payload' do
      expect(application.irs_consent_details[:is_renewal_authorized]).to eq(true)
    end

    it 'should find the applicant immigration status from the application request payload' do
      expect(application.citizen_status_for(@person_hbx_id)).to eq("US citizen")
    end

    it 'should find the applicant tax filing status from the application request payload' do
      expect(application.tax_filer_kind_for(@person_hbx_id)).to eq("tax filer")
    end

    it 'should find the applicant relationship to primary from the application request payload' do
      dependent = @application_response_entity.applicants.last
      expect(application.relationship_for(dependent.person_hbx_id)).to eq("spouse")
    end

    it 'should find the applicant age from the application request payload' do
      expect(application.age_of_applicant_for(@person_hbx_id)).to eq("45")
    end
  end

  describe '#application_request_received?' do
    context 'with application_request_payload' do
      it 'should return true' do
        expect(application.application_request_received?).to be_truthy
      end
    end

    context 'without application_request_payload' do
      it 'should return false' do
        application.update_attribute(:application_request_payload, nil)
        expect(application.reload.application_request_received?).to be_falsey
      end
    end
  end

  describe '#magi_medicaid_determination_requested?' do
    context 'with medicaid_request_payload' do
      it 'should return true' do
        expect(application.magi_medicaid_determination_requested?).to be_truthy
      end
    end

    context 'without medicaid_request_payload' do
      it 'should return false' do
        application.update_attribute(:medicaid_request_payload, nil)
        expect(application.reload.magi_medicaid_determination_requested?).to be_falsey
      end
    end
  end

  describe '#magi_medicaid_determination_received?' do
    context 'with medicaid_response_payload' do
      it 'should return true' do
        expect(application.magi_medicaid_determination_received?).to be_truthy
      end
    end

    context 'without medicaid_response_payload' do
      it 'should return false' do
        application.update_attribute(:medicaid_response_payload, nil)
        expect(application.reload.magi_medicaid_determination_received?).to be_falsey
      end
    end
  end

  describe '#dynamic_slcsp_requested?' do
    context 'with dynamic_slcsp_request_payload' do
      it 'should return true' do
        expect(application.dynamic_slcsp_requested?).to be_truthy
      end
    end

    context 'without dynamic_slcsp_request_payload' do
      it 'should return false' do
        application.update_attribute(:dynamic_slcsp_request_payload, nil)
        expect(application.reload.dynamic_slcsp_requested?).to be_falsey
      end
    end
  end

  describe '#dynamic_slcsp_received?' do
    context 'with dynamic_slcsp_response_payload' do
      it 'should return true' do
        expect(application.dynamic_slcsp_received?).to be_truthy
      end
    end

    context 'without dynamic_slcsp_response_payload' do
      it 'should return false' do
        application.update_attribute(:dynamic_slcsp_response_payload, nil)
        expect(application.reload.dynamic_slcsp_received?).to be_falsey
      end
    end
  end

  describe '#application_response_published?' do
    context 'with application_response_payload' do
      it 'should return true' do
        expect(application.application_response_published?).to be_truthy
      end
    end

    context 'without application_response_payload' do
      it 'should return false' do
        application.update_attribute(:application_response_payload, nil)
        expect(application.reload.application_response_published?).to be_falsey
      end
    end
  end
end
