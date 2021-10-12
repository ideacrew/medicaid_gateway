# frozen_string_literal: true

require "rails_helper"

describe Aces::InitiateMecCheck, "given a person payload", dbclean: :after_each do
  before :all do
    DatabaseCleaner.clean
  end

  include Dry::Monads[:result, :do]

  let(:payload) {File.read("./spec/test_data/person.json")}
  let(:operation) { Aces::InitiateMecCheck.new }

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

  let(:expected_response) { { "d81d92cf869540ed804b21d7b22352c6" => "Applicant Not Found" } }
  let(:feature_ns) { double }
  let(:setting) { double(item: "SOME URI") }

  context "with MEC Check feature disabled" do
    before :each do
      allow(feature_ns).to receive(:enabled?).and_return(false)
      result = operation.call(payload)
      expect(result.failure).to eq({ error: "MEC Check feature not enabled." })
    end
  end

  context "with MEC Check feature enabled" do
    before :each do
      allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
      allow(MedicaidGatewayRegistry).to receive(:[]).with(:mec_check).and_return(feature_ns)
      allow(feature_ns).to receive(:setting).with(:aces_atp_service_uri).and_return(setting)
      allow(feature_ns).to receive(:setting).with(:aces_atp_service_username).and_return(setting)
      allow(feature_ns).to receive(:setting).with(:aces_atp_service_password).and_return(setting)
      allow(operation).to receive(:call_mec_check).and_return(event)
      allow(feature_ns).to receive(:enabled?).and_return(true)
      operation.call(payload)
    end
    it "there should be a mec check with the family id" do
      mec_check = Aces::MecCheck.first
      expect(mec_check.family_identifier).to eq "10450"
    end

    it "the mec check should have the correct applicant_responses value" do
      mec_check = Aces::MecCheck.first
      expect(mec_check.applicant_responses).to eq expected_response
    end
  end
end

describe Aces::InitiateMecCheck, "given an application payload", dbclean: :after_each do
  before :all do
    DatabaseCleaner.clean
  end

  include Dry::Monads[:result, :do]

  let(:payload) {File.read("./spec/test_data/application_payload.json")}
  let(:operation) { Aces::InitiateMecCheck.new }

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

  let(:expected_response) { { "1003158" => "Applicant Not Found", "1002699" => "Applicant Not Found" } }
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
    expect(mec_check.application_identifier).to eq "1000886"
  end

  it "there should be a mec check with the family id" do
    mec_check = Aces::MecCheck.first
    expect(mec_check.family_identifier).to eq "10449"
  end

  it "the mec check should have the correct applicant_responses value" do
    mec_check = Aces::MecCheck.first
    expect(mec_check.applicant_responses).to eq expected_response
  end

end
