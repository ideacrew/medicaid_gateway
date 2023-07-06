# frozen_string_literal: true

require "rails_helper"
require "aca_entities/serializers/xml/medicaid/atp"
require "aca_entities/atp/transformers/cv/family"

describe Transfers::ToEnroll, "given a soap envelope with an valid xml payload, transfer it to Enroll" do

  let(:transfer_id) { "tr123" }
  let(:body) { File.read("./spec/test_data/Simple_Test_Case_L_New.xml") }
  let(:process) { described_class.new }
  let(:inbound_transfer) {create :inbound_transfer, external_id: transfer_id}

  context 'success' do
    before :each do
      @result = process.call(body, inbound_transfer.id)
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

  let(:operation) { Transfers::ToEnroll.new }
  let(:payload) {operation.send(:create_transfer, body).success}
  let(:transformed_params) {operation.send(:transform_params, payload, inbound_transfer.id).success}
  let(:updated_transformed_params) {operation.send(:update_inferred_defaults, transformed_params).success}

  context 'inferred post partum period' do
    before do
      allow(MedicaidGatewayRegistry).to receive(:feature_enabled?).with(:infer_post_partum_period).and_return(true)
    end

    context 'transformed params with nil post partum' do
      it 'should update to false' do
        not_pregnant_applicant = updated_transformed_params[:family][:magi_medicaid_applications][0][:applicants].first
        expect(not_pregnant_applicant[:pregnancy_information][:is_post_partum_period]).to eq(false)
      end
    end
  end
end
