# frozen_string_literal: true

require "rails_helper"

describe Aces::InitiateMecChecks, dbclean: :after_each do
  before :all do
    DatabaseCleaner.clean
  end

  include Dry::Monads[:result, :do]

  let(:payload) {File.read("./spec/test_data/application_payload.json")}
  let(:family_id) { JSON.parse(payload)["family_reference"]["hbx_id"] }
  let(:application_id) { JSON.parse(payload)["hbx_id"] }
  let(:operation) { Aces::InitiateMecChecks.new }

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
    JSON.parse(payload)["applicants"].map do |a|
      [a["person_hbx_id"],  a["local_mec_evidence"].blank? ? "not MEC checked" : "Applicant Not Found"]
    end.to_h
  end

  let(:feature_ns) { double }
  let(:setting) { double(item: "SOME URI") }

  before :each do
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:mec_check).and_return(feature_ns)
    allow(feature_ns).to receive(:setting).with(:aces_atp_service_uri).and_return(setting)
    allow(feature_ns).to receive(:setting).with(:aces_atp_service_username).and_return(setting)
    allow(feature_ns).to receive(:setting).with(:aces_atp_service_password).and_return(setting)
    allow(feature_ns).to receive(:enabled?).and_return(true)
    allow(operation).to receive(:call_mec_check).and_return(event)
    operation.call(payload)
  end

  it "there should be a mec check with the application id from the payload" do
    mec_check = Aces::MecCheck.first
    expect(mec_check.application_identifier).to eq application_id
  end

  it "there should be a mec check with the family id" do
    mec_check = Aces::MecCheck.first
    expect(mec_check.family_identifier).to eq family_id
  end

  it "the mec check should have the correct applicant_responses value" do
    mec_check = Aces::MecCheck.first
    expect(mec_check.applicant_responses).to eq expected_response
  end
end
