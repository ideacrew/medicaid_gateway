# frozen_string_literal: true

require 'rails_helper'
require "#{MitcService::Engine.root}/spec/shared_contexts/magi_medicaid_application_data.rb"
require 'aca_entities/magi_medicaid/contracts/create_federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/contracts/federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/federal_poverty_level'
require 'aca_entities/operations/magi_medicaid/create_federal_poverty_level'

RSpec.describe ::MitcService::DetermineFullEligibility do
  include_context 'setup magi_medicaid application with two applicants'

  it 'should be a container-ready operation' do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  before do
    allow(HTTParty).to receive(:post).and_return(mitc_response)
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
