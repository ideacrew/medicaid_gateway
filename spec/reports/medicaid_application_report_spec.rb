# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MedicaidApplicationReport, dbclean: :after_each do
  context "#run" do
    let(:fake_application) do
      double(
        application_identifier: 1,
        medicaid_request_payload: 1,
        medicaid_response_payload: 1
      )
    end
    before do
      allow(Medicaid::Application).to receive(:where).with(
        created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
      ).and_return([fake_application])
      MedicaidApplicationReport.run
    end
    it "should return a CSV output with proper attributes" do
      csvs = Dir[Rails.root.join("medicaid_application_report_*.csv")]
      expect(csvs.present?).to eq(true)
      csvs.each do |filename|
        FileUtils.rm_rf(filename)
      end
    end
  end
end
