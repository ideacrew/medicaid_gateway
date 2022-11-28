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

    context '#get_applicant_checks' do
      let(:mec_check_record) { double }

      before do
        payload_hash = JSON.parse(payload)
        local_mec_evidence = payload_hash['applicants'].first['local_mec_evidence']
        expect(local_mec_evidence['aasm_state']).to eq nil
      end

      context 'with applicant Medicaid eligibility found in response' do
        before do
          response[:body] = response_body.gsub('<MECVerificationCode>N</MECVerificationCode>', '<MECVerificationCode>Y</MECVerificationCode>')
        end

        it 'should update the person evidence to :outstanding' do
          result = operation.send(:get_applicant_checks, JSON.parse(payload), mec_check_record).value!
          local_mec_evidence = result[0]['applicants'].first['local_mec_evidence']
          expect(local_mec_evidence['aasm_state']).to eq :outstanding
        end
      end

      context 'with applicant Medicaid eligibility NOT found in response' do
        it 'should update the person evidence to :attested' do
          result = operation.send(:get_applicant_checks, JSON.parse(payload), mec_check_record).value!
          local_mec_evidence = result[0]['applicants'].first['local_mec_evidence']
          expect(local_mec_evidence['aasm_state']).to eq :attested
        end
      end
    end
  end

  context 'When transfer service is for curam' do
    let(:response_body) do
      "<GetEligibilityResponse xmlns=\"http://xmlns.dhcf.dc.gov/dcas/Medicaid/Eligibility/xsd/v1\"><EligibilityFlag>Y</EligibilityFlag><RespCode>0000</RespCode><FaultMSG/><FaultDesc/></GetEligibilityResponse>"
    end

    let(:response) do
      {
        :body => response_body,
        :response_headers => {}
      }
    end

    let(:event) { Success(response) }

    context "with MEC Check feature enabled" do
      before :each do
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(feature_service)
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:curam_connection).and_return(feature_ns)
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:mec_check).and_return(feature_ns)
        allow(feature_service).to receive(:item).and_return("curam")
        allow(feature_ns).to receive(:setting).with(:curam_atp_service_uri).and_return(setting)
        allow(feature_ns).to receive(:setting).with(:curam_atp_service_username).and_return(setting)
        allow(feature_ns).to receive(:setting).with(:curam_atp_service_password).and_return(setting)
        allow(operation).to receive(:call_mec_check).and_return(event)
        allow(feature_ns).to receive(:enabled?).and_return(true)
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
        expect(mec_check.applicant_responses).to eq({ "1624289008997662" => "Success", "1624289008997663" => "Success",
                                                      "1624289008997664" => "not MEC checked" })
      end

      context '#get_applicant_checks' do
        let(:mec_check_record) { double }

        before do
          payload_hash = JSON.parse(payload)
          local_mec_evidence = payload_hash['applicants'].first['local_mec_evidence']
          expect(local_mec_evidence['aasm_state']).to eq nil
        end

        context 'with applicant Medicaid eligibility found in response' do
          it 'should update the person evidence to :outstanding' do
            result = operation.send(:get_applicant_checks, JSON.parse(payload), mec_check_record).value!
            local_mec_evidence = result[0]['applicants'].first['local_mec_evidence']
            expect(local_mec_evidence['aasm_state']).to eq :outstanding
          end
        end

        context 'with applicant Medicaid eligibility NOT found in response' do
          before do
            response[:body] = response_body.gsub('<EligibilityFlag>Y</EligibilityFlag>', '<EligibilityFlag>N</EligibilityFlag>')
          end

          it 'should update the person evidence to :attested' do
            result = operation.send(:get_applicant_checks, JSON.parse(payload), mec_check_record).value!
            local_mec_evidence = result[0]['applicants'].first['local_mec_evidence']
            expect(local_mec_evidence['aasm_state']).to eq :attested
          end
        end
      end
    end
  end
end
