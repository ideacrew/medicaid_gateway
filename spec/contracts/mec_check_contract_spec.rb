# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::MecCheckContract, dbclean: :after_each do

  let(:required_params) do
    {
      application_identifier: "AI123",
      family_identifier: "F123",
      type: "application"
    }
  end

  let(:optional_params) { { applicant_responses: "{\"k\": \"v\"}" } }

  let(:all_params) { required_params.merge(optional_params) }

  context 'invalid parameters' do
    context 'with empty parameters' do
      it 'should list error for every required parameter' do
        expect(subject.call({}).errors.to_h.keys).to match_array required_params.keys
      end
    end
  end

  context 'valid parameters' do
    context 'with all required and optional parameters' do
      it 'should pass validation' do
        result = subject.call(all_params)
        expect(result.to_h).to eq all_params
      end
    end

    context 'with request payload' do
      it 'should pass validation' do
        required_params[:request_payload] = "payload"
        result = subject.call(all_params)
        expect(result.to_h).to eq all_params
      end
    end
  end
end
