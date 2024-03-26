# frozen_string_literal: true

require "rails_helper"

describe Aces::ProcessAtpSoapRequest, "given a soap envelope with an valid xml payload", dbclean: :after_each do
  include Dry::Monads[:result]

  before :all do
    DatabaseCleaner.clean
  end

  let(:xml) { File.read("./spec/test_data/transfer_to_enroll.xml") }
  let(:cms_xml) { File.read("./spec/test_data/transfer_to_enroll_from_cms.xml") }

  let(:operation) { Aces::ProcessAtpSoapRequest.new }
  let(:feature_ns) { double }

  before :each do
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_to_enroll)
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:transfer_service)
    allow(MedicaidGatewayRegistry[:aces_connection]).to receive(:setting).with(:aces_atp_caller_username).and_return(double)
    allow(MedicaidGatewayRegistry[:aces_connection].setting(:aces_atp_caller_username)).to receive(:item).and_return("SOME_SOAP_USER")
    allow(MedicaidGatewayRegistry[:aces_connection]).to receive(:setting).with(:aces_atp_caller_password).and_return(double)
    allow(MedicaidGatewayRegistry[:aces_connection].setting(:aces_atp_caller_password)).to receive(:item).and_return("SOME SOAP PASSWORD")
    allow(MedicaidGatewayRegistry[:transfer_service]).to receive(:item).and_return("SERVICE")
    allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:transfer_to_enroll).and_return(false)
    allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:resubmit_to_enroll).and_return(false)
    allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:bulk_transfer_to_enroll).and_return(false)
  end

  context 'from aces' do
    before do
      @transfer = create :inbound_transfer
      @result = operation.call(xml, @transfer.id)
    end

    it "payload processing should be successful" do
      expect(@result.success?).to be_truthy
    end

    it "transfer to_enroll should be true" do
      expect(@transfer.reload.to_enroll).to eq true
    end
  end

  context 'from CMS' do
    before do
      @transfer = create :inbound_transfer
      @result = operation.call(cms_xml, @transfer.id)
    end

    it "payload processing should be successful" do
      expect(@result.success?).to be_truthy
    end

    it "transfer to_enroll should be false" do
      expect(@transfer.reload.to_enroll).to eq false
    end
  end

  context '#run_validations_and_serialize' do
    context 'when @to_enroll is true' do
      before do
        operation.instance_variable_set(:@to_enroll, true)
      end
      context 'schema validation' do
        context 'failure' do
          before do
            allow(operation).to receive(:validate_document).and_return(Failure(["schema validation failed"]))
          end

          it 'should return a failure object' do
            expect(operation.send(:run_validations_and_serialize, "string_payload").failure?).to be_truthy
          end
        end
      end

      context 'business validation' do
        context 'success' do
          before do
            allow(operation).to receive(:validate_document).and_return(Success(:ok))
            allow(operation).to receive(:run_business_validations).and_return(Success(:ok))
          end

          it 'should return a success object' do
            expect(operation.send(:run_validations_and_serialize, "string_payload").success?).to be_truthy
          end
        end

        context 'failure' do
          let(:failed_assertion) { Aces::AtpFailedBusinessAssertion.new({ location: "location", text: "failure message" }) }
          let(:rule_failure) { Aces::AtpBusinessRuleFailure.new({ failed_assertions: [failed_assertion] }) }
          before do
            allow(operation).to receive(:validate_document).and_return(Success(:ok))
            allow(operation).to receive(:run_business_validations).and_return(Failure(rule_failure))
          end

          it 'should return a failure object' do
            expect(operation.send(:run_validations_and_serialize, "string_payload").failure?).to be_truthy
          end
        end
      end
    end
  end
end