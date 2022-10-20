# frozen_string_literal: true

require 'rails_helper'
require "#{Rails.root}/spec/shared_contexts/eligibilities/cms/me_simple_scenarios/test_case_d.rb"

RSpec.describe ProcessSubscriberResponses::SlcspDetermined, dbclean: :after_each do
  include_context 'cms ME simple_scenarios test_case_d'

  subject { described_class.new.call(input_params) }

  describe '#call' do
    context 'invalid input params' do
      let(:input_params) { {} }

      it 'should return failure' do
        expect(subject.failure.errors.to_h.keys).to eq(
          [:family_reference, :assistance_year, :aptc_effective_date, :applicants, :us_state, :hbx_id, :oe_start_on, :notice_options]
        )
      end
    end

    context 'without any persisted Application' do
      let(:input_params) { app_params }

      it 'should return failure' do
        expect(subject.failure).to eq('Unable to find Medicaid Application with given identifier: 200000126')
      end
    end

    context 'with valid data' do
      let(:issuer_profile_reference) do
        { hbx_id: '1234', fein: '123333333', hbx_carrier_id: '333333',
          name: 'Delta Dental', abbrev: 'DDPA' }
      end

      let(:health_product_reference) do
        { hios_id: '92479DC0020002', name: 'Access PPO', active_year: 2020, is_dental_only: false,
          metal_level: 'silver', product_kind: 'health', benefit_market_kind: 'aca_individual',
          ehb_percent: '0.0', issuer_profile_reference: issuer_profile_reference,
          covers_pediatric_dental_costs: true, rating_method: 'Age-Based Rates', pediatric_dental_ehb: nil }
      end

      let(:applicant_reference) { { first_name: 'Gerald', last_name: 'Rivers', dob: Date.today, person_hbx_id: '95' } }

      let(:member1_reference)  { { applicant_reference: applicant_reference, relationship_with_primary: 'self', age_on_effective_date: 20 } }

      let(:benchmark_product) do
        { effective_date: app_params[:aptc_effective_date],
          primary_rating_address: { has_fixed_address: true, kind: 'home', address_1: 'test',
                                    city: 'Dummy', county: 'Test County', county_code: 'TC', state: 'ME', zip: '40001',
                                    country_name: 'USA', validation_status: 'ValidMatch', start_on: Date.today },
          exchange_provided_code: 'ME001',
          household_group_ehb_premium: 190.98,
          households: [
            { household_hbx_id: '12345', type_of_household: 'adult_and_child', household_ehb_premium: 190.98,
              household_health_ehb_premium: 190.98, health_product_reference: health_product_reference, members: [member1_reference] }
          ] }
      end
      let!(:application) { FactoryBot.create(:application, :with_aptc_households, application_identifier: '200000126') }

      let(:input_params) { app_params.merge(benchmark_product: benchmark_product) }

      before do
        aptc_hh = application.aptc_households.first
        aptc_hh.update_attributes!(tax_household_identifier: '12345')
      end

      context 'regular application' do
        it 'should return success' do
          expect(subject.success?).to be_truthy
        end
      end

      context 'renewal application' do
        it 'should return success' do
          application.update_attributes!(is_renewal: true)
          expect(subject.success?).to be_truthy
        end
      end
    end
  end
end
