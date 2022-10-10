# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Eligibilities::DetermineEventAndPublishFullDetermination, dbclean: :after_each do
  subject { described_class.new.call(mm_application) }

  let(:mm_application) { OpenStruct.new(tax_households: [OpenStruct.new(tax_household_members: thh_members)]) }
  let(:thh_members) { [OpenStruct.new(product_eligibility_determination: product_eligibility_determination)] }

  describe '#call' do
    context 'member is Insurance Assistance Eligible' do
      let(:product_eligibility_determination) do
        OpenStruct.new(is_ia_eligible: true,
                       is_medicaid_chip_eligible: false,
                       is_totally_ineligible: false,
                       is_magi_medicaid: false,
                       is_uqhp_eligible: false)
      end

      it 'should publish and return event_name' do
        expect(subject.success[:event]).to eq(:aptc_eligible)
      end
    end

    context 'member is Medicaid Chip Eligible' do
      let(:product_eligibility_determination) do
        OpenStruct.new(is_ia_eligible: false,
                       is_medicaid_chip_eligible: true,
                       is_totally_ineligible: false,
                       is_magi_medicaid: false,
                       is_uqhp_eligible: false)
      end

      it 'should publish and return event_name' do
        expect(subject.success[:event]).to eq(:medicaid_chip_eligible)
      end
    end

    context 'member is Totally Ineligible' do
      let(:product_eligibility_determination) do
        OpenStruct.new(is_ia_eligible: false,
                       is_medicaid_chip_eligible: false,
                       is_totally_ineligible: true,
                       is_magi_medicaid: false,
                       is_uqhp_eligible: false)
      end

      it 'should publish and return event_name' do
        expect(subject.success[:event]).to eq(:totally_ineligible)
      end
    end

    context 'member is Magi Medicaid Eligible' do
      let(:product_eligibility_determination) do
        OpenStruct.new(is_ia_eligible: false,
                       is_medicaid_chip_eligible: false,
                       is_totally_ineligible: false,
                       is_magi_medicaid: true,
                       is_uqhp_eligible: false)
      end

      it 'should publish and return event_name' do
        expect(subject.success[:event]).to eq(:magi_medicaid_eligible)
      end
    end

    context 'member is UQHP Eligible' do
      let(:product_eligibility_determination) do
        OpenStruct.new(is_ia_eligible: false,
                       is_medicaid_chip_eligible: false,
                       is_totally_ineligible: false,
                       is_magi_medicaid: false,
                       is_uqhp_eligible: true)
      end

      it 'should publish and return event_name' do
        expect(subject.success[:event]).to eq(:uqhp_eligible)
      end
    end

    context 'members are determined different' do
      let(:thh_members) { [thh_member1, thh_member2] }
      let(:thh_member1) { OpenStruct.new(product_eligibility_determination: product_eligibility_determination1) }
      let(:thh_member2) { OpenStruct.new(product_eligibility_determination: product_eligibility_determination2) }

      let(:product_eligibility_determination1) do
        OpenStruct.new(is_ia_eligible: false,
                       is_medicaid_chip_eligible: false,
                       is_totally_ineligible: false,
                       is_magi_medicaid: false,
                       is_uqhp_eligible: true)
      end

      let(:product_eligibility_determination2) do
        OpenStruct.new(is_ia_eligible: true,
                       is_medicaid_chip_eligible: false,
                       is_totally_ineligible: false,
                       is_magi_medicaid: false,
                       is_uqhp_eligible: false)
      end

      it 'should publish and return event_name' do
        expect(subject.success[:event]).to eq(:mixed_determination)
      end
    end
  end
end
