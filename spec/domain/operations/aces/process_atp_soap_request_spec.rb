# frozen_string_literal: true

require "rails_helper"

describe Aces::ProcessAtpSoapRequest, "given a soap envelope with an valid xml payload", dbclean: :after_each do
  before :all do
    DatabaseCleaner.clean
  end

  let(:xml) { File.read("./spec/test_data/transfer_to_enroll.xml") }
  let(:cms_xml) { File.read("./spec/test_data/transfer_to_enroll_from_cms.xml") }

  let(:operation) { Aces::ProcessAtpSoapRequest.new }
  let(:feature_ns) { double }

  before :each do
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_to_enroll)
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service)
    allow(MedicaidGatewayRegistry[:aces_connection]).to receive(:setting).with(:aces_atp_caller_username).and_return(double)
    allow(MedicaidGatewayRegistry[:aces_connection].setting(:aces_atp_caller_username)).to receive(:item).and_return("SOME_SOAP_USER")
    allow(MedicaidGatewayRegistry[:aces_connection]).to receive(:setting).with(:aces_atp_caller_password).and_return(double)
    allow(MedicaidGatewayRegistry[:aces_connection].setting(:aces_atp_caller_password)).to receive(:item).and_return("SOME SOAP PASSWORD")
    allow(MedicaidGatewayRegistry[:transfer_service]).to receive(:item).and_return("SERVICE")
    allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:transfer_to_enroll).and_return(false)
    allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:resubmit_to_enroll).and_return(false)
    allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:bulk_transfer_to_enroll).and_return(false)
  end

  context 'from aces' do
    before do
      @transfer = create :inbound_transfer
      @result = operation.call(xml, @transfer.id)
    end

    it "payload processing should be successful" do
      expect(@result.success?).to be_truthy
    end

    it "transfer to_enroll should be true" do
      expect(@transfer.reload.to_enroll).to eq true
    end
  end

  context 'from CMS' do
    before do
      @transfer = create :inbound_transfer
      @result = operation.call(cms_xml, @transfer.id)
    end

    it "payload processing should be successful" do
      expect(@result.success?).to be_truthy
    end

    it "transfer to_enroll should be false" do
      expect(@transfer.reload.to_enroll).to eq false
    end
  end
end