# frozen_string_literal: true

require 'rails_helper'
require 'dry/monads'
require 'dry/monads/do'
require File.join(Rails.root, 'spec/shared_contexts/eligibilities/magi_medicaid_application_data')
require 'aca_entities/magi_medicaid/contracts/create_federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/contracts/federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/federal_poverty_level'
require 'aca_entities/operations/magi_medicaid/create_federal_poverty_level'

describe ::MitcService::GenerateAndPublishPayload, dbclean: :after_each do
  include Dry::Monads[:result, :do]
  include_context 'setup magi_medicaid application with two applicants'

  let(:application_request_payload) do
    AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(magi_medicaid_application).success
  end

  let(:medicaid_request_payload) do
    AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_request_payload)
  end

  context 'with valid application' do
    let(:obj) {double}

    before do
      allow(MitcService::CallMagiInTheCloud).to receive(:new).and_return(obj)
      allow(obj).to receive(:call).and_return(Success())
      @result = subject.call(application_request_payload)
    end

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should return transformed payload' do
      expect(@result).to eq medicaid_request_payload
    end
  end

  context 'with invalid application' do
    before do
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
    let(:obj) {double}

    before do
      # TODO: replace allow with eventsource when integrated
      # allow(MitcService::CallMagiInTheCloud).to receive(:new).and_return(obj)
      # allow(obj).to receive(:call).and_return(Failure(""))
      @result = subject.call(application_request_payload)
    end

    it 'should return failure' do
      expect(@result).to be_failure
    end

    it 'should return error message' do
      msg = "Error getting a response from MitC for magi_medicaid_application with hbx_id: #{magi_medicaid_application[:hbx_id]}"
      expect(@result.failure).to eq(msg)
    end
  end
end
