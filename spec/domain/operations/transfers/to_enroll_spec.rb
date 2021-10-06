# frozen_string_literal: true

require "rails_helper"
require 'aca_entities/serializers/xml/medicaid/atp'
require 'aca_entities/atp/transformers/cv/family'

describe Transfers::ToEnroll, "given a soap envelope with an valid xml payload, transfer it to Enroll" do

  let(:transfer_id) { "tr123" }
  let(:body) { File.read("./spec/test_data/Simple_Test_Case_L_New.xml") }
  let(:process) { described_class.new }

  context 'success' do
    before :each do
      @inbound_transfer = create :inbound_transfer, external_id: transfer_id
      @result = process.call(body, @inbound_transfer.id)
    end

    context 'with valid application' do
      it 'should return success message' do
        expect(@result).to be_success
      end

      it 'should return success with message' do
        expect(@result.success).to eq("Transferred account to Enroll")
      end
    end
  end
end