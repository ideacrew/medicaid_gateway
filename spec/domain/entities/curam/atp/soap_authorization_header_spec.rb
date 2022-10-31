# frozen_string_literal: true

require "rails_helper"

describe Curam::Atp::SoapAuthorizationHeader, "given:
  - a username
  - a password
  - a created value
" do

  let(:username) { "SOME USERNAME" }
  let(:password) { "SOME PASSWORD" }
  let(:created) { "SOME CREATED VALUE" }

  subject do
    Curam::Atp::SoapAuthorizationHeader.new({
                                              username: username,
                                              password: password,
                                              created: created
                                            })
  end

  it "has the correct username" do
    expect(subject.username).to eq username
  end

end
