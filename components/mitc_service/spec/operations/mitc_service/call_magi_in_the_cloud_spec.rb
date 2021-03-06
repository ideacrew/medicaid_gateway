# frozen_string_literal: true

require 'rails_helper'
require "#{Rails.root}/spec/shared_contexts/eligibilities/magi_medicaid_application_data.rb"

RSpec.describe ::MitcService::CallMagiInTheCloud do
  include Dry::Monads[:result, :do]
  include_context 'setup magi_medicaid application with two applicants'

  let(:mitc_request_payload) do
    mm_app = ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(magi_medicaid_application).success
    ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(mm_app).success
  end

  let(:event) { Success(double) }
  let(:obj)  {MitcService::CallMagiInTheCloud.new}

  context 'with valid response from MitC service' do
    before do
      allow(MitcService::CallMagiInTheCloud).to receive(:new).and_return(obj)
      allow(obj).to receive(:build_event).and_return(event)
      allow(event.success).to receive(:publish).and_return(true)
      @result = subject.call(mitc_request_payload)
    end

    it 'should return success with valid mitc response' do
      expect(@result).to be_success
    end

    it 'should return success with a message' do
      expect(@result.success).to eq("Successfully sent request payload to mitc")
    end
  end

  # context 'with bad response from MitC service' do
  #   let(:connection_params) do
  #     {
  #       protocol: :http,
  #       publish_operation_name: '/determinations/eval'
  #     }
  #   end

  #   let(:connection) {
  #       manager = EventSource::ConnectionManager.instance
  #       manager.find_connection(connection_params)
  #   }

  #   before do
  #     connection.disconnect
  #     @result = subject.call(mitc_request_payload)
  #   end

  #   it 'should return failure' do
  #     expect(@result).to be_failure
  #   end

  #   it 'should return failure with a message' do
  #     msg = "Error getting a response from MitC for magi_medicaid_application with hbx_id: #{magi_medicaid_application[:hbx_id]}"
  #     expect(@result.failure).to eq(msg)
  #   end
  # end
end
