# frozen_string_literal: true

require "rails_helper"

describe Transfers::ExecuteBusinessXmlValidations, dbclean: :after_each do

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
    let(:payload) { double }
    let(:failure_result) { Failure(:validator_crashed) }
    let(:result) { subject.call(payload) }

    before do
      allow(AtpBusinessRulesValidationProxy).to receive(:run_validation).with(payload).and_raise("Validator Crashed")
    end

    context "second attempt" do
      it "should reconnect the proxy" do
        result
        # expect(AtpBusinessRulesValidationProxy).to receive(:reconnect!)
      end

      context "second attempt fails" do
        it "should return a failure" do
          expect(result.failure).to eq(:validator_crashed)
        end
      end
    end
  end
end