# frozen_string_literal: true

require 'rails_helper'
require "#{MitcService::Engine.root}/spec/shared_contexts/magi_medicaid_application_data.rb"

RSpec.describe ::MitcService::DetermineFullEligibility do
  include_context 'setup magi_medicaid application with two applicants'

  it 'should be a container-ready operation' do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  context 'with MagiMedicaidApplication hash' do
    before do
      @result = subject.call(magi_medicaid_application)
    end

    it 'should return success' do
      expect(@result).to be_success
    end
  end
end
