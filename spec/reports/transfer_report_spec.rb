# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransferReport, dbclean: :after_each do
  before :all do
    DatabaseCleaner.clean
    Dir[Rails.root.join("transfer_report_*.csv")].each { |filename| FileUtils.rm_rf(filename) }
  end

  describe "#run" do
    context 'transfers from enroll' do
      let!(:transfer) { FactoryBot.create(:transfer) }

      before do
        TransferReport.run
        report_file = Dir[Rails.root.join("transfer_report_*.csv")].first
        @report_content = CSV.read(report_file, headers: true)
      end

      it 'should create medicaid_application_report' do
        csvs = Dir[Rails.root.join("transfer_report_*.csv")]
        expect(csvs.present?).to eq(true)
      end

      it 'should return proper values for header ApplicationIdentifer' do
        expect(@report_content['ApplicationIdentifer']).to include(transfer.application_identifier)
      end

      it 'should return proper values for header FamilyIdentifier' do
        expect(@report_content['FamilyIdentifier']).to include(transfer.family_identifier)
      end

      it 'should return proper values for header Service' do
        expect(@report_content['Service']).to include(transfer.service)
      end

      it 'should return proper values for header ResponsePayload' do
        expect(@report_content['ResponsePayload']).to include(transfer.response_payload)
      end
    end
  end
end
