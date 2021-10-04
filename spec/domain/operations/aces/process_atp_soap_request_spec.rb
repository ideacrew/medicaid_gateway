# frozen_string_literal: true

require "rails_helper"

describe Aces::ProcessAtpSoapRequest, "given a soap envelope with an valid xml payload", dbclean: :after_each do
  before :all do
    DatabaseCleaner.clean
  end

  let!(:transfer) { FactoryBot.create(:inbound_transfer) }
  let(:xml) { File.read("./spec/test_data/transfer_to_enroll.xml") }

  let(:operation) { Aces::ProcessAtpSoapRequest.new }
  let(:result) { operation.call(xml, transfer.id) }

  before :each do
    allow(MedicaidGatewayRegistry[:aces_connection].setting(:aces_atp_caller_username)).to receive(:item).and_return("SOME_SOAP_USER")
    allow(MedicaidGatewayRegistry[:aces_connection].setting(:aces_atp_caller_password)).to receive(:item).and_return("SOME SOAP PASSWORD")
  end

  it "payload processing should be successful" do
    expect(result.success?).to be_truthy
  end
end