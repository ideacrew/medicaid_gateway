# frozen_string_literal: true

require 'rails_helper'
require "#{Rails.root}/spec/shared_contexts/eligibilities/magi_medicaid_application_data.rb"
Dir["#{Rails.root}/spec/shared_contexts/eligibilities/cms/me_simple_scenarios/*.rb"].sort.each { |file| require file }
require 'aca_entities/magi_medicaid/contracts/create_federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/contracts/federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/federal_poverty_level'
require 'aca_entities/operations/magi_medicaid/create_federal_poverty_level'

RSpec.describe ::Eligibilities::Medicaid::RequestDetermination, dbclean: :after_each do
  it 'should be a container-ready operation' do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  # Dwayne is UQHP eligible and eligible for non_magi_reasons
  context 'cms simle test_case_a' do
    include_context 'cms ME simple_scenarios test_case_a'

    before do
      allow(HTTParty).to receive(:post).and_return(mitc_response)
      @result = subject.call(input_application)
      @application = @result.success
    end

    let(:medicaid_request_payload) do
      ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
    end

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should return Medicaid::Application persistence object' do
      expect(@application).to be_a(::Medicaid::Application)
    end

    it 'should create Medicaid::Application persistence object' do
      expect(@application.persisted?).to be_truthy
    end

    it 'should store application_request_payload' do
      expect(@application.application_request_payload).to eq(input_application.to_json)
    end

    it 'should store medicaid_request_payload' do
      expect(@application.medicaid_request_payload).not_to be_nil
      expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
    end
  end

  # Aisha is MagiMedicaid eligible
  context 'cms simle test_case_c' do
    include_context 'cms ME simple_scenarios test_case_c'

    before do
      allow(HTTParty).to receive(:post).and_return(mitc_response)
      @result = subject.call(input_application)
      @application = @result.success
    end

    let(:medicaid_request_payload) do
      ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
    end

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should return Medicaid::Application persistence object' do
      expect(@application).to be_a(::Medicaid::Application)
    end

    it 'should create Medicaid::Application persistence object' do
      expect(@application.persisted?).to be_truthy
    end

    it 'should store application_request_payload' do
      expect(@application.application_request_payload).to eq(input_application.to_json)
    end

    it 'should store medicaid_request_payload' do
      expect(@application.medicaid_request_payload).not_to be_nil
      expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
    end
  end

  # Gerald is APTC and CSR eligible
  context 'cms simle test_case_d' do
    include_context 'cms ME simple_scenarios test_case_d'

    before do
      allow(HTTParty).to receive(:post).and_return(mitc_response)
      @result = subject.call(input_application)
      @application = @result.success
    end

    let(:medicaid_request_payload) do
      ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
    end

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should return Medicaid::Application persistence object' do
      expect(@application).to be_a(::Medicaid::Application)
    end

    it 'should create Medicaid::Application persistence object' do
      expect(@application.persisted?).to be_truthy
    end

    it 'should store application_request_payload' do
      expect(@application.application_request_payload).to eq(input_application.to_json)
    end

    it 'should store medicaid_request_payload' do
      expect(@application.medicaid_request_payload).not_to be_nil
      expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
    end
  end
end
