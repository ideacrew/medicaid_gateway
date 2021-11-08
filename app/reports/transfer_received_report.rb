# frozen_string_literal: true

require 'csv'

# Class used for returning Transfer reports
class TransferReceivedReport
  def self.run
    start_on = ENV['start_on'].present? ? Date.strptime(ENV['start_on'].to_s, "%m/%d/%Y") : Date.yesterday
    end_on = ENV['end_on'].present? ? Date.strptime(ENV['end_on'].to_s, "%m/%d/%Y") : Date.yesterday
    self.run_report(start_on, end_on)
  end

  def self.run_report(start_on, end_on)
    timestamp = Time.zone.now.strftime("%Y%m%d_%H%M%S")
    range = start_on.beginning_of_day..end_on.end_of_day
    at_received = Aces::InboundTransfer.where(created_at: range).or(updated_at: range)

    report_name = "transfer_received_report_#{timestamp}.csv"
    FileUtils.touch(report_name)
    CSV.open(report_name, "w") do |csv|
      csv << %w[DateRange TransferStatus CreatedAt FamilyHBXId ApplicationHBXId IngestionStatus FromCMS]
      break if at_received.blank?
      at_received.each do |transfer|
        csv << [
          range,
          transfer.successful?,
          transfer.created_at,
          transfer.family_identifier,
          transfer.application_identifier,
          transfer.result,
          !transfer.to_enroll
        ]
      end
    end
  end
end