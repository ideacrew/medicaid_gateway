# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransferReport, dbclean: :after_each do
  before :all do
    DatabaseCleaner.clean
  end

  describe "#run" do
    context 'summary of all transfers' do
      before do
        create :transfer
        create :inbound_transfer
        create :inbound_transfer, failure: "Failed"
        create :transfer, failure: "Failed"
        Dir[Rails.root.join("transfer_report_*.csv")].each { |filename| FileUtils.rm_rf(filename) }
        create_date = DateTime.now.utc - 1.day
        create :transfer, created_at: create_date
        create :inbound_transfer, created_at: create_date
        create :inbound_transfer, failure: "Failed", created_at: create_date
        create :transfer, failure: "Failed", created_at: create_date
        TransferReport.run
        report_file = Dir[Rails.root.join("transfer_report_*.csv")].first
        @report_content = CSV.read(report_file, headers: true)
      end

      after(:all) do
        Dir[Rails.root.join("transfer_report_*.csv")].each { |filename| FileUtils.rm_rf(filename) }
      end

      it 'should create transfer_report' do
        csvs = Dir[Rails.root.join("transfer_report_*.csv")]
        expect(csvs.present?).to eq(true)
      end

      it 'should return proper values for header Sent' do
        expect(@report_content['Sent']).to eq ["2"]
      end

      it 'should return proper values for header Received' do
        expect(@report_content['Received']).to eq ["2"]
      end

      it 'should return proper values for header SentSuccesses' do
        expect(@report_content['SentSuccesses']).to eq ["1"]
      end

      it 'should return proper values for header SentFailures' do
        expect(@report_content['SentFailures']).to eq ["1"]
      end

      it 'should return proper values for header ReceivedSuccesses' do
        expect(@report_content['ReceivedSuccesses']).to eq ["1"]
      end

      it 'should return proper values for header ReceivedFailures' do
        expect(@report_content['ReceivedFailures']).to eq ["1"]
      end
    end
  end
end
