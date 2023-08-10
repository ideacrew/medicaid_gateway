# frozen_string_literal: true

require "rails_helper"

describe MecCheck::InitiateApplicationMecChecks, dbclean: :after_each do
  before :all do
    DatabaseCleaner.clean
  end

  include Dry::Monads[:result, :do]

  let(:payload) {File.read("./spec/test_data/application_payload.json")}
  let(:family_id) { JSON.parse(payload)["family_reference"]["hbx_id"] }
  let(:application_id) { JSON.parse(payload)["hbx_id"] }
  let(:operation) { MecCheck::InitiateApplicationMecChecks.new }
  let(:feature_service) { double }
  let(:feature_ns) { double }
  let(:setting) { double(item: "SOME URI") }

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
      JSON.parse(payload)["applicants"].to_h do |a|
        [a["person_hbx_id"],  a["local_mec_evidence"].blank? ? "not MEC checked" : "Applicant Not Found"]
      end
    end

    before :each do
      allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(feature_service)
      allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
      allow(MedicaidGatewayRegistry).to receive(:[]).with(:mec_check).and_return(feature_ns)
      allow(feature_service).to receive(:item).and_return("aces")
      allow(feature_ns).to receive(:setting).with(:aces_atp_service_uri).and_return(setting)
      allow(feature_ns).to receive(:setting).with(:aces_atp_service_username).and_return(setting)
      allow(feature_ns).to receive(:setting).with(:aces_atp_service_password).and_return(setting)
      allow(feature_ns).to receive(:setting).with(:aces_mec_check_uri).and_return(nil)
      allow(feature_ns).to receive(:enabled?).and_return(true)
      Transmittable::CreateJob.new.call({
                                          key: :application_mec_check_request,
                                          started_at: DateTime.now,
                                          publish_on: DateTime.now,
                                          message_id: 1234
                                        })
    end

    context 'valid parameters' do
      # it 'should not raise error' do
      #   message_id = Transmittable::Job.last.message_id
      #   expect(operation.call(payload: payload, message_id: message_id).success?).to be_truthy
      # end

      it 'should not raise if message_id is optional' do
        expect(operation.call(payload: payload).success?).to be_truthy
      end
    end

    context 'invalid parameters' do
      it 'should raise error' do
        expect(operation.call(test: 123).success?).to be_falsey
      end
    end

    context "it should create a transmittable job" do

      # it "creates a job with nil message_id if not sent in params" do
      #   operation.call(payload: payload)
      #   expect(Transmittable::Job.count).to eq(2)
      #   expect(Transmittable::Job.last.message_id).eq nil
      # end
    end
  end
end
