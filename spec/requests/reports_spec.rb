# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Reports", type: :request, dbclean: :after_each do
  before :all do
    DatabaseCleaner.clean
  end

  let(:user) { create(:user) }

  before :each do
    login_as(user)
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

      report_ids = JSON.parse(response.body).map { |app| app["_id"] }
      expect(report_ids).to_not include(old_application.id)
    end

    it "accepts and uses date params" do
      old_application = create :application, created_at: 1.day.ago, updated_at: 1.day.ago
      get '/reports/medicaid_applications', params: { start_on: 2.days.ago.strftime('%m/%d/%Y') }

      report_ids = JSON.parse(response.body).map { |app| app["_id"] }
      expect(report_ids).to include(old_application.id)
    end
  end
end
