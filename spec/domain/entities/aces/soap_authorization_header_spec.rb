# frozen_string_literal: true

require "rails_helper"

describe Aces::SoapAuthorizationHeader, "given:
  - a username
  - a password
  - a nonce
  - a created value
" do

  let(:nonce) { "SOME NONCE VALUE" }
  let(:username) { "SOME USERNAME" }
  let(:password) { "SOME PASSWORD" }
  let(:created) { "SOME CREATED VALUE" }

  subject do
    Aces::SoapAuthorizationHeader.new({
                                        username: username,
                                        password: password,
                                        created: created,
                                        nonce: nonce
                                      })
  end

  it "has the correct username" do
    expect(subject.username).to eq username
  end

end
