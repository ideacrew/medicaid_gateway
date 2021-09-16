# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Reports", type: :request, dbclean: :after_each do
  before :all do
    DatabaseCleaner.clean
  end
  describe "GET /reports/medicaid_applications" do
    before { create :application }

    it "generates medicaid application report"  do
      get '/reports/medicaid_applications'
      expect(JSON.parse(response.body).count).to eq(1)
    end

    it "shows the previous 24 hours without params" do
      old_application = create :application, created_at: 1.day.ago, updated_at: 1.day.ago
      get '/reports/medicaid_applications'

      report_ids = JSON.parse(response.body).map { |app| app["_id"]["$oid"] }
      expect(report_ids).to_not include(old_application.id)
    end

    it "accepts and uses date params" do
      old_application = create :application, created_at: 1.day.ago, updated_at: 1.day.ago
      get '/reports/medicaid_applications', params: { start_on: 2.days.ago.strftime('%m/%d/%Y') }

      report_ids = JSON.parse(response.body).map { |app| app["_id"]["$oid"] }
      expect(report_ids).to include(old_application.id)
    end
  end

  describe "GET /reports/medicaid_application_check" do
    before { create :application }

    it "generates transfer report"  do
      visit '/reports/medicaid_application_check'
      expect(page).to have_content("Application Identifer")
    end

    it "shows the previous 24 hours without params"  do
      old_application = create :application, created_at: 1.day.ago, updated_at: 1.day.ago
      visit '/reports/medicaid_application_check'
      expect(page).to_not have_content(old_application.application_identifier)
    end

    it "accepts and uses date params"  do
      old_application = create :application, created_at: 1.day.ago, updated_at: 1.day.ago
      start_on = 2.days.ago.strftime('%m/%d/%Y')
      visit "/reports/medicaid_application_check?start_on=#{start_on}"
      expect(page).to have_content(old_application.application_identifier)
    end

  end

  describe "GET /reports/account_transfers" do
    before { create :transfer }

    it "generates transfer report"  do
      visit '/reports/account_transfers'
      expect(page).to have_content("Service")
    end

    it "shows the previous 24 hours without params" do
      old_transfer = create :transfer, created_at: 1.day.ago, updated_at: 1.day.ago
      visit '/reports/account_transfers'

      expect(page).to_not have_content(old_transfer.application_identifier)
    end

    it "accepts and uses date params" do
      old_transfer = create :transfer, created_at: 1.day.ago, updated_at: 1.day.ago
      start_on = 2.days.ago.strftime('%m/%d/%Y')
      visit "/reports/account_transfers?start_on=#{start_on}"

      expect(page).to have_content(old_transfer.application_identifier)
    end
  end
end
