# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Eligibilities::DetermineEventAndPublishFullDetermination, dbclean: :after_each do
  let(:mm_application) do
    OpenStruct.new(tax_households: [
                     OpenStruct.new(tax_household_members: [
                                      OpenStruct.new(product_eligibility_determination:
                                        OpenStruct.new(is_ia_eligible: true, is_medicaid_chip_eligible: false,
                                                       is_totally_ineligible: false, is_magi_medicaid: false, is_uqhp_eligible: false))
                                    ])
                   ])
  end

  context 'when connection is available' do
    it 'should publish the payload' do
      expect(subject.call(mm_application).success?).to be true
    end
  end
end
