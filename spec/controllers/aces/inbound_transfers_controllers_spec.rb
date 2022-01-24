# frozen_string_literal: true

require 'rails_helper'

# Spec for InboundTransfersController
module Aces
  RSpec.describe InboundTransfersController, type: :controller, dbclean: :after_each do

    let(:feature_ns) { double }
    let(:username_setting) { double(item: "SOME_SOAP_USER") }
    let(:password_setting) { double(item: "SOME SOAP PASSWORD") }

    describe 'GET new' do
      let(:user) { FactoryBot.create(:user) }

      before :each do
        sign_in user
        get :new
      end

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end
    end

    describe 'POST create' do
      let(:user) { FactoryBot.create(:user) }
      let(:valid_payload) do
        File.read("./spec/test_data/Simple_Test_Case_L_New.xml")
      end
      let(:invalid_payload) do
        "Not valid xml!"
      end

      context 'with valid payload' do
        before :each do
          sign_in user
          allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
          allow(feature_ns).to receive(:setting).with(:aces_atp_caller_username).and_return(username_setting)
          allow(feature_ns).to receive(:setting).with(:aces_atp_caller_password).and_return(password_setting)
          expect(InboundTransfer.all.count).to eq 0
          post :create, params: { inbound_transfer: { payload: valid_payload, result: "Received" } }
          @transfer = InboundTransfer.all.last
        end

        it 'should create a transfer' do
          expect(InboundTransfer.all.count).to eq 1
        end

        it 'should set the result' do
          expect(@transfer.result).to eq "Waiting to Transfer"
        end

        it 'should not have a failure message' do
          expect(@transfer.failure).to eq nil
        end
      end

      context 'with invalid payload' do
        before :each do
          sign_in user
          allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
          allow(feature_ns).to receive(:setting).with(:aces_atp_caller_username).and_return(username_setting)
          allow(feature_ns).to receive(:setting).with(:aces_atp_caller_password).and_return(password_setting)
          expect(InboundTransfer.all.count).to eq 0
          post :create, params: { inbound_transfer: { payload: invalid_payload, result: "Received" } }
          @transfer = InboundTransfer.all.last
        end

        it 'should create a transfer' do
          expect(InboundTransfer.all.count).to eq 1
        end

        it 'should not be set the result' do
          expect(@transfer.result).to eq "Failed"
        end

        it 'should record the failure message' do
          expect(@transfer.failure).to_not eq nil
        end
      end
    end
  end
end