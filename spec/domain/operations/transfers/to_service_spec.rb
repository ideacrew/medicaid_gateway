# frozen_string_literal: true

require "rails_helper"
require 'aca_entities/serializers/xml/medicaid/atp'
require 'aca_entities/medicaid/atp'
require 'aca_entities/atp/operations/aces/generate_xml'

describe Transfers::ToService, "given a valid payload, transfer it to the specified service" do
  include Dry::Monads[:result, :do]

  let(:aces_hash) {File.read("./spec/test_data/application_and_family.json")}
  let(:transfer) {described_class.new}

  let(:event) { Success(response) }

  context 'success' do
    context 'with a payload type of atp' do
      before do
        allow(MedicaidGatewayRegistry[:transfer_payload_type_atp]).to receive(:enabled?).and_return(true)
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
    end
    context 'with a payload type of ios' do
      before do
        allow(MedicaidGatewayRegistry[:transfer_payload_type_atp]).to receive(:enabled?).and_return(false)
        allow(MedicaidGatewayRegistry[:transfer_payload_type_ios]).to receive(:enabled?).and_return(true)
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
    end
  end

  context 'failure' do
    context 'with no applicants applying for coverage' do
      before do
        payload = JSON.parse(aces_hash)
        non_applicants = payload.dig("family", "magi_medicaid_applications", "applicants").each do |applicant|
          applicant["is_applying_coverage"] = false
        end
        payload["family"]["magi_medicaid_applications"]["applicants"] = non_applicants
        params = payload.to_json
        @result = transfer.call(params)
      end

      it 'should fail when no applicants are applying for coverage' do
        error_message = @result.failure[:failure]
        expect(error_message).to eq "Application does not contain any applicants applying for coverage."
      end
    end
    context 'when given a transfer id' do
      before do
        @transfer_count = Aces::Transfer.all.count
        @transfer = Aces::Transfer.last
        @result = transfer.call(aces_hash, @transfer.id)
      end

      it "should not create a new transfer" do
        expect(Aces::Transfer.all.count).to eq @transfer_count
      end

    end
  end

end