# frozen_string_literal: true

require 'rails_helper'
require 'types'
require "#{Rails.root}/spec/shared_contexts/eligibilities/magi_medicaid_application_data.rb"

RSpec.describe ::Medicaid::Application, type: :model, dbclean: :after_each do
  include_context 'setup magi_medicaid application with two applicants'

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
    let(:application) { FactoryBot.create(:application, :with_aptc_households_and_members)}
    let(:magi_medicaid_application_json) { JSON.generate(magi_medicaid_application) }
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
      expect(application.fpl.keys.length).to eq(3)
    end

    it 'should find the assistance year from the application response payload' do
      expect(application.assistance_year).to eq(Date.today.year)
    end

    it 'should find the premium from the application response payload' do
      expect(application.benchmarks.first.monthly_premium).to eq(@slcsp_premium)
    end

    it 'should find the primary HBX ID from the application response payload' do
      expect(application.primary_hbx_id).to eq(@person_hbx_id)
    end

    it 'should find the submission date and time from the application response payload' do
      expect(@application_response_entity.submitted_at).to eq(Date.today.to_datetime)
    end

    it 'should find the applicants from the application response payload' do
      expect(application.applicants.empty?).to eq(false)
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
      expect(@application.irs_consent_details[:is_renewal_authorized]).to eq(true)
    end
  end
end
