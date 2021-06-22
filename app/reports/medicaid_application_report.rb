# frozen_string_literal: true

require 'csv'

# Class used for returning Medicaid Application reports
class MedicaidApplicationReport
  def self.run
    timestamp = Time.zone.now.to_s
    start_on = ENV['start_on'].present? ? Date.strptime(ENV['start_on'].to_s, "%m/%d/%Y") : Date.today
    end_on = ENV['end_on'].present? ? Date.strptime(ENV['end_on'].to_s, "%m/%d/%Y") : Date.today
    range = start_on.beginning_of_day..end_on.end_of_day
    report_name = "medicaid_application_report_#{timestamp}.csv"
    FileUtils.touch(report_name)
    CSV.open(report_name, "w") do |csv|
      csv << %w[application_identifier medicaid_request_payload medicaid_response_payload]
      todays_applications = Medicaid::Application.where(created_at: range).or(updated_at: range)
      puts("No applications present.") if todays_applications.blank?
      break if todays_applications.blank?
      todays_applications.each do |application|
        # What goes here? Just the attributes?
        csv << [
          application.application_identifier,
          application.medicaid_request_payload,
          application.medicaid_response_payload
        ]
      end
    end
  end
end