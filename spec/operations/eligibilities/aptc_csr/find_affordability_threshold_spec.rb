# frozen_string_literal: true

require 'rails_helper'

describe Eligibilities::AptcCsr::FindAffordabilityThreshold do
  context 'valid params' do
    before do
      @result = subject.call(2021)
    end

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should return success with valid result' do
      expect(@result.success).to eq(9.83)
    end
  end

  context 'invalid params' do
    context 'invalid input data type' do
      before { @result = subject.call('test') }

      it 'should return failure with error message' do
        expect(@result.failure).to eq('Invalid input: test, must be an year.')
      end
    end

    context 'a year that is not currently supported' do
      before { @result = subject.call(1900) }

      it 'should return failure with error message' do
        expect(@result.failure).to eq('Cannot find Affordability Threshold for the given input year: 1900.')
      end
    end
  end
end