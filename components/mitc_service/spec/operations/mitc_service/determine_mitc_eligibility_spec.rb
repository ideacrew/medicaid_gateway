# frozen_string_literal: true

require 'rails_helper'
require "#{MitcService::Engine.root}/spec/shared_contexts/magi_medicaid_application_data.rb"

RSpec.describe ::MitcService::DetermineMitcEligibility do
  include_context 'setup magi_medicaid application with two applicants'

  let(:mm_entity_application) do
    ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(magi_medicaid_application).success
  end

  before do
    allow(HTTParty).to receive(:post).and_return(mitc_response)
  end

  context 'with valid input and valid response' do
    before do
      @result = subject.call(mm_entity_application)
    end

    it 'should return success' do
      expect(@result).to be_success
    end
  end
end
