# frozen_string_literal: true

require "rails_helper"
require 'aca_entities/serializers/xml/medicaid/atp'
require 'aca_entities/medicaid/atp'
require 'aca_entities/atp/operations/aces/generate_xml'

describe Transfers::ToService, "given an ATP valid payload, transfer it to the specified service" do
  include Dry::Monads[:result, :do]

  let(:aces_hash) {File.read("./spec/test_data/application_and_family.json")}
  let(:transfer) {described_class.new}

  let(:feature_ns) { double }
  let(:service_ns) { double }

  let(:response_body) do
    "<env:Envelope xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\">
      <env:Body>
        <AccountTransferResponse xmlns=\"http://at.dsh.cms.gov/exchange/1.0\" atVersionText=\"\">
          <ResponseMetadata xmlns=\"http://at.dsh.cms.gov/extension/1.0\">
            <ResponseCode xmlns=\"http://hix.cms.gov/0.1/hix-core\">HS000000</ResponseCode>
            <ResponseDescriptionText xmlns=\"http://hix.cms.gov/0.1/hix-core\">Success</ResponseDescriptionText>
          </ResponseMetadata>
        </AccountTransferResponse>
      </env:Body>
    </env:Envelope>"
  end

  let(:response) do
    {
      :status => 200,
      :body => response_body,
      :response_headers => {}
    }
  end

  let(:event) { Success(response) }

  before do
    allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).and_call_original
    allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(
      :execute_outbound_atp_business_rules
    ).and_return(outbound_business_validation_enabled)
  end

  let(:outbound_business_validation_enabled) { false }

  context 'success' do
    context 'with valid application transfer to curam' do
      before do
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:curam_connection).and_return(feature_ns)
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(service_ns)
        allow(service_ns).to receive(:item).and_return("curam")
        allow(transfer).to receive(:initiate_transfer).and_return(event)
        @transfer_count = Aces::Transfer.all.count
        @result = transfer.call(aces_hash)
      end

      it "should create a new transfer" do
        expect(Aces::Transfer.all.count).to eq @transfer_count + 1
      end

      it "succeeds when given a valid payload" do
        expect(@result.success?).to be_truthy
      end
    end

    context 'to curam when given a transfer id' do
      before do
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:curam_connection).and_return(feature_ns)
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(service_ns)
        allow(service_ns).to receive(:item).and_return("curam")
        allow(transfer).to receive(:initiate_transfer).and_return(event)
        @transfer = Aces::Transfer.last
        @transfer_count = Aces::Transfer.all.count
        @result = transfer.call(aces_hash, @transfer.id)
      end

      it "should not create a new transfer" do
        expect(Aces::Transfer.all.count).to eq @transfer_count
      end

      it "succeeds when given a valid payload" do
        expect(@result.success?).to be_truthy
      end

    end

    context 'with valid application transfer response not as 200' do
      let(:failure_response) do
        {
          :status => 504,
          :body => response_body,
          :response_headers => {}
        }
      end

      let(:event) { Success(failure_response) }

      before do
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(service_ns)
        allow(transfer).to receive(:initiate_transfer).and_return(event)
      end

      context 'ACES Service' do
        before do
          allow(service_ns).to receive(:item).and_return("aces")
          @transfer_count = Aces::Transfer.all.count
          transfer.call(aces_hash)
          @transfer = Aces::Transfer.last
        end

        it "should create a new transfer with failure message" do
          expect(Aces::Transfer.all.count).to eq @transfer_count + 1
          expect(@transfer.failure).to eq "Response has a failure with status 504"
          expect(@transfer.response_payload).not_to eq nil
        end
      end

      context 'Non-ACEs Services' do
        before do
          allow(service_ns).to receive(:item).and_return("curam")
          @transfer_count = Aces::Transfer.all.count
          transfer.call(aces_hash)
          @transfer = Aces::Transfer.last
        end

        it "should create a new transfer with failure message" do
          expect(Aces::Transfer.all.count).to eq @transfer_count + 1
          expect(@transfer.failure).to eq "Response has a failure with status 504"
          expect(@transfer.response_payload).not_to eq nil
        end
      end
    end

    context 'with valid application transfer to aces' do
      before do
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(service_ns)
        allow(service_ns).to receive(:item).and_return("aces")
        allow(transfer).to receive(:initiate_transfer).and_return(event)
        @transfer_count = Aces::Transfer.all.count
        @result = transfer.call(aces_hash)
        @transfer = Aces::Transfer.last
      end

      it "should create a new transfer" do
        expect(Aces::Transfer.all.count).to eq @transfer_count + 1
      end

      it "succeeds when given a valid payload" do
        expect(@result.success?).to be_truthy
      end

      it "transfer should have a callback status of Success" do
        expect(@transfer.callback_status).to eq "Success"
      end

      context ":execute_outbound_atp_business_rules is enabled, and an invalid payload is provided" do
        let(:outbound_business_validation_enabled) { true }
        let(:aces_hash) {File.read("./spec/test_data/application_and_family_failing_business_rules.json")}

        it "fails" do
          expect(@result.success?).to be_falsey
          expect(@result.failure.is_a?(Aces::AtpBusinessRuleFailure)).to be_truthy
        end
      end
    end

    context 'to aces when given a transfer id' do
      before do
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(service_ns)
        allow(service_ns).to receive(:item).and_return("aces")
        allow(transfer).to receive(:initiate_transfer).and_return(event)
        @transfer_count = Aces::Transfer.all.count
        @transfer = Aces::Transfer.last
        @transfer.callback_status = "Failure"
        @result = transfer.call(aces_hash, @transfer.id)
      end

      it "should not create a new transfer" do
        expect(Aces::Transfer.all.count).to eq @transfer_count
      end

      it "succeeds when given a valid payload" do
        expect(@result.success?).to be_truthy
      end

      it "updates transfer to have a callback status of Success" do
        expect(@transfer.reload.callback_status).to eq "Success"
      end
    end
  end

  context 'failure' do
    context 'with no application present in payload' do
      before do
        payload = JSON.parse(aces_hash)
        payload["family"]["magi_medicaid_applications"] = {}
        params = payload.to_json
        @result = transfer.call(params)
      end

      it 'should fail when no application is present in the payload' do
        error_message = @result.failure[:failure]
        expect(error_message).to eq "No application found in payload."
      end
    end

    context 'with no applicants applying for coverage' do
      before do
        payload = JSON.parse(aces_hash)
        non_applicants = payload.dig("family", "magi_medicaid_applications", "applicants").each do |applicant|
          applicant["is_applying_coverage"] = false
        end
        payload["family"]["magi_medicaid_applications"]["applicants"] = non_applicants
        params = payload.to_json
        @result = transfer.call(params)
      end

      it 'should fail when no applicants are applying for coverage' do
        error_message = @result.failure[:failure]
        expect(error_message).to eq "Application does not contain any applicants applying for coverage."
      end
    end

    context 'when an applicant has vlp document' do
      let(:vlp_doc) do
        {
          subject: vlp_subject,
          alien_number: "987654321",
          passport_number: "12345678",
          sevis_id: "1234567891",
          i94_number: "123456789012",
          country_of_citizenship: "Albania",
          expiration_date: "2030-01-01T00:00:00.000+00:00"
        }
      end

      before do
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:curam_connection).and_return(feature_ns)
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(service_ns)
        allow(service_ns).to receive(:item).and_return("curam")
        allow(transfer).to receive(:initiate_transfer).and_return(event)
        payload = JSON.parse(aces_hash)
        applicant = payload.dig("family", "magi_medicaid_applications", "applicants").first
        applicant['vlp_document'] = vlp_doc
        params = payload.to_json
        @result = transfer.call(params)
        @person_hbx_id = applicant['person_hbx_id']
      end

      context 'when vlp_document is of Other types' do
        before do
          allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:drop_income_start_on).and_return(false)
          allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:drop_income_end_on).and_return(false)
          allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:drop_non_ssn_apply_reason).and_return(false)
          allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:invert_person_association).and_return(false)
        end

        context 'with vlp document type of Other (With Alien Number)' do
          let(:vlp_subject) { "Other (With Alien Number)" }

          it 'should be success' do
            expect(@result.success?).to eq true
          end
        end

        context 'with vlp document type of Other (With I-94 Number)' do
          let(:vlp_subject) { "Other (With I-94 Number)" }

          it 'should be success' do
            expect(@result.success?).to eq true
          end
        end
      end
    end

    context 'when an applicant has deductions' do
      let(:deduction) do
        {
          name: nil,
          kind: "alimony_paid",
          amount: 90.0,
          start_on: "2022-01-01",
          end_on: nil,
          frequency_kind: "Monthly",
          submitted_at: "2022-10-05T16:48:03.000+00:00"
        }
      end

      before do
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:curam_connection).and_return(feature_ns)
        allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service).and_return(service_ns)
        allow(service_ns).to receive(:item).and_return("curam")
        allow(transfer).to receive(:initiate_transfer).and_return(event)
        allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(any_args).and_call_original
        allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:block_atp_deductions).and_return(true)
        payload = JSON.parse(aces_hash)
        applicant = payload.dig("family", "magi_medicaid_applications", "applicants").first
        applicant['deductions'] = [deduction]
        params = payload.to_json
        @result = transfer.call(params)
        @person_hbx_id = applicant['person_hbx_id']
      end

      context 'when block_atp_deductions feature is enabled' do
        it 'should fail to transfer and log as error' do
          error_message = @result.failure[:failure]
          expect(error_message).to eq "Applicant #{@person_hbx_id} has unaccepted deductions: #{deduction[:kind]}."
        end
      end
    end
  end

  context '#add_param_flags' do
    let(:params) {JSON.parse(aces_hash)}
    let(:transfer_record) do
      Transfers::Create.new.call({
                                   service: 'service',
                                   application_identifier: params["family"]["magi_medicaid_applications"]["hbx_id"],
                                   family_identifier: params["family"]["family_members"].detect { |fm| fm["is_primary_applicant"] == true }["hbx_id"],
                                   outbound_payload: aces_hash
                                 }).value!
    end

    context 'valid feature flags' do
      before do
        allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:drop_income_start_on).and_return(true)
        allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:drop_income_end_on).and_return(true)
        allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:drop_non_ssn_apply_reason).and_return(true)
        allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:drop_vlp_document).and_return(false)
        allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:drop_temp_out_of_state).and_return(false)
        allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:invert_person_association).and_return(true)
        result_value = Transfers::ToService.new.send(:add_param_flags, aces_hash, transfer_record.id).value!
        @result_hash = JSON.parse(result_value)
      end

      it 'should add the enabled drop param flags to the payload' do
        expect(@result_hash.keys).to include 'drop_param_flags'
        expect(@result_hash['drop_param_flags']).to eq ['drop_non_ssn_apply_reason', 'drop_income_start_on', 'drop_income_end_on']
      end

      it 'should add the enabled family flags to the payload' do
        expect(@result_hash['family'].keys).to include 'family_flags'
        expect(@result_hash['family']['family_flags']['invert_person_association']).to eq true
      end
    end
  end
end
