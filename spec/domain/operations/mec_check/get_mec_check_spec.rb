# frozen_string_literal: true

require "rails_helper"

describe MecCheck::GetMecCheck, dbclean: :after_each do
  before :all do
    DatabaseCleaner.clean
  end

  include Dry::Monads[:result, :do]
  let(:application) {File.read("./spec/test_data/application_payload.json")}
  let!(:valid_applicant) { JSON.parse(application)["applicants"].first }
  let!(:invalid_applicant) { JSON.parse(application)["applicants"].last }
  let(:operation) { MecCheck::GetMecCheck.new }
  let!(:job) { FactoryBot.create(:transmittable_job, message_id: Time.now.to_i.to_s)}
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

    let(:expected_response) do
      { :result => :eligible, :source => "CHIP", :code => "7313", :code_description => "Applicant Not Found", :mec_verification_code => "N" }
    end

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
      it 'Without correlation id' do
        result = operation.call(person: valid_applicant, job: job)
        expect(result.failure?).to be_truthy
        expect(result.failure).to eq("Cannot get mec check without correlation_id")
      end

      it 'Without person id' do
        result = operation.call(correlation_id: valid_applicant["person_hbx_id"], job: job)
        expect(result.failure?).to be_truthy
        expect(result.failure).to eq("Cannot get mec check without person")
      end

      it 'Without person id' do
        result = operation.call(person: valid_applicant, correlation_id: valid_applicant["person_hbx_id"])
        expect(result.failure?).to be_truthy
        expect(result.failure).to eq("Cannot get mec check without job")
      end

      context 'With a person without local mec check evedence' do
        before do
          @result = operation.call(person: invalid_applicant, correlation_id: invalid_applicant["person_hbx_id"], job: job)
          @transactions = job.transmissions.map(&:transactions_transmissions).flatten.map(&:transaction)
        end

        it 'Should raise a failure' do
          expect(@result.failure?).to be_truthy
          expect(@result.failure).to eq "Not MEC checked. No evidence present"
        end

        it 'Should have one transmission' do
          expect(job.transmissions.count).to eq(1)
          expect(job.transmissions.first.key).to eq(:application_mec_check_request)
        end

        it 'Should have one transaction' do
          expect(@transactions.count).to eq(1)
          expect(@transactions.first.key).to eq(:application_mec_check_request)
        end

        it 'Should have transmittable error on transmission' do
          expect(job.transmissions.first.process_status.latest_state).to eq(:failed)
          expect(job.transmissions.first.transmittable_errors.first.key).to eq(:run_mec_check)
          expect(job.transmissions.first.transmittable_errors.first.message).to eq "Not MEC checked. No evidence present"
        end

        it 'Should have transmittable error on transaction' do
          expect(@transactions.first.process_status.latest_state).to eq(:failed)
          expect(@transactions.first.transmittable_errors.first.key).to eq(:run_mec_check)
          expect(@transactions.first.transmittable_errors.first.message).to eq "Not MEC checked. No evidence present"
        end
      end
    end

    context 'valid parameters' do
      before do
        @result = operation.call(person: valid_applicant, correlation_id: valid_applicant["person_hbx_id"], job: job)
        @transactions = job.transmissions.map(&:transactions_transmissions).flatten.map(&:transaction)
      end

      it 'Should be a success' do
        expect(@result.success?).to be_truthy
      end

      it 'should have the expected response' do
        expect(@result.value!).to eq expected_response
      end

      it 'should have request and response transmissions' do
        expect(job.transmissions.count).to eq(2)
      end

      it 'should have request and response transmission keys' do
        expect(job.transmissions.pluck(:key)).to eq [:application_mec_check_request, :application_mec_check_response]
      end

      it 'should have request and response transmissions should have success status' do
        expect(job.transmissions.map(&:process_status).map(&:latest_state).uniq).to eq [:succeeded]
      end

      it 'should have request and response transaction' do
        expect(@transactions.map(&:key)).to eq [:application_mec_check_request, :application_mec_check_response]
      end

      it 'should have request and response transaction' do
        expect(@transactions.map(&:process_status).map(&:latest_state).uniq).to eq [:succeeded]
      end

      it 'should have request and response transaction' do
        expect(@transactions.first.transactable).to_not eq nil
        expect(@transactions.first.transactable.class).to eq Transmittable::Person
        expect(@transactions.first.transactable).to eq @transactions.last.transactable
        expect(@transactions.first.xml_payload).not_to eq nil
        expect(@transactions.last.xml_payload).not_to eq nil
        expect(@transactions.last.json_payload).not_to eq nil
      end

      it 'should have records populated in process_status model for each transaction' do
        transaction_ids = Transmittable::Transaction.all.map { |tid| BSON::ObjectId.from_string(tid._id) }
        expect(Transmittable::ProcessStatus.succeeded(transaction_ids).count).to eq(transaction_ids.count)
      end
    end
  end
end
