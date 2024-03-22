# frozen_string_literal: true

require "rails_helper"

describe Transfers::ExecuteBusinessXmlValidations, dbclean: :after_each do
  include Dry::Monads[:result]

  let(:subject) do
    Transfers::ExecuteBusinessXmlValidations.new
  end
  let(:result) { subject.call(payload) }

  context "given an empty payload" do
    let(:payload) { "" }

    it "crashes" do
      expect(result.success?).not_to be_truthy
    end
  end

  context "given a payload with an empty body" do
    let(:payload) do
      <<-XMLCODE
      <ns8:AccountTransferRequest ns4:atVersionText="2.3" xmlns:ns2="http://hix.cms.gov/0.1/hix-core" xmlns:ns4="http://at.dsh.cms.gov/extension/1.0" xmlns:ns5="http://hix.cms.gov/0.1/hix-ee" xmlns:ns6="http://niem.gov/niem/domains/screening/2.1" xmlns:ns7="http://hix.cms.gov/0.1/hix-pm" xmlns:ns8="http://at.dsh.cms.gov/exchange/1.0">
      </ns8:AccountTransferRequest>
      XMLCODE
    end

    it "fails" do
      expect(result.success?).not_to be_truthy
    end

    it "returns the errors" do
      failure_object = result.failure
      expect(failure_object.is_a?(Aces::AtpBusinessRuleFailure)).to be_truthy
    end
  end

  context "validator crashed" do
    let(:validator_result) do
      <<-XMLCODE
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
      </svrl:schematron-output>
      XMLCODE
    end
    let(:payload) { double }
    let(:stubbed_validation_responses) { [proc { raise StandardError }, proc { validator_result }] }
    let(:result) { subject.call(payload) }

    before do
      allow(AtpBusinessRulesValidationProxy).to receive(:run_validation).with(payload).exactly(:twice) { stubbed_validation_responses.shift.call }
      allow(AtpBusinessRulesValidationProxy).to receive(:reconnect!).and_return(true)
    end

    context "second attempt" do
      it "should reconnect the proxy" do
        result
        expect(AtpBusinessRulesValidationProxy).to have_received(:reconnect!)
      end

      context 'second attempt succeeds' do
        it "should return a success" do
          expect(result.success?).to be_truthy
        end
      end

      context "second attempt fails" do
        let(:stubbed_validation_responses) { [proc { raise StandardError }, proc { raise StandardError }] }

        it "should return a failure" do
          expect(result.failure).to eq(:validator_crashed)
        end
      end
    end
  end
end