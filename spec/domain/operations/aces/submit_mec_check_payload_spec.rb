# frozen_string_literal: true

require "rails_helper"

describe Aces::SubmitMecCheckPayload, "given an encoded payload, and incomplete settings" do
  let(:operation) { Aces::SubmitMecCheckPayload.new }
  let(:result) { operation.call(payload) }
  let(:payload) { double }

  let(:feature_ns) { double }
  let(:feature_item) { double }

  before :each do
    allow(feature_ns).to receive(:setting).with(:aces_atp_service_uri).and_return(nil)
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
    allow(feature_item).to receive(:item).and_return("aces")
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(feature_item)
  end

  it "fails when the endpoint URI is unavailable" do
    expect(result.success?).not_to be_truthy
    expect(result.failure).to eq "Failed to find setting: :aces_connection, :aces_mec_check_uri"
  end
end

describe Aces::SubmitMecCheckPayload, "given an encoded payload, and complete settings" do
  let(:operation) { Aces::SubmitMecCheckPayload.new }
  let(:result) { operation.call(payload) }
  let(:payload) { double }

  let(:feature_ns) { double }
  let(:setting) { double(item: "SOME URI") }

  before :each do
    allow(feature_ns).to receive(:setting).with(:aces_atp_service_uri).and_return(setting)
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
    allow(feature_item).to receive(:item).and_return("aces")
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(feature_item)
  end

  it "fails when the request fails" do
    expect(result.success?).not_to be_truthy
  end
end
