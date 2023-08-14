# frozen_string_literal: true

require "rails_helper"

describe MecCheck::InitiateApplicationMecChecks, dbclean: :after_each do
  before :all do
    DatabaseCleaner.clean
  end

  include Dry::Monads[:result, :do]

  let(:payload) {File.read("./spec/test_data/application_payload.json")}
  let(:operation) { MecCheck::InitiateApplicationMecChecks.new }
  let(:feature_service) { double }
  let(:feature_ns) { double }
  let(:setting) { double(item: "SOME URI") }
  let(:submit_mec_check_instance) { instance_double(Aces::SubmitMecCheckPayload) }

  context 'request for Aces' do
    let(:response_body) do
      "<VerifyNonESIMECResponse xmlns=\"http://gov.hhs.cms.hix.dsh.ee.nonesi_mec.ext\">
          <NonESIMECResponse>
              <ResponseCode>7313</ResponseCode>
              <ResponseDescription>Applicant Not Found</ResponseDescription>
              <NonESIMECIndividualResponse>
                  <PersonSSN>214344538</PersonSSN>
                  <SourceInformation>
                      <MECVerificationCode>N</MECVerificationCode>
                  </SourceInformation>
                  <OrganizationCode>CHIP</OrganizationCode>
              </NonESIMECIndividualResponse>
          </NonESIMECResponse>
      </VerifyNonESIMECResponse>"
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
      allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(feature_service)
      allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
      allow(MedicaidGatewayRegistry).to receive(:[]).with(:mec_check).and_return(feature_ns)
      allow(feature_service).to receive(:item).and_return("aces")
      allow(feature_ns).to receive(:setting).with(:aces_atp_service_uri).and_return(setting)
      allow(feature_ns).to receive(:setting).with(:aces_atp_service_username).and_return(setting)
      allow(feature_ns).to receive(:setting).with(:aces_atp_service_password).and_return(setting)
      allow(feature_ns).to receive(:enabled?).and_return(true)
      allow(Aces::SubmitMecCheckPayload).to receive(:new).and_return(submit_mec_check_instance)
      allow(submit_mec_check_instance).to receive(:call).and_return(event)
    end

    context 'invalid parameters' do
      it 'should raise error' do
        result = operation.call(test: 123)
        expect(result.failure?).to be_truthy
        expect(result.failure).to eq({ :error => "Payload cannot be empty" })
      end
    end

    context 'valid parameters' do
      let!(:job) { FactoryBot.create(:transmittable_job, message_id: Time.now.to_i.to_s)}

      it 'should not raise error and should not create new job' do
        expect(job.transmissions.count).to eq(0)
        result = operation.call(payload: payload, message_id: job.message_id)
        expect(result.success?).to be_truthy
        expect(job.transmissions.count).to eq(5)
      end

      it 'should not raise if message_id is optional and create a new job' do
        expect(Transmittable::Job.all.count).to eq(1)
        expect(operation.call(payload: payload).success?).to be_truthy
        expect(Transmittable::Job.all.count).to eq(2)
      end

      context "it should create a transmittable job" do
        before do
          operation.call(payload: payload, message_id: Time.now.to_i.to_s)
          @transmission_first_applicant = job.transmissions.where(key: :application_mec_check_request).first
          @transaction_first_applicant = @transmission_first_applicant.transactions_transmissions.first.transaction
          @response_transmissions = job.transmissions.where(key: :application_mec_check_response)
        end

        it "Job should have message id" do
          expect(job.message_id).not_to eq nil
        end

        it "Should create request transmission for all the 3 applicants" do
          expect(job.transmissions.where(key: :application_mec_check_request).count).to eq(3)
        end

        it "Should create request transmission for all the 3 applicants" do
          expect(@transmission_first_applicant.transactions_transmissions.count).to eq(1)
          expect(@transaction_first_applicant.key).to eq(:application_mec_check_request)
          expect(@transaction_first_applicant.xml_payload).not_to eq nil
          expect(@transaction_first_applicant.process_status.latest_state).to eq :succeeded
        end

        it "Should create response transmission for 2 applicants" do
          expect(@response_transmissions.count).to eq(2) # since one of the applicants does not have local_mec_evidence
          expect(@response_transmissions.first.process_status.latest_state).to eq(:succeeded)
          expect(@response_transmissions.first.transactions_transmissions.first.transaction).not_to eq nil
        end

        it "should create a response transaction for the applicant with local_mec_evidence" do
          response_transaction = @response_transmissions.first.transactions_transmissions.first.transaction
          expect(response_transaction.key).to eq(:application_mec_check_response)
          expect(response_transaction.json_payload).not_to eq nil
          expect(response_transaction.process_status.latest_state).to eq(:succeeded)
        end
      end
    end
  end
end
