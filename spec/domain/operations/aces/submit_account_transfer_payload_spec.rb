# frozen_string_literal: true

require "rails_helper"

describe Aces::SubmitAccountTransferPayload, "given an encoded payload" do
  let(:operation) { Aces::SubmitAccountTransferPayload.new }
  let(:result) { operation.call(payload) }
  let(:payload) { double }

  let(:feature_ns) { double }
  let(:setting) { double(item: "SOME URI") }

  before :each do
    allow(feature_ns).to receive(:setting).with(:aces_atp_service_uri).and_return(setting)
  end

  it "fails when the URI is unavailable" do
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(nil)
    expect(result.success?).not_to be_truthy
    expect(result.failure).to eq "Failed to find setting: :aces_connection, :aces_atp_service_uri"
  end

  it "fails when the request fails" do
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
    expect(result.success?).not_to be_truthy
  end
end