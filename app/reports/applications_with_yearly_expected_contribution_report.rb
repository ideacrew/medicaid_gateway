# frozen_string_literal: true

# This script generates a CSV report with information about Applications with YearlyExpectedContribution
# rails runner app/reports/applications_with_yearly_expected_contribution_report.rb -e production

field_names = %w[ApplicationHbxID AptcHouseholdsWithYearlyExpectedContribution]
file_name = "#{Rails.root}/applications_with_yearly_expected_contributions_for_aptc_households.csv"
source_file = "#{Rails.root}/list_of_latest_determined_2022_applications_per_family.csv"

unless File.exist?(source_file)
  puts "Cannot find file: #{source_file}"
  return
end

CSV.open(file_name, 'w', force_quotes: true) do |csv|
  csv << field_names

  CSV.foreach(source_file, headers: true) do |row|
    application = Medicaid::Application.where(application_identifier: row['ApplicationHbxID']).first
    next row if application.blank?

    thhs_information = JSON.parse(row['TaxHouseholdsInformation'])
    thh_hbx_assigned_id_with_expected_contribution = thhs_information.inject({}) do |thhs_hash, thhs_info|
      thh_hbx_assigned_id, person_hbx_ids = thhs_info
      aptc_household = application.aptc_households.detect do |aptc_hh|
        (aptc_hh.aptc_household_members.map(&:member_identifier) & person_hbx_ids).present?
      end

      if aptc_household&.total_expected_contribution_amount.present?
        thhs_hash[thh_hbx_assigned_id] = aptc_household.total_expected_contribution_amount
      end
      thhs_hash
    end

    if thh_hbx_assigned_id_with_expected_contribution.present?
      csv << [row['ApplicationHbxID'], thh_hbx_assigned_id_with_expected_contribution.to_json]
    end
  rescue StandardError => e
    puts "Unable to process ApplicationHbxID: #{row['ApplicationHbxID']}, message: #{e.message}, backtrace: #{e.backtrace}"
  end
end
