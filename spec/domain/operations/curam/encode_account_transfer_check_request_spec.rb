# frozen_string_literal: true

require "rails_helper"

describe Curam::EncodeAccountTransferCheckRequest, "given a Curam::AccountTransferCheckRequest" do
  let(:xml_ns) do
    {
      "wsse" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd",
      "wsu" => "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd",
      "soapenv" => "http://schemas.xmlsoap.org/soap/envelope/",
      "v1" => "http://xmlns.dhs.dc.gov/dcas/esb/acctransappstatuccheck/V1"
    }
  end

  let(:operation) { Curam::EncodeAccountTransferCheckRequest.new }
  let(:header) do
    instance_double(
      Curam::SoapAuthorizationHeader,
      {
        :username => "A Username",
        :password => "A Password",
        :created => "A Created Value"
      }
    )
  end
  let(:request) do
    instance_double(
      Curam::TransferCheck,
      {
        :header => header,
        :global_application_id => "SBM123",
        :last_written => "2021-01-01"
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
        "//soapenv:Header/wsse:Security/wsse:UsernameToken/wsse:Username",
        xml_ns
      ).text
    ).to eq "A Username"
  end

  it "encodes the password literally" do
    document = Nokogiri::XML(result.value!)
    expect(
      document.at_xpath(
        "//soapenv:Header/wsse:Security/wsse:UsernameToken/wsse:Password",
        xml_ns
      ).text
    ).to eq "A Password"
  end

  it "encodes the created value" do
    document = Nokogiri::XML(result.value!)
    expect(
      document.at_xpath(
        "//soapenv:Header/wsse:Security/wsse:UsernameToken/wsu:Created",
        xml_ns
      ).text
    ).to eq "A Created Value"
  end

  it "encodes the body" do
    document = Nokogiri::XML(result.value!)
    expect(
      document.at_xpath(
        "//soapenv:Body/v1:AccTransStatusByIdReq/v1:GLOBALAPPLICATIONID",
        xml_ns
      ).text
    ).to eq "SBM123"
    expect(
        document.at_xpath(
          "//soapenv:Body/v1:AccTransStatusByIdReq/v1:LASTWRITTEN",
          xml_ns
        ).text
      ).to eq "2021-01-01"
  end
end