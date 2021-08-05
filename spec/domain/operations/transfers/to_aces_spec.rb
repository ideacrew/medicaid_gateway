# frozen_string_literal: true

require "rails_helper"
require 'aca_entities/serializers/xml/medicaid/atp'
require 'aca_entities/medicaid/atp'
require 'aca_entities/atp/operations/aces/generate_xml.rb'

describe Transfers::ToAces, "given an ATP valid payload, transfer it to Aces" do
  include Dry::Monads[:result, :do]

  let(:atp_hash) {File.read("./spec/test_data/application_and_family.json")}

  let(:transfer) {described_class.new}

  context 'success' do
    context 'with valid application' do
      before do
        @result = transfer.call(atp_hash, "curam")
      end

      it 'should return success with message' do
        expect(@result).to eq('Successfully transferred in account')
      end
    end
  end

end