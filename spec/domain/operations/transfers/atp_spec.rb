# frozen_string_literal: true

require "rails_helper"
require 'aca_entities/serializers/xml/medicaid/atp'
require 'aca_entities/medicaid/atp'
require 'aca_entities/atp/operations/aces/generate_xml'

describe Transfers::Atp, "given an ATP valid payload, generate XML and transfer it to the specified service" do
  include Dry::Monads[:result, :do]

  let(:payload_hash) {File.read("./spec/test_data/application_and_family.json")}
  let(:transfer) {described_class.new}

  let(:feature_ns) { double }
  let(:service_ns) { double }

  let(:service) { "aces" }

  let(:record) { create :transfer }

  let(:response_body) do
    "<env:Envelope xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\">
      <env:Body>
        <AccountTransferResponse xmlns=\"http://at.dsh.cms.gov/exchange/1.0\" atVersionText=\"\">
          <ResponseMetadata xmlns=\"http://at.dsh.cms.gov/extension/1.0\">
            <ResponseCode xmlns=\"http://hix.cms.gov/0.1/hix-core\">HS000000</ResponseCode>
            <ResponseDescriptionText xmlns=\"http://hix.cms.gov/0.1/hix-core\">Success</ResponseDescriptionText>
          </ResponseMetadata>
        </AccountTransferResponse>
      </env:Body>
    </env:Envelope>"
  end

  let(:response) do
    {
      :status => 200,
      :body => response_body,
      :response_headers => {}
    }
  end

  let(:event) { Success(response) }

  context 'success' do
    context 'with valid application transfer to curam' do
      before do
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:curam_connection).and_return(feature_ns)
        service = "curam"
        allow(transfer).to receive(:initiate_transfer).and_return(event)
        @result = transfer.call(payload_hash, record.id, service)
      end

      it "succeeds when given a valid payload" do
        expect(@result.success?).to be_truthy
      end
    end

    context 'with valid application transfer response not as 200' do
      let(:failure_response) do
        {
          :status => 504,
          :body => response_body,
          :response_headers => {}
        }
      end

      let(:event) { Success(failure_response) }

      before do
        allow(transfer).to receive(:initiate_transfer).and_return(event)
      end

      context 'ACES Service' do
        before do
          transfer.call(payload_hash, record.id, service)
          @transfer = record.reload
        end

        it "should create a new transfer with failure message" do
          expect(@transfer.failure).to eq "Response has a failure with status 504"
          expect(@transfer.response_payload).not_to eq nil
        end
      end

      context 'Non-ACEs Services' do
        before do
          service = "curam"
          transfer.call(payload_hash, record.id, service)
          @transfer = record.reload
        end

        it "should create a new transfer with failure message" do
          expect(@transfer.failure).to eq "Response has a failure with status 504"
          expect(@transfer.response_payload).not_to eq nil
        end
      end
    end

    context 'with valid application transfer to aces' do
      before do
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
        service = "aces"
        allow(transfer).to receive(:initiate_transfer).and_return(event)
        @result = transfer.call(payload_hash, record.id, service)
        @transfer = record.reload
      end

      it "succeeds when given a valid payload" do
        expect(@result.success?).to be_truthy
      end

      it "transfer should have a callback status of Success" do
        expect(@transfer.callback_status).to eq "Success"
      end
    end
  end

  context 'failure' do
    context 'with an invalid transfer if' do
      it 'should fail' do
        @result = transfer.call(payload_hash, "this is not a real transfer id", service)
        expect(@result.success?).to be_falsey
      end
    end
  end
end