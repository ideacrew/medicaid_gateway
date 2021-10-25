# frozen_string_literal: true

require "rails_helper"

describe Curam::CheckPayload, "given a valid account transfer check request", dbclean: :after_each do
  before :all do
    DatabaseCleaner.clean
  end

  include Dry::Monads[:result, :do]

  let(:operation) { Curam::CheckPayload.new }

  let(:id) {"SBM123"}

  let!(:transfer) { FactoryBot.create(:transfer, id: id) }

  let(:response_body) do
    "<env:Envelope>
      <env:Body>
        <AccTransStatusByIdRes xmlns:tns=\"http://xmlns.dhs.dc.gov/dcas/esb/acctransappstatuccheck/V1\">
          <tns:AccTransStatusResData>
            <tns:APPLICATIONID>6918320676013080576</tns:APPLICATIONID>
            <tns:GLOBALAPPLICATIONID>SBM123</tns:GLOBALAPPLICATIONID>
            <tns:STATUS>Federal Exchange Inbound Error</tns:STATUS>
            <tns:VERSIONNO>6</tns:VERSIONNO>
            <tns:LASTWRITTEN>2021-01-01T08:55:01.000-04:00</tns:LASTWRITTEN>
          </tns:AccTransStatusResData>
        </AccTransStatusByIdRes>
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

  before :each do
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:curam_connection)
    allow(MedicaidGatewayRegistry[:curam_connection]).to receive(:setting).with(:curam_atp_service_username)
    allow(MedicaidGatewayRegistry[:curam_connection].setting(:curam_atp_service_username)).to receive(:item).and_return("random_name")
    allow(MedicaidGatewayRegistry[:curam_connection]).to receive(:setting).with(:curam_atp_service_password)
    allow(MedicaidGatewayRegistry[:curam_connection].setting(:curam_atp_service_password)).to receive(:item).and_return("random_pw")
    allow(MedicaidGatewayRegistry[:curam_connection]).to receive(:setting).with(:curam_check_service_uri)
    allow(MedicaidGatewayRegistry[:curam_connection].setting(:curam_check_service_uri)).to receive(:item).and_return("random_uri")
    allow(operation).to receive(:submit_check).and_return(event)
  end

  it "initally the transfer should not have a callback status" do
    updated_transfer = Aces::Transfer.find(id)
    expect(updated_transfer.callback_status).to_not eq "Federal Exchange Inbound Error"
  end

  it "calling the check payload should update the transfer callback status" do
    operation.call(id)
    updated_transfer = Aces::Transfer.find(id)
    expect(updated_transfer.callback_status).to eq "Federal Exchange Inbound Error"
  end

end
