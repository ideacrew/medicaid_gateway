# frozen_string_literal: true

require 'rails_helper'
require "#{Rails.root}/spec/shared_contexts/eligibilities/magi_medicaid_application_data.rb"

RSpec.describe ::MitcService::AddMitcDeterminationToApplication do
  include_context 'setup magi_medicaid application with two applicants'

  let(:mm_application) do
    ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(magi_medicaid_application).success
  end

  let(:input_params) do
    { magi_medicaid_application: mm_application, mitc_response: mitc_response }
  end

  it 'should be a container-ready operation' do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  context 'success' do
    before do
      @result = subject.call(input_params)
    end

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should return the MagiMedicaidApplication entity' do
      expect(@result.success).to be_a(::AcaEntities::MagiMedicaid::Application)
    end
  end

  context 'failure' do
    context 'missing params' do
      let(:error_msg) { 'Input hash does not have one/both the keys :magi_medicaid_application, :mitc_response' }

      it 'should return failure with error message for no params' do
        expect(subject.call({}).failure).to eq(error_msg)
      end

      it 'should return failure with error message for missing magi_medicaid_application key' do
        expect(subject.call({ mitc_response: 'mitc_response' }).failure).to eq(error_msg)
      end

      it 'should return failure with error message for missing mitc_response key' do
        expect(subject.call({ magi_medicaid_application: 'magi_medicaid_application' }).failure).to eq(error_msg)
      end
    end

    context 'bad input value' do
      let(:error_msg) { 'Given value for key :magi_medicaid_application is not a ::AcaEntities::MagiMedicaid::Application' }

      it 'should return failure with error message' do
        expect(subject.call({ magi_medicaid_application: 'magi_medicaid_application',
                              mitc_response: mitc_response }).failure).to eq(error_msg)
      end
    end
  end
end
