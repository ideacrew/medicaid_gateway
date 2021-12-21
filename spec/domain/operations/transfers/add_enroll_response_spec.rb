# frozen_string_literal: true

require "rails_helper"

describe Transfers::AddEnrollResponse, dbclean: :after_each do
  before :all do
    DatabaseCleaner.clean
  end

  let(:xml) { File.read("./spec/test_data/Simple_Test_Case_L_New.xml") }
  let(:params) do
    {
      family_identifier: "1234",
      application_identifier: "5678",
      result: "Sucessfully ingested by Enroll",
      transfer_id: transfer_id
    }
  end
  let(:transfer_id) { "tr123" }
  let(:operation) { Transfers::AddEnrollResponse.new }

  context "failure" do
    it "should fail if the inbound transfer record does not exist" do
      result = operation.call(params.stringify_keys)
      expect(result.success?).not_to be_truthy
    end
  end

  context "success" do
    before :each do
      @inbound_transfer = create :inbound_transfer, external_id: transfer_id
      @result = operation.call(params.stringify_keys)
    end

    it "should update the inbound transfer with the response details from enroll" do
      expect(@result.success?).to be_truthy
    end

    it "should update the inbound transfer record" do
      updated_application = Aces::InboundTransfer.find(@inbound_transfer.id)
      expect(updated_application.application_identifier).to eq "5678"
    end
  end
end