# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReportsController,
               "attempting to log in an expired user, even with correct permissions",
               type: :controller, dbclean: :after_each do
  let(:user) do
    user_record = FactoryBot.create(:user, :with_hbx_staff_role)
    user_record.last_activity_at = Time.now - 180.days
    user_record.save!
    user_record
  end

  before :each do
    sign_in user
  end

  it "can't access the endpoint" do
    get :medicaid_application_check
    expect(response).to redirect_to("http://test.host/users/sign_in")
  end
end