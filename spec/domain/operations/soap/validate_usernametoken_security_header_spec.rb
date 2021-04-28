# frozen_string_literal: true

require "rails_helper"

describe Soap::ValidateUsernametokenSecurityHeader, "given a soap envelope" do
  let(:document) { Nokogiri::XML(raw_xml) }
  let(:raw_xml) do
    <<-XMLCODE
    <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:ns="http://at.dsh.cms.gov/exchange/1.0" xmlns:ns1="http://niem.gov/niem/structures/2.0" xmlns:ns2="http://at.dsh.cms.gov/extension/1.0" xmlns:ns3="http://niem.gov/niem/niem-core/2.0" xmlns:hix="http://hix.cms.gov/0.1/hix-core" xmlns:hix1="http://hix.cms.gov/0.1/hix-ee" xmlns:ns4="http://niem.gov/niem/domains/screening/2.1" xmlns:hix2="http://hix.cms.gov/0.1/hix-pm">
    <soap:Header>
       <wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
          <wsse:UsernameToken wsu:Id="UsernameToken-73590BD4745C9F3F7814189343300461">
             <wsse:Username>SOME_SOAP_USER</wsse:Username>
             <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">N2UXDZfzqDS67pauESB40IhFt+Y=</wsse:Password>
             <wsse:Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">aaa</wsse:Nonce>
             <wsu:Created>2014-12-18T20:25:30.037Z</wsu:Created>
          </wsse:UsernameToken>
       </wsse:Security>
    </soap:Header>
    </soap:Envelope>
    XMLCODE
  end

  let(:operation) { Soap::ValidateUsernametokenSecurityHeader.new }
  let(:result) { operation.call(document) }

  let(:feature_ns) { double }
  let(:username_setting) { double(item: "SOME_SOAP_USER") }
  let(:password_setting) { double(item: "SOME SOAP PASSWORD") }

  before :each do
    allow(MedicaidGatewayRegistry).to receive(:[]).with(:aces_connection).and_return(feature_ns)
    allow(feature_ns).to receive(:setting).with(:aces_atp_caller_username).and_return(username_setting)
    allow(feature_ns).to receive(:setting).with(:aces_atp_caller_password).and_return(password_setting)
  end

  it "is successful" do
    expect(result.success?).to be_truthy
  end
end