# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Eligibilities::PublishDetermination, dbclean: :after_each do
  before do
    MedicaidGatewayRegistry[:atleast_one_silver_plan_donot_cover_pediatric_dental_cost].feature.stub(:is_enabled).and_return(false)
  end

  let(:params) {File.read("spec/test_data/fully_determined_application.json")}

  context 'when connection is available' do
    it 'should publish the payload' do
      result = Eligibilities::PublishDetermination.new.call(JSON.parse(params), "aptc_eligible")
      expect(result.success?).to be true
    end
  end
end