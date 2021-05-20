# frozen_string_literal: true

require "rails_helper"

describe Aces::ExecuteBusinessXmlValidations, "given an empty payload" do
  let(:payload) { "" }

  let(:subject) do
    Aces::ExecuteBusinessXmlValidations.new
  end
  it "crashes" do
    result = subject.call(payload)
    expect(result.success?).not_to be_truthy
  end
end

describe Aces::ExecuteBusinessXmlValidations, "given a payload with an empty body" do
  let(:payload) do
    <<-XMLCODE
    <ns8:AccountTransferRequest ns4:atVersionText="2.3" xmlns:ns2="http://hix.cms.gov/0.1/hix-core" xmlns:ns4="http://at.dsh.cms.gov/extension/1.0" xmlns:ns5="http://hix.cms.gov/0.1/hix-ee" xmlns:ns6="http://niem.gov/niem/domains/screening/2.1" xmlns:ns7="http://hix.cms.gov/0.1/hix-pm" xmlns:ns8="http://at.dsh.cms.gov/exchange/1.0">
    </ns8:AccountTransferRequest>
    XMLCODE
  end

  let(:subject) do
    Aces::ExecuteBusinessXmlValidations.new
  end

  it "fails" do
    result = subject.call(payload)
    expect(result.success?).not_to be_truthy
  end

  it "returns the errors" do
    result = subject.call(payload)
    failure_object = result.failure
    expect(failure_object.kind_of?(Aces::AtpBusinessRuleFailure)).to be_truthy
  end
end