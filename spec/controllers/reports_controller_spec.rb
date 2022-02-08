# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportsController, type: :controller, dbclean: :after_each do
  include Dry::Monads[:result, :do]

  describe "PUT resubmit_to_service" do
    let(:user) { FactoryBot.create(:user) }
    let(:transfer) { create :transfer, :with_outbound_payload}
    let(:missing_payload_tansfer) { create :transfer }
    let(:aces_connection) { double('Aces Connection') }

    before :each do
      allow(::MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(double(item: "aces"))
      allow(::MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(aces_connection)
      allow(aces_connection).to receive(:setting).with(:aces_atp_service_username).and_return(double(item: 'username'))
      allow(aces_connection).to receive(:setting).with(:aces_atp_service_password).and_return(double(item: 'password'))
      allow(aces_connection).to receive(:setting).with(:aces_atp_service_uri).and_return(double(item: 'URI'))
      allow(Faraday).to receive(:post).and_return({ test: 'test' })

      sign_in user
    end

    context "successful resubmission" do
      subject { put :resubmit_to_service, params: { id: transfer.id } }

      it "should flash notice message" do
        subject
        expect(flash[:notice]).to match(/Successfully transferred in account/)
      end

      it "should redirect to transfer show page" do
        expect(subject).to redirect_to(aces_transfer_path(transfer))
      end
    end

    context "failed resubmission" do
      subject { put :resubmit_to_service, params: { id: missing_payload_tansfer.id } }

      it "should flash alert message" do
        subject
        expect(flash[:alert]).to match(/Application does not contain any applicants applying for coverage./)
      end
    end
  end

  describe "PUT resubmit_to_enroll" do
    let(:user) { FactoryBot.create(:user) }
    let(:inbound_transfer) { create :inbound_transfer}
    let(:process_atp_soap_request) { instance_double(Aces::ProcessAtpSoapRequest) }
    let(:body) { File.read("./spec/test_data/Simple_Test_Case_L_New.xml") }

    before :each do
      allow(Aces::ProcessAtpSoapRequest).to receive(:new).and_return(process_atp_soap_request)
      sign_in user
    end

    context "successful resubmission" do
      subject { put :resubmit_to_enroll, params: { id: inbound_transfer.id } }

      before do
        allow(process_atp_soap_request).to receive(:call).with(inbound_transfer.payload, inbound_transfer.id).and_return(Success(body))
      end

      it "should flash notice message" do
        subject
        expect(flash[:notice]).to match(/Successfully resubmitted to Enroll/)
      end

      it "should redirect to inbound transfer show page" do
        expect(subject).to redirect_to(aces_inbound_transfer_path(inbound_transfer))
      end
    end

    context "failed resubmission" do
      subject { put :resubmit_to_enroll, params: { id: inbound_transfer.id } }

      before do
        allow(process_atp_soap_request).to receive(:call).with(inbound_transfer.payload, inbound_transfer.id).and_return(Failure(""))
      end

      it "should flash alert message" do
        subject
        expect(flash[:alert]).to match(/Resubmit failed! - /)
      end
    end
  end
end