# frozen_string_literal: true

require 'rails_helper'
require "#{Rails.root}/spec/shared_contexts/eligibilities/magi_medicaid_application_data.rb"
Dir["#{Rails.root}/spec/shared_contexts/eligibilities/cms/me_simple_scenarios/*.rb"].sort.each { |file| require file }
require 'aca_entities/magi_medicaid/contracts/create_federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/contracts/federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/federal_poverty_level'
require 'aca_entities/operations/magi_medicaid/create_federal_poverty_level'

RSpec.describe ::MitcService::GenerateAndPublishPayload, dbclean: :after_each do
  let(:manager) { double }
  let(:connection) { double }
  let(:channel) { double }
  let(:publish_operation) { double }

  it 'should be a container-ready operation' do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  # Dwayne is UQHP eligible and eligible for non_magi_reasons
  context 'cms simle test_case_a' do
    include_context 'cms ME simple_scenarios test_case_a'

    before do
      allow(EventSource::ConnectionManager).to receive(:instance).and_return(manager)
      allow(manager).to receive(:connections_for).and_return([connection])
      allow(connection).to receive(:channels).and_return({ :'/determinations/eval' => channel })
      allow(channel).to receive(:publish_operations).and_return({ '/determinations/eval' => publish_operation })
      allow(publish_operation).to receive(:call).and_return(true)
      @result = subject.call(application_entity)
      @application = @result.success
    end

    let(:medicaid_request_payload) do
      ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
    end

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should store medicaid_request_payload' do
      expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
    end
  end

  # Aisha is MagiMedicaid eligible
  context 'cms simle test_case_c' do
    include_context 'cms ME simple_scenarios test_case_c'

    before do
      allow(EventSource::ConnectionManager).to receive(:instance).and_return(manager)
      allow(manager).to receive(:connections_for).and_return([connection])
      allow(connection).to receive(:channels).and_return({ :'/determinations/eval' => channel })
      allow(channel).to receive(:publish_operations).and_return({ '/determinations/eval' => publish_operation })
      allow(publish_operation).to receive(:call).and_return(true)
      @result = subject.call(application_entity)
      @application = @result.success
    end

    let(:medicaid_request_payload) do
      ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
    end

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should store medicaid_request_payload' do
      expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
    end
  end

  # Gerald is APTC and CSR eligible
  context 'cms simle test_case_d' do
    include_context 'cms ME simple_scenarios test_case_d'

    before do
      allow(EventSource::ConnectionManager).to receive(:instance).and_return(manager)
      allow(manager).to receive(:connections_for).and_return([connection])
      allow(connection).to receive(:channels).and_return({ :'/determinations/eval' => channel })
      allow(channel).to receive(:publish_operations).and_return({ '/determinations/eval' => publish_operation })
      allow(publish_operation).to receive(:call).and_return(true)
      @result = subject.call(application_entity)
      @application = @result.success
    end

    let(:medicaid_request_payload) do
      ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
    end

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should store medicaid_request_payload' do
      expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
    end
  end

  context 'with invalid application' do
    before do
      allow(EventSource::ConnectionManager).to receive(:instance).and_return(manager)
      allow(manager).to receive(:connections_for).and_return([connection])
      allow(connection).to receive(:channels).and_return({ :'/determinations/eval' => channel })
      allow(channel).to receive(:publish_operations).and_return({ '/determinations/eval' => publish_operation })
      allow(publish_operation).to receive(:call).and_return(true)
      @result = subject.call({ test: "test" })
    end

    it 'should return failure' do
      expect(@result).to be_failure
    end

    it 'should return error message' do
      expect(@result.failure).to match(/Invalid Application, given value is not a ::AcaEntities::MagiMedicaid::Application/)
    end
  end

  context 'when connection is not available' do
    include_context 'cms ME simple_scenarios test_case_a'

    before do
      @result = subject.call(application_entity)
    end

    it 'should return failure' do
      expect(@result).to be_failure
    end

    it 'should return error message' do
      msg = "Error getting a response from MitC for magi_medicaid_application with hbx_id: #{application_entity[:hbx_id]}"
      expect(@result.failure).to eq(msg)
    end
  end
end
