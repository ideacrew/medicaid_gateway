# frozen_string_literal: true

require 'rails_helper'
require "#{MitcService::Engine.root}/spec/shared_contexts/magi_medicaid_application_data.rb"

RSpec.describe ::MitcService::CallMagiInTheCloud do
  include_context 'setup magi_medicaid application with two applicants'

  let(:mitc_request_payload) do
    mm_app = ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(magi_medicaid_application).success
    ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(mm_app).success
  end

  context 'with valid response from MitC service' do
    before do
      allow(HTTParty).to receive(:post).and_return(mitc_response)
      @result = subject.call(mitc_request_payload)
    end

    it 'should return success with valid mitc response' do
      expect(@result).to be_success
    end
  end

  context 'with bad response from MitC service' do
    before do
      allow(HTTParty).to receive(:post).and_raise(Errno::ECONNREFUSED, 'Failed to open TCP connection')
      @result = subject.call(mitc_request_payload)
    end

    it 'should return failure' do
      expect(@result).to be_failure
    end

    it 'should return failure with a message' do
      msg = "Error getting a response from MitC for magi_medicaid_application with hbx_id: #{magi_medicaid_application[:hbx_id]}"
      expect(@result.failure).to eq(msg)
    end
  end
end
