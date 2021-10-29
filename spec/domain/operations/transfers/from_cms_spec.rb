# frozen_string_literal: true

require "rails_helper"

describe Transfers::FromCms, "given an xml payload from CMS send it to ACES" do
  include Dry::Monads[:result, :do]

  let(:xml) {File.read("./spec/test_data/from_cms.xml")}
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
      :status => 200,
      :body => response_body,
      :response_headers => {}
    }
  end

  let(:event) { Success(response) }

  context 'success' do

    context 'with valid payload transfer to aces' do
      before do
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(service_ns)
        allow(service_ns).to receive(:item).and_return("aces")
        allow(transfer).to receive(:initiate_transfer).and_return(event)
        @transfer_count = Aces::Transfer.all.count
        @result = transfer.call(xml)
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
  end

end