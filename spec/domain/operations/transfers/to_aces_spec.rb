# frozen_string_literal: true

require "rails_helper"
require 'aca_entities/serializers/xml/medicaid/atp'
require 'aca_entities/medicaid/atp'
require 'aca_entities/atp/operations/aces/generate_xml'

describe Transfers::ToAces, "given an ATP valid payload, transfer it to the specified service" do
  include Dry::Monads[:result, :do]

  let(:aces_hash) {File.read("./spec/test_data/application_and_family.json")}
  let(:transfer) {described_class.new}

  let(:feature_ns) { double }
  let(:setting) { double(item: "SOME URI") }

  before :each do
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
    allow(feature_ns).to receive(:setting).with(:aces_atp_service_uri).and_return(setting)
    allow(feature_ns).to receive(:setting).with(:aces_atp_service_username).and_return(setting)
    allow(feature_ns).to receive(:setting).with(:aces_atp_service_password).and_return(setting)
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:curam_connection).and_return(feature_ns)
    allow(feature_ns).to receive(:setting).with(:curam_atp_service_uri).and_return(setting)
    allow(feature_ns).to receive(:setting).with(:curam_atp_service_username).and_return(setting)
    allow(feature_ns).to receive(:setting).with(:curam_atp_service_password).and_return(setting)
  end

  context 'success' do
    context 'with valid application transfer to curam' do
      before do
        @result = transfer.call(aces_hash, "curam")
      end

      it "fails when the request fails" do
        expect(@result.success?).not_to be_truthy
      end
    end

    context 'with valid application transfer to aces' do
      before do
        @result = transfer.call(aces_hash, "aces")
      end

      it "fails when the request fails" do
        expect(@result.success?).not_to be_truthy
      end
    end
  end

end