# frozen_string_literal: true

require "rails_helper"
require 'aca_entities/serializers/xml/medicaid/atp'
require 'aca_entities/medicaid/atp'
require 'aca_entities/atp/operations/aces/generate_xml'

describe Transfers::ToService, "given an ATP valid payload, transfer it to the specified service" do
  include Dry::Monads[:result, :do]

  let(:aces_hash) {File.read("./spec/test_data/application_and_family.json")}
  let(:transfer) {described_class.new}

  let(:feature_ns) { double }
  let(:service_ns) { double }

  let(:response_body) do
    "<env:Envelope xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\">
      <env:Body>
        <AccountTransferResponse xmlns=\"http://at.dsh.cms.gov/exchange/1.0\" atVersionText=\"\">
          <ResponseMetadata xmlns=\"http://at.dsh.cms.gov/extension/1.0\">
            <ResponseCode xmlns=\"http://hix.cms.gov/0.1/hix-core\">HS000000</ResponseCode>
            <ResponseDescriptionText xmlns=\"http://hix.cms.gov/0.1/hix-core\">Success</ResponseDescriptionText>
          </ResponseMetadata>
        </AccountTransferResponse>
      </env:Body>
    </env:Envelope>"
  end

  let(:response) do
    {
      "status" => 200,
      :body => response_body,
      :response_headers => {}
    }
  end

  let(:event) { Success(response) }

  context 'success' do
    context 'with valid application transfer to curam' do
      before do
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:curam_connection).and_return(feature_ns)
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(service_ns)
        allow(service_ns).to receive(:item).and_return("curam")
        allow(transfer).to receive(:initiate_transfer).and_return(event)
        @transfer_count = Aces::Transfer.all.count
        @result = transfer.call(aces_hash)
      end

      it "should create a new transfer" do
        expect(Aces::Transfer.all.count).to eq @transfer_count + 1
      end

      it "succeeds when given a valid payload" do
        expect(@result.success?).to be_truthy
      end
    end

    context 'to curam when given a transfer id' do
      before do
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:curam_connection).and_return(feature_ns)
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(service_ns)
        allow(service_ns).to receive(:item).and_return("curam")
        allow(transfer).to receive(:initiate_transfer).and_return(event)
        @transfer = Aces::Transfer.last
        @transfer_count = Aces::Transfer.all.count
        @result = transfer.call(aces_hash, @transfer.id)
      end

      it "should not create a new transfer" do
        expect(Aces::Transfer.all.count).to eq @transfer_count
      end

      it "succeeds when given a valid payload" do
        expect(@result.success?).to be_truthy
      end

    end

    context 'with valid application transfer response not as 200' do
      let(:failure_response) do
        {
          "status" => 504,
          :body => response_body,
          :response_headers => {}
        }
      end

      let(:event) { Success(failure_response) }

      before do
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(service_ns)
        allow(transfer).to receive(:initiate_transfer).and_return(event)
      end

      context 'ACES Service' do
        before do
          allow(service_ns).to receive(:item).and_return("aces")
          @transfer_count = Aces::Transfer.all.count
          transfer.call(aces_hash)
          @transfer = Aces::Transfer.last
        end

        it "should create a new transfer with failure message" do
          expect(Aces::Transfer.all.count).to eq @transfer_count + 1
          expect(@transfer.failure).to eq "Response has a failure with status 504"
          expect(@transfer.response_payload).not_to eq nil
        end
      end

      context 'Non-ACEs Services' do
        before do
          allow(service_ns).to receive(:item).and_return("curam")
          @transfer_count = Aces::Transfer.all.count
          transfer.call(aces_hash)
          @transfer = Aces::Transfer.last
        end

        it "should create a new transfer with failure message" do
          expect(Aces::Transfer.all.count).to eq @transfer_count + 1
          expect(@transfer.failure).to eq "Response has a failure with status 504"
          expect(@transfer.response_payload).not_to eq nil
        end
      end
    end

    context 'with valid application transfer to aces' do
      before do
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(service_ns)
        allow(service_ns).to receive(:item).and_return("aces")
        allow(transfer).to receive(:initiate_transfer).and_return(event)
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

      it "transfer should have a callback status of Success" do
        expect(@transfer.callback_status).to eq "Success"
      end
    end

    context 'to aces when given a transfer id' do
      before do
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(service_ns)
        allow(service_ns).to receive(:item).and_return("aces")
        allow(transfer).to receive(:initiate_transfer).and_return(event)
        @transfer_count = Aces::Transfer.all.count
        @transfer = Aces::Transfer.last
        @transfer.callback_status = "Failure"
        @result = transfer.call(aces_hash, @transfer.id)
      end

      it "should not create a new transfer" do
        expect(Aces::Transfer.all.count).to eq @transfer_count
      end

      it "succeeds when given a valid payload" do
        expect(@result.success?).to be_truthy
      end

      it "updates transfer tp have a callback status of Success" do
        expect(@transfer.reload.callback_status).to eq "Success"
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
  end

end