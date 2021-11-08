# frozen_string_literal: true

require 'csv'

# Class used for returning Medicaid Application reports
class MedicaidApplicationReport
  def self.run
    timestamp = Time.zone.now.strftime("%Y%m%d_%H%M%S")
    start_on = ENV['start_on'].present? ? Date.strptime(ENV['start_on'].to_s, "%m/%d/%Y") : (Date.today - 10.years)
    end_on = ENV['end_on'].present? ? Date.strptime(ENV['end_on'].to_s, "%m/%d/%Y") : Date.today
    range = start_on.beginning_of_day..end_on.end_of_day
    report_name = "medicaid_application_report_#{timestamp}.csv"
    FileUtils.touch(report_name)
    CSV.open(report_name, "w") do |csv|
      csv << %w[ApplicationIdentifer MedicaidRequestPayload MedicaidResponsePayload
                ApplicationRequestPayload ApplicationResponsePayload OtherComputedFactors]
      todays_applications = Medicaid::Application.where(created_at: range).or(updated_at: range)
      break if todays_applications.blank?
      todays_applications.each do |application|
        csv << [
          application.application_identifier,
          application.medicaid_request_payload,
          application.medicaid_response_payload,
          application.application_request_payload,
          application.application_response_payload,
          application.other_factors
        ]
      end
    end
  end
end
