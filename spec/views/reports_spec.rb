# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Reports", type: :view, dbclean: :after_each do
  before :all do
    DatabaseCleaner.clean
  end

  let(:user) { create(:user) }

  before :each do
    login_as(user)
  end

  describe "GET /reports/events" do
    before do
      create :transfer
      create :inbound_transfer
      create :mec_check
      create :application
    end

    it "generates Event Report"  do
      visit '/reports/events'
      expect(page).to have_content("Event Log")
    end

    it "shows the previous 24 hours without params" do
      create :transfer, created_at: 2.days.ago, updated_at: 2.days.ago, application_identifier: "100745"
      visit '/reports/events'

      expect(page).to_not have_content("100745")
    end

    it "accepts and uses date params" do
      old_transfer = create :transfer, created_at: 1.day.ago, updated_at: 1.day.ago
      start_on = 2.days.ago.strftime('%m/%d/%Y')
      visit "/reports/events?start_on=#{start_on}"

      expect(page).to have_content(old_transfer.application_identifier)
    end

    # TODO: test date input (Stimulus Reflex)
    # it "user input changes date range" do
    #   old_transfer = create :transfer, created_at: 1.day.ago, updated_at: 1.day.ago
    #   visit '/reports/events'
    #   expect(page).not_to have_content(old_transfer.application_identifier)
    #   start_on = 3.days.ago.strftime('%Y-%m-%d')
    #   fill_in "input#start_on", with: start_on
    #   expect(page).to have_content(old_transfer.application_identifier)
    # end
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
      expect(page).to have_content("Account Transfer")
    end

    it "shows the previous 24 hours without params" do
      create :transfer, created_at: 2.days.ago, updated_at: 2.days.ago, application_identifier: "100745"
      visit '/reports/account_transfers'

      expect(page).to_not have_content("100745")
    end

    it "accepts and uses date params" do
      old_transfer = create :transfer, created_at: 1.day.ago, updated_at: 1.day.ago
      start_on = 2.days.ago.strftime('%m/%d/%Y')
      visit "/reports/account_transfers?start_on=#{start_on}"

      expect(page).to have_content(old_transfer.application_identifier)
    end
  end

  describe "GET /reports/account_transfers_to_enroll" do
    before { create :inbound_transfer }

    it "generates transfer report"  do
      visit '/reports/account_transfers_to_enroll'
      expect(page).to have_content("Account Transfers To Enroll")
    end

    it "shows the previous 24 hours without params" do
      create :inbound_transfer, created_at: 2.days.ago, updated_at: 2.days.ago, application_identifier: "100745"
      visit '/reports/account_transfers_to_enroll'

      expect(page).to_not have_content("100745")
    end

    it "accepts and uses date params" do
      old_transfer = create :inbound_transfer, created_at: 1.day.ago, updated_at: 1.day.ago
      start_on = 2.days.ago.strftime('%m/%d/%Y')
      visit "/reports/account_transfers_to_enroll?start_on=#{start_on}"

      expect(page).to have_content(old_transfer.application_identifier)
    end
  end

  describe "GET /reports/mec_checks" do

    it "generates mec check report"  do
      visit '/reports/mec_checks'
      expect(page).to have_content("Mec Checks")
    end

    it "shows the previous 24 hours without params" do
      create :mec_check, created_at: 2.days.ago, updated_at: 2.days.ago, application_identifier: "100745"
      visit '/reports/account_transfers'

      expect(page).to_not have_content("100745")
    end

    it "accepts and uses date params" do
      old_mc = create :mec_check, created_at: 1.day.ago, updated_at: 1.day.ago
      start_on = 2.days.ago.strftime('%m/%d/%Y')
      visit "/reports/mec_checks?start_on=#{start_on}"

      expect(page).to have_content(old_mc.application_identifier)
    end

    it "displays failure if not nil" do
      create :mec_check, failure: 'Generate XML failure'
      visit "/reports/mec_checks"

      expect(page).to have_content('Generate XML failure')
    end
  end
end
