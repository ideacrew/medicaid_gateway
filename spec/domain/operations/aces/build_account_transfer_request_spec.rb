# frozen_string_literal: true

require "rails_helper"

describe Aces::BuildAccountTransferRequest, "given a payload, with missing settings" do
  let(:payload) { "SOME RAW PAYLOAD" }
  let(:operation) { Aces::BuildAccountTransferRequest.new }
  let(:result) { operation.call(payload) }
  let(:feature_ns) { double }
  let(:setting) { double(item: "SOME URI") }

  before :each do
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
  end

  it "fails if username setting is unset" do
    allow(feature_ns).to receive(:setting).with(:aces_atp_service_username).and_return(nil)
    expect(result.success?).to be_falsey
  end

  it "fails if password setting is unset" do
    allow(feature_ns).to receive(:setting).with(:aces_atp_service_username).and_return(setting)
    allow(feature_ns).to receive(:setting).with(:aces_atp_service_password).and_return(nil)
    expect(result.success?).to be_falsey
  end
end

describe Aces::BuildAccountTransferRequest, "given a payload, with configured settings" do
  let(:payload) { "SOME RAW PAYLOAD" }
  let(:operation) { Aces::BuildAccountTransferRequest.new }
  let(:result) { operation.call(payload) }
  let(:feature_ns) { double }
  let(:setting) { double(item: "SOME URI") }

  before :each do
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
    allow(feature_ns).to receive(:setting).with(:aces_atp_service_username).and_return(setting)
    allow(feature_ns).to receive(:setting).with(:aces_atp_service_password).and_return(setting)
  end

  it "generates the nonce" do
    expect(result.value!.header.nonce).not_to be nil
  end

  it "generates the created" do
    expect(result.value!.header.created).not_to be nil
  end

  it "sets the username" do
    expect(result.value!.header.username).not_to be nil
  end

  it "sets the password" do
    expect(result.value!.header.password).not_to be nil
  end

  it "sets the body" do
    expect(result.value!.raw_body).to eq payload
  end
end