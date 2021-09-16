# frozen_string_literal: true

require "rails_helper"

describe Curam::BuildTransferCheck, "given a payload, with missing settings" do
  let(:id) { "SBM123" }
  let(:operation) { Curam::BuildTransferCheck.new }
  let(:date) { Date.today }
  let(:result) { operation.call(id, date) }
  let(:feature_ns) { double }
  let(:setting) { double(item: "SOME URI") }

  before :each do
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:curam_connection).and_return(feature_ns)
  end

  it "fails if username setting is unset" do
    allow(feature_ns).to receive(:setting).with(:curam_atp_service_username).and_return(nil)
    expect(result.success?).to be_falsey
    expect(result.failure).to eq "Failed to find setting: :curam_connection, :curam_atp_service_username"
  end

  it "fails if password setting is unset" do
    allow(feature_ns).to receive(:setting).with(:curam_atp_service_username).and_return(setting)
    allow(feature_ns).to receive(:setting).with(:curam_atp_service_username).and_return(nil)
    expect(result.success?).to be_falsey
    expect(result.failure).to eq "Failed to find setting: :curam_connection, :curam_atp_service_username"
  end
end

describe Aces::BuildAccountTransferRequest, "given a payload, with configured settings" do
  let(:id) { "SBM123" }
  let(:operation) { Curam::BuildTransferCheck.new }
  let(:date) { Date.today }
  let(:result) { operation.call(id, date) }
  let(:feature_ns) { double }
  let(:setting) { double(item: "SOME URI") }

  before :each do
    allow(MedicaidGatewayRegistry[:curam_connection].setting(:curam_atp_service_username)).to receive(:item).and_return("random_name")
    allow(MedicaidGatewayRegistry[:curam_connection].setting(:curam_atp_service_password)).to receive(:item).and_return("random_pw")
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
end