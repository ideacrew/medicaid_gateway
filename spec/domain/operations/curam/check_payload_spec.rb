# frozen_string_literal: true

require "rails_helper"

describe Curam::CheckPayload, "given a valid account transfer check request" do
  let(:operation) { Curam::CheckPayload.new }
  let(:transfer) do
    Aces::Transfer.new(
      {
        :application_identifier => "SBM123",
        :created_at => "2021-01-01"
      }
    )
  end

  before :each do
    allow(operation).to receive(:find_transfer).with(:id).and_return(transfer)
  end

  it "should update the transfer callback status" do
    expect { operation.call(:id) }.to change(transfer, :callback_status)
  end
end
