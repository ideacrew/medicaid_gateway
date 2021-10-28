# frozen_string_literal: true

require "rails_helper"
require 'aca_entities/serializers/xml/medicaid/atp'
require 'aca_entities/medicaid/atp'
require 'aca_entities/atp/operations/aces/generate_xml'

describe Transfers::ToService, "given an ATP valid payload, transfer it to the specified service" do
  include Dry::Monads[:result, :do]

  let(:aces_hash) {File.read("./spec/test_data/application_and_family.json")}
  let(:transfer) {described_class.new}

  let(:feature_ns) { double }
  let(:service_ns) { double }
  let(:setting) { double(item: "SOME URI") }

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
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(service_ns)
        allow(service_ns).to receive(:item).and_return("curam")
        allow(feature_ns).to receive(:setting).with(:curam_atp_service_uri).and_return(setting)
        allow(feature_ns).to receive(:setting).with(:curam_atp_service_username).and_return(setting)
        allow(feature_ns).to receive(:setting).with(:curam_atp_service_password).and_return(setting)
        allow(transfer).to receive(:initiate_transfer).and_return(event)
        @transfer_count = Aces::Transfer.all.count
        @result = transfer.call(aces_hash)
      end

      it "should create a new transfer" do
        expect(Aces::Transfer.all.count).to eq @transfer_count + 1
      end

      it "succeeds when given a valid payload" do
        expect(@result.success?).to be_truthy
      end
    end

    context 'with valid application transfer to aces' do
      before do
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(service_ns)
        allow(service_ns).to receive(:item).and_return("aces")
        allow(feature_ns).to receive(:setting).with(:aces_atp_service_uri).and_return(setting)
        allow(feature_ns).to receive(:setting).with(:aces_atp_service_username).and_return(setting)
        allow(feature_ns).to receive(:setting).with(:aces_atp_service_password).and_return(setting)
        allow(transfer).to receive(:initiate_transfer).and_return(event)
        @transfer_count = Aces::Transfer.all.count
        @result = transfer.call(aces_hash)
        @transfer = Aces::Transfer.last
      end

      it "should create a new transfer" do
        expect(Aces::Transfer.all.count).to eq @transfer_count + 1
      end

      it "succeeds when given a valid payload" do
        expect(@result.success?).to be_truthy
      end

      it "transfer should have a callback status of Success" do
        expect(@transfer.callback_status).to eq "Success"
      end
    end
  end

end