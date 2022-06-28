# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/eligibilities/magi_medicaid_application_data')

RSpec.describe "Daiy Determinations Report", type: :view, dbclean: :after_each do
  include_context 'setup magi_medicaid application with two applicants'
  before :all do
    DatabaseCleaner.clean
  end

  let(:user) { create(:user, :with_hbx_staff_role) }
  let(:application) { FactoryBot.create(:application)}
  before :each do
    login_as(user)
  end

  describe "GET /reports/daily_iap_determinations" do
    before do
      application.update(application_response_payload: JSON.generate(magi_medicaid_application))
    end

    context 'with is_uqhp_eligible field set to nil' do
      it "should display false " do
        visit '/reports/daily_iap_determinations'
        expect(all('td')[3].text).to eq("false")
      end
    end

    context 'with is_totally_ineligible field set to nil' do
      before do
        applicant_determination = magi_medicaid_application[:tax_households].first[:tax_household_members].first[:product_eligibility_determination]
        applicant_determination[:is_totally_ineligible] = nil
        application.update(application_response_payload: JSON.generate(magi_medicaid_application))
      end

      it "should display false for 'Is Totally Ineligible' when field is nil"  do
        visit '/reports/daily_iap_determinations'
        expect(all('td')[9].text).to eq("false")
      end
    end
  end
end
