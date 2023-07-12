# frozen_string_literal: true

require "rails_helper"
require 'aca_entities/serializers/xml/medicaid/atp'
require 'aca_entities/atp/transformers/cv/family'

describe Transfers::ToEnrollBatch, "given a soap envelope with an valid xml payload, transfer it to Enroll" do
  include Dry::Monads[:result, :do]

  let(:transfer_id) { "tr123" }
  let(:p1) { File.read("./spec/test_data/xmls/MET00000000002007409_larry.xml") }
  let(:p2) { File.read("./spec/test_data/xmls/MET00000000002007409_larry_suzie.xml") }
  let(:p3) { File.read("./spec/test_data/xmls/MET00000000002007409_larry_cheryl.xml") }
  let!(:transfer1) { FactoryBot.create(:inbound_transfer, external_id: transfer_id, payload: p1, to_enroll: true, result: "Waiting to Transfer")}
  let(:process) { described_class.new }

  context 'no matching transfers' do
    before :each do
      @result = process.call("randomstring")
    end

    it 'should return success message' do
      expect(@result.failure).to eq("no transfers found")
    end
  end

  context 'single matching payload' do
    before :each do
      allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:infer_post_partum_period).and_return(true)
      transfer1.external_id
      @result = process.call(transfer_id)
      @transfers = @result.value![0]
      @payload = @result.value![1]
      @applicants = @payload[:family][:magi_medicaid_applications].first[:applicants] || []
    end

    context 'with a single valid application' do
      it 'should return success message' do
        expect(@result).to be_success
      end

      it 'should return a single transfer' do
        expect(@transfers.count).to eq 1
      end

      it 'should should each have one applicant' do
        expect(@applicants.count).to eq 1
      end

      it "should update the post partum period to false" do
        expect(@applicants.first[:pregnancy_information][:is_post_partum_period]).to eq(false)
      end
    end
  end

  context 'multiple matching payload' do
    before :each do
      allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:infer_post_partum_period).and_return(true)
      create :inbound_transfer, external_id: transfer_id, payload: p2, to_enroll: true, result: "Waiting to Transfer"
      create :inbound_transfer, external_id: transfer_id, payload: p3, to_enroll: true, result: "Waiting to Transfer"
      @result = process.call(transfer_id)
      @transfers = @result.value![0]
      @payload = @result.value![1]
      @applicants = @payload[:family][:magi_medicaid_applications].first[:applicants] || []
    end

    context 'with a single valid application' do
      it 'should return success message' do
        expect(@result).to be_success
      end

      it 'should return multiple transfers' do
        expect(@transfers.count).to eq 3
      end

      it 'should should each multiple applicants' do
        expect(@applicants.count).to eq 3
      end

      it "should update the post partum period to false for all applicants with false pregnancy indicator" do
        expect(@applicants.first[:pregnancy_information][:is_post_partum_period]).to eq(false)
        expect(@applicants.second[:pregnancy_information][:is_post_partum_period]).to eq(false)
      end
    end
  end

end