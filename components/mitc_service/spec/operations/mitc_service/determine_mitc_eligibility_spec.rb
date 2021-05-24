# frozen_string_literal: true

require 'rails_helper'

require "#{Rails.root}/spec/shared_contexts/eligibilities/magi_medicaid_application_data.rb"

RSpec.describe ::MitcService::DetermineMitcEligibility do
  include_context 'setup magi_medicaid application with two applicants'

  let(:mm_entity_application) do
    ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(magi_medicaid_application).success
  end

  before do
    allow(HTTParty).to receive(:post).and_return(mitc_response)
  end

  context 'with valid input and valid response' do
    before do
      @result = subject.call(mm_entity_application)
      @result_application = @result.success
    end

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should add all the MitC Determinations to the MagiMedicaidApplication' do
      @result_application.tax_households.each do |result_thh|
        result_thh.tax_household_members.each do |result_thhm|
          ped = result_thhm.product_eligibility_determination
          expect(ped.magi_medicaid_category).not_to be_nil
          expect(ped.medicaid_chip_category).not_to be_nil
          expect(ped.category_determinations).not_to be_empty
        end
      end
    end
  end

  context 'invalid MagiMedicaidApplication' do
    before { @result = subject.call('magi_medicaid_application') }

    it 'should return failure' do
      expect(@result).to be_failure
    end

    it 'should return failure with message' do
      err = 'Invalid Application, given value is not a ::AcaEntities::MagiMedicaid::Application, input_value: magi_medicaid_application'
      expect(@result.failure).to eq(err)
    end
  end
end
