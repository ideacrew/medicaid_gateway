# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransferReceivedReport, dbclean: :after_each do
  before :all do
    DatabaseCleaner.clean
  end

  describe "#run" do
    context 'transfers sent from enroll' do
      let!(:transfer) do
        create_date = DateTime.now.utc - 1.day
        create :inbound_transfer, created_at: create_date
      end

      before do
        Dir[Rails.root.join("transfer_received_report_*.csv")].each { |filename| FileUtils.rm_rf(filename) }
        TransferReceivedReport.run
        report_file = Dir[Rails.root.join("transfer_received_report_*.csv")].first
        @report_content = CSV.read(report_file, headers: true)
      end

      after(:all) do
        Dir[Rails.root.join("transfer_report_*.csv")].each { |filename| FileUtils.rm_rf(filename) }
      end

      it 'should create transfer_sent_report' do
        csvs = Dir[Rails.root.join("transfer_received_report_*.csv")]
        expect(csvs.present?).to eq(true)
      end

      it 'should return proper values for header ApplicationHBXId' do
        expect(@report_content['ApplicationHBXId']).to include(transfer.application_identifier)
      end

      it 'should return proper values for header FamilyHBXId' do
        expect(@report_content['FamilyHBXId']).to include(transfer.family_identifier)
      end

      it 'should return proper values for TransferStatus' do
        expect(@report_content['TransferStatus']).to include(transfer.successful?.to_s)
      end

      it 'should return proper values for header IngestionStatus' do
        expect(@report_content['IngestionStatus']).to include(transfer.result)
      end
    end
  end
end
