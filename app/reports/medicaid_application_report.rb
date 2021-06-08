require 'csv'

class MedicaidApplicationReport
  def self.run
    timestamp = Time.now.to_s
    report_name = "medicaid_application_report_#{timestamp}.csv"
    FileUtils.touch(report_name)
    CSV.open(report_name, "w") do |csv|
      csv << %w[application_identifier medicaid_request_payload medicaid_response_payload]
      todays_applications = Medicaid::Application.where(
        created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
      )
      puts("No applications present.") if todays_applications.blank?
      return if todays_applications.blank?
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