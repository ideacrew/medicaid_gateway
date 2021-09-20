# frozen_string_literal: true

require "rails_helper"

describe Curam::SubmitAccountTransferCheck, "given an encoded payload, and incomplete settings" do
  let(:operation) { Curam::SubmitAccountTransferCheck.new }
  let(:result) { operation.call(payload) }
  let(:payload) { double }

  let(:feature_ns) { double }

  before :each do
    allow(feature_ns).to receive(:setting).with(:curam_check_service_uri).and_return(nil)
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:curam_connection).and_return(feature_ns)
  end

  it "fails when the endpoint URI is unavailable" do
    expect(result.success?).not_to be_truthy
    expect(result.failure).to eq "Failed to find setting: :curam_connection, :curam_check_service_uri"
  end
end

describe Curam::SubmitAccountTransferCheck, "given an encoded payload, and complete settings" do
  let(:operation) { Curam::SubmitAccountTransferCheck.new }
  let(:result) { operation.call(payload) }
  let(:payload) { double }

  let(:feature_ns) { double }
  let(:setting) { double(item: "SOME URI") }

  before :each do
    allow(feature_ns).to receive(:setting).with(:curam_check_service_uri).and_return(setting)
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:curam_connection).and_return(feature_ns)
  end

  it "fails when the request fails" do
    expect(result.success?).not_to be_truthy
  end
end