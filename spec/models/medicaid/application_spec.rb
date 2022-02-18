# frozen_string_literal: true

require 'rails_helper'
require 'types'

RSpec.describe ::Medicaid::Application, type: :model, dbclean: :after_each do

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
    let(:application_response_payload) do
      "{ \"assistance_year\": #{Date.today.year},
        \"applicants\": [#{applicants}],
        \"tax_households\": [#{tax_households}],
        \"submitted_at\": \"#{Date.today.beginning_of_day}\"
      }"
    end

    let(:applicants) do
      "{ \"benchmark_premium\": { \"health_only_slcsp_premiums\":
      [{ \"member_identifier\": \"#{member_identifier}\", \"monthly_premium\": \"563.75\" }] },
      \"attestation\":  #{attestation}, \"person_hbx_id\": \"#{member_identifier}\",
      \"has_daily_living_help\": \"false\", \"is_primary_applicant\": \"true\"}"
    end

    let(:tax_households) do
      "{ \"tax_household_members\": [{\"applicant_reference\":
      {\"person_hbx_id\": \"#{member_identifier}\"}, \"product_eligibility_determination\":
      {\"is_non_magi_medicaid_eligible\": \"true\"} }] }"
    end

    let(:attestation) do
      "{\"is_incarcerated\": \"false\", \"is_self_attested_disabled\": \"false\",
      \"is_self_attested_blind\": \"false\",
      \"is_self_attested_long_term_care\": \"false\"}"
    end

    let(:member_identifier) do
      application.aptc_households.first.aptc_household_members.first.member_identifier
    end

    let(:input_params) do
      { application_identifier: '100004',
        application_request_payload: application_response_payload.to_s,
        application_response_payload: application_response_payload.to_s,
        medicaid_request_payload: "{\"Applicants\":[{\"Person ID\":21209944}]}",
        medicaid_response_payload: "{\"Applicants\":[{\"Person ID\":21209944}]}" }
    end

    let(:application) { FactoryBot.create(:application, :with_aptc_households_and_members)}

    before do
      # @application = described_class.new(input_params)
      # @application.save!
      application.update(input_params)
    end

    it 'should be able to generate the fpl data' do
      expect(application.fpl.keys.length).to eq(3)
    end

    it 'should find the assistance year from the application response payload' do
      expect(application.assistance_year).to eq(Date.today.year)
    end

    it 'should find the premium from the application response payload' do
      expect(application.benchmarks.first[:monthly_premium]).to eq("563.75")
    end

    it 'should find the primary HBX ID from the application response payload' do
      expect(application.primary_hbx_id).to eq(member_identifier)
    end

    it 'should find the submission date and time from the application response payload' do
      expect(application.submitted_at).to eq(Date.today.beginning_of_day)
    end

    it 'should find the applicants from the application response payload' do
      expect(application.applicants.empty?).to eq(false)
    end

    it 'should find non-magi medicaid eligibility for the applicant from the application response payload' do
      expect(application.non_magi_medicaid_eligible?(member_identifier)).to eq("true")
    end

    it 'should find the attestations for the applicant from the application response payload' do
      expect(application.attestation(member_identifier)).to eq(JSON.parse(attestation, symbolize_names: true))
    end

    it 'should find the daily living help indicator for the applicant from the application response payload' do
      expect(application.daily_living_help?(member_identifier)).to eq("false")
    end
  end

  # context 'after_save callback' do
  #   let(:application) {FactoryBot.create(:application)}

  #   describe '#check_submitted_at' do
  #     it 'should do nothing if application response payload does not contain submitted_at field' do
  #       expect(application.submitted_at).to eq(nil)
  #     end

  #     it 'should update the submitted_at field after saving if present in application response payload' do
  #       date_time = DateTime.now.to_s
  #       application.update(application_response_payload: "{\"us_state\":\"DC\",\"hbx_id\":\"200000123\", \"submitted_at\": \"#{date_time}\"}")
  #       expect(application.submitted_at).to eq(DateTime.parse(date_time))
  #     end
  #   end
  # end
end
