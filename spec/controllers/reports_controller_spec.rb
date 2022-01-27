# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportsController, type: :controller, dbclean: :after_each do

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
end