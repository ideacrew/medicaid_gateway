# frozen_string_literal: true

require "rails_helper"

describe Aces::EncodeAccountTransferRequest, "given an Aces::AccountTransferRequest" do
  let(:xml_ns) do
    {
      "wsse" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd",
      "wsu" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd",
      "soap" => "http://www.w3.org/2003/05/soap-envelope",
      "whatever" => "uri:whatever"
    }
  end

  let(:operation) { Aces::EncodeAccountTransferRequest.new }
  let(:header) do
    instance_double(
      Aces::SoapAuthorizationHeader,
      {
        :username => "A Username",
        :password => "A Password",
        :nonce => "A Nonce",
        :created => "A Created Value"
      }
    )
  end
  let(:request) do
    instance_double(
      Aces::AccountTransferRequest,
      {
        :header => header,
        :raw_body => "<wrapped_xml xmlns=\"uri:whatever\">SOME RAW BODY</wrapped_xml>"
      }
    )
  end
  let(:result) { operation.call(request) }

  it "is successful" do
    expect(result.success?).to be_truthy
  end

  it "encodes the username" do
    document = Nokogiri::XML(result.value!)
    expect(
      document.at_xpath(
        "//soap:Header/wsse:Security/wsse:UsernameToken/wsse:Username",
        xml_ns
      ).text
    ).to eq "A Username"
  end

  it "encodes the password" do
    document = Nokogiri::XML(result.value!)
    expect(
      document.at_xpath(
        "//soap:Header/wsse:Security/wsse:UsernameToken/wsse:Password",
        xml_ns
      ).text
    ).to eq "424sUL51NUqp97Jz5LX6bnuVMpY="
  end

  it "encodes the nonce" do
    document = Nokogiri::XML(result.value!)
    expect(
      document.at_xpath(
        "//soap:Header/wsse:Security/wsse:UsernameToken/wsse:Nonce",
        xml_ns
      ).text
    ).to eq "QSBOb25jZQ=="
  end

  it "encodes the created value" do
    document = Nokogiri::XML(result.value!)
    expect(
      document.at_xpath(
        "//soap:Header/wsse:Security/wsse:UsernameToken/wsu:Created",
        xml_ns
      ).text
    ).to eq "A Created Value"
  end

  it "encodes the body" do
    document = Nokogiri::XML(result.value!)
    expect(
      document.at_xpath(
        "//soap:Body/whatever:wrapped_xml",
        xml_ns
      ).text
    ).to eq "SOME RAW BODY"
  end
end