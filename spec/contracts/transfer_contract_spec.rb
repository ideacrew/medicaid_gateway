# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::TransferContract, dbclean: :after_each do

  let(:required_params) do
    {
      application_identifier: "AI123",
      family_identifier: "F123",
      service: "serv",
      response_payload: "{\"k\": \"v\"}",
      callback_payload: "{\"k\": \"v\"}"
    }
  end

  let(:optional_params) do
    {
      callback_status: "status"
    }
  end

  let(:all_params) { required_params.merge(optional_params)}

  context 'invalid parameters' do
    context 'with empty parameters' do
      it 'should list error for every required parameter' do
        expect(subject.call({}).errors.to_h.keys).to match_array required_params.keys
      end
    end

    context 'with optional parameters only' do
      it 'should list error for every required parameter' do
        expect(subject.call(optional_params).errors.to_h.keys).to match_array required_params.keys
      end
    end

    context 'with response payload as a non-JSON string' do
      it 'should list error for response_payload key' do
        required_params[:response_payload] = "not a JSON string"
        expect(subject.call(required_params).errors.to_h.keys).to match_array [:response_payload]
      end
    end

    context 'with callback payload as a non-JSON string' do
      it 'should list error for callback_payload key' do
        required_params[:callback_payload] = "not a JSON string"
        expect(subject.call(required_params).errors.to_h.keys).to match_array [:callback_payload]
      end
    end
  end

  context 'valid parameters' do
    context 'with required parameters only' do
      it { expect(subject.call(required_params).success?).to be_truthy }
      it { expect(subject.call(required_params).to_h).to eq required_params }
    end

    context 'with all required and optional parameters' do
      it 'should pass validation' do
        result = subject.call(all_params)
        expect(result.success?).to be_truthy
        expect(result.to_h).to eq all_params
      end
    end
  end
end
