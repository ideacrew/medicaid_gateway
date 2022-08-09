# frozen_string_literal: true

require 'rails_helper'

describe Eligibilities::AptcCsr::FindAffordabilityThreshold do
  describe '.call' do
    context 'year 2021' do
      it { expect(subject.call(2021).success.to_f).to eq(9.83) }
    end

    context 'year 2023' do
      it { expect(subject.call(2023).success.to_f).to eq(9.12) }
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
