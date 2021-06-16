# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Eligibilities::PublishDetermination, dbclean: :after_each do
  let(:params) {File.read("spec/test_data/fully_determined_application.json")}

  context 'when connection is available' do
    it 'should publish the payload' do
      result = Eligibilities::PublishDetermination.new.call(params, "aptc_eligible")
      expect(result.success?).to be true
    end
  end
end