# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::MecCheckContract, dbclean: :after_each do

  let(:required_params) do
    {
      application_identifier: "AI123",
      family_identifier: "F123",
      applicant_responses: "{\"k\": \"v\"}"
    }
  end

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
        result = subject.call(required_params)
        expect(result.to_h).to eq required_params
      end
    end
  end

end
