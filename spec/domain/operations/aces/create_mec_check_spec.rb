# frozen_string_literal: true

require "rails_helper"

describe Aces::CreateMecCheck, "create mec check", dbclean: :after_each do
  before :all do
    DatabaseCleaner.clean
  end

  include Dry::Monads[:result, :do]

  let(:required_params) do
    {
      application_identifier: "app_id",
      family_identifier: "fam_id",
      applicant_responses: checks
    }
  end

  let(:checks) { { hbx_id: "Applicant Not Found" } }
  let(:results) { Aces::CreateMecCheck.new.call(required_params) }

  context 'valid parameters' do
    it 'should not raise error' do
      expect(results.success?).to be_truthy
    end
  end

  context 'invalid parameters' do
    it 'should not raise error' do
      expect(results.success?).to be_truthy
    end
  end

end
