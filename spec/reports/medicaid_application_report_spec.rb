# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MedicaidApplicationReport, dbclean: :after_each do
  context "#run" do
    let(:fake_application) do
      application = Medicaid::Application.new(application_identifier: '1234',
                                              medicaid_request_payload: { test: 'test' },
                                              medicaid_response_payload: { test: 'test' })
      application.save!
    end

    before do
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
