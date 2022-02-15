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
        \"applicants\": [#{applicants}]
      }"
    end

    let(:applicants) do
      "{ \"benchmark_premium\": { \"health_only_slcsp_premiums\": [{ \"member_identifier\": \"21209944\", \"monthly_premium\": \"563.75\" }] } }"
    end

    let(:input_params) do
      { application_identifier: '100004',
        application_request_payload: application_response_payload.to_s,
        application_response_payload: application_response_payload.to_s,
        medicaid_request_payload: "{\"Applicants\":[{\"Person ID\":21209944}]}",
        medicaid_response_payload: "{\"Applicants\":[{\"Person ID\":21209944}]}" }
    end

    before do
      @application = described_class.new(input_params)
      @application.save!
    end

    it 'should be able to generate the fpl data' do
      expect(@application.fpl.keys.length).to eq(3)
    end

    it 'should find the assistance year from the application response payload' do
      expect(@application.assistance_year).to eq(Date.today.year)
    end

    it 'should find the premium from the application response payload' do
      expect(@application.benchmarks.first[:monthly_premium]).to eq("563.75")
    end
  end
end
