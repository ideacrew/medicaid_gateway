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
    let(:inbound_transfer) { create :inbound_transfer, :to_enroll}
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
        subject
      end

      it "should record success message on the Inbound Transfer object result" do

        inbound_transfer.reload
        expect(inbound_transfer.result).to match(/Waiting to Transfer/)
      end

      it "should set failure to nil on the Inbound Transfer object" do
        expect(inbound_transfer.failure).to eq(nil)
      end

      it "should flash notice message" do
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
        subject
      end

      it "should record failure message on the Inbound Transfer object result" do
        inbound_transfer.reload
        expect(inbound_transfer.result).to match(/Failed/)
      end

      it "should update failure text on the Inbound Transfer object" do
        expect(inbound_transfer.failure).to eq(nil)
      end

      it "should flash alert message" do
        expect(flash[:alert]).to match(/Resubmit failed! - /)
      end
    end
  end

  describe 'GET account_transfers' do
    before :each do
      sign_in user
      get :account_transfers
    end

    context 'user without permission' do
      let(:user) { FactoryBot.create(:user) }

      it 'should flash no permissions message' do
        expect(flash[:notice]).to match(/Access not allowed/)
      end

      it 'should redirect to root' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user with permission' do
      let(:user) { FactoryBot.create(:user, :with_hbx_staff_role) }

      it 'should return success' do
        expect(response.status).to be(200)
      end
    end
  end

  describe 'GET account_transfers_to_enroll' do
    before :each do
      sign_in user
      get :account_transfers_to_enroll
    end

    context 'user without permission' do
      let(:user) { FactoryBot.create(:user) }

      it 'should flash no permissions message' do
        expect(flash[:notice]).to match(/Access not allowed/)
      end

      it 'should redirect to root' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user with permission' do
      let(:user) { FactoryBot.create(:user, :with_hbx_staff_role) }

      it 'should return success' do
        expect(response.status).to be(200)
      end
    end
  end

  describe 'GET mec_checks' do
    before :each do
      sign_in user
      get :mec_checks
    end

    context 'user without permission' do
      let(:user) { FactoryBot.create(:user) }

      it 'should flash no permissions message' do
        expect(flash[:notice]).to match(/Access not allowed/)
      end

      it 'should redirect to root' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user with permission' do
      let(:user) { FactoryBot.create(:user, :with_hbx_staff_role) }

      it 'should return success' do
        expect(response.status).to be(200)
      end
    end
  end

  describe 'GET transfer_summary' do
    before :each do
      sign_in user
      get :transfer_summary
    end

    context 'user without permission' do
      let(:user) { FactoryBot.create(:user) }

      it 'should flash no permissions message' do
        expect(flash[:notice]).to match(/Access not allowed/)
      end

      it 'should redirect to root' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user with permission' do
      let(:user) { FactoryBot.create(:user, :with_hbx_staff_role) }

      it 'should return success' do
        expect(response.status).to be(200)
      end
    end
  end

  describe 'GET medicaid_application_check' do
    before :each do
      sign_in user
      get :medicaid_application_check
    end

    context 'user without permission' do
      let(:user) { FactoryBot.create(:user) }

      it 'should flash no permissions message' do
        expect(flash[:notice]).to match(/Access not allowed/)
      end

      it 'should redirect to root' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user with permission' do
      let(:user) { FactoryBot.create(:user, :with_hbx_staff_role) }

      it 'should return success' do
        expect(response.status).to be(200)
      end
    end
  end

  describe 'PUT change_dates' do
    let(:user) { FactoryBot.create(:user, :with_hbx_staff_role) }
    let(:report_params) { { start_date: Date.yesterday.to_s, end_date: Date.today.to_s, session_name: '' } }

    before :each do
      sign_in user
      put :change_dates, params: { report: report_params }
    end

    it 'should store the start date in the session' do
      expect(session['start']).to eq Date.parse(report_params[:start_date])
    end

    it 'should store the end date in the session' do
      expect(session['end']).to eq Date.parse(report_params[:end_date])
    end
  end
end