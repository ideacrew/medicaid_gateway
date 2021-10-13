# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MedicaidApplicationReport, dbclean: :after_each do
  before :all do
    DatabaseCleaner.clean
  end

  describe "#run" do
    context 'application with aptc households' do
      let!(:application) { FactoryBot.create(:application, :with_aptc_households) }

      before do
        Dir[Rails.root.join("medicaid_application_report_*.csv")].each { |filename| FileUtils.rm_rf(filename) }
        MedicaidApplicationReport.run
        report_file = Dir[Rails.root.join("medicaid_application_report_*.csv")].last
        @report_content = CSV.read(report_file, headers: true)
      end

      it 'should create medicaid_application_report' do
        csvs = Dir[Rails.root.join("medicaid_application_report_*.csv")]
        expect(csvs.present?).to eq(true)
      end

      it 'should return proper values for header ApplicationIdentifer' do
        expect(@report_content['ApplicationIdentifer']).to include(application.application_identifier)
      end

      it 'should return proper values for header MedicaidRequestPayload' do
        expect(@report_content['MedicaidRequestPayload']).to include(application.medicaid_request_payload)
      end

      it 'should return proper values for header MedicaidResponsePayload' do
        expect(@report_content['MedicaidResponsePayload']).to include(application.medicaid_response_payload)
      end

      it 'should return proper values for header ApplicationRequestPayload' do
        expect(@report_content['ApplicationRequestPayload']).to include(application.application_request_payload)
      end

      it 'should return proper values for header ApplicationResponsePayload' do
        expect(@report_content['ApplicationResponsePayload']).to include(application.application_response_payload)
      end

      it 'should return contents for header OtherComputedFactors' do
        expect(@report_content['OtherComputedFactors']).not_to be_empty
      end
    end

    context 'application without aptc households' do
      let!(:application_no_aptc) { FactoryBot.create(:application) }

      before do
        Dir[Rails.root.join("medicaid_application_report_*.csv")].each { |filename| FileUtils.rm_rf(filename) }
        MedicaidApplicationReport.run
        report_file = Dir[Rails.root.join("medicaid_application_report_*.csv")].last
        @report_content = CSV.read(report_file, headers: true)
      end

      it 'should create medicaid_application_report' do
        csvs = Dir[Rails.root.join("medicaid_application_report_*.csv")]
        expect(csvs.present?).to eq(true)
      end

      it 'should return proper values for header ApplicationIdentifer' do
        expect(@report_content['ApplicationIdentifer']).to include(application_no_aptc.application_identifier)
      end

      it 'should return proper values for header MedicaidRequestPayload' do
        expect(@report_content['MedicaidRequestPayload']).to include(application_no_aptc.medicaid_request_payload)
      end

      it 'should return proper values for header MedicaidResponsePayload' do
        expect(@report_content['MedicaidResponsePayload']).to include(application_no_aptc.medicaid_response_payload)
      end

      it 'should return proper values for header ApplicationRequestPayload' do
        expect(@report_content['ApplicationRequestPayload']).to include(application_no_aptc.application_request_payload)
      end

      it 'should return proper values for header ApplicationResponsePayload' do
        expect(@report_content['ApplicationResponsePayload']).to include(application_no_aptc.application_response_payload)
      end

      it 'should return contents for header OtherComputedFactors' do
        expect(@report_content['OtherComputedFactors']).to include('No other factors')
      end
    end
  end
  after(:all) { Dir[Rails.root.join("medicaid_application_report_*.csv")].each { |filename| FileUtils.rm_rf(filename) } }
end
