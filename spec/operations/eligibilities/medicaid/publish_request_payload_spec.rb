# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/eligibilities/magi_medicaid_application_data')
require 'aca_entities/magi_medicaid/contracts/create_federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/contracts/federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/federal_poverty_level'
require 'aca_entities/operations/magi_medicaid/create_federal_poverty_level'

describe ::Eligibilities::Medicaid::PublishRequestPayload, dbclean: :after_each do
  before do
    MedicaidGatewayRegistry[:atleast_one_silver_plan_donot_cover_pediatric_dental_cost].feature.stub(:is_enabled).and_return(false)
  end

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
      allow(MitcService::GenerateAndPublishPayload).to receive(:new).and_return(obj)
      allow(obj).to receive(:call).and_return(medicaid_request_payload)
      @result = subject.call(application_request_payload)
    end

    it 'should return success' do
      expect(@result).to be_success
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
end
