# frozen_string_literal: true

require 'csv'

# Class used for returning Transfer reports
class TransferSentReport
  def self.run
    start_on = ENV['start_on'].present? ? Date.strptime(ENV['start_on'].to_s, "%m/%d/%Y") : Date.yesterday
    end_on = ENV['end_on'].present? ? Date.strptime(ENV['end_on'].to_s, "%m/%d/%Y") : Date.yesterday
    self.run_report(start_on, end_on)
  end

  def self.run_report(start_on, end_on)
    timestamp = Time.zone.now.to_s
    range = start_on.beginning_of_day..end_on.end_of_day
    at_sent = Aces::Transfer.where(created_at: range).or(updated_at: range)

    report_name = "transfer_sent_report_#{timestamp}.csv"
    FileUtils.touch(report_name)
    CSV.open(report_name, "w") do |csv|
      csv << %w[DateRange TransferStatus CreatedAt FamilyHBXId ApplicationHBXId IngestionStatus]
      break if at_sent.blank?
      at_sent.each do |transfer|
        csv << [
          range,
          transfer.successful?,
          transfer.created_at,
          transfer.family_identifier,
          transfer.application_identifier,
          transfer.callback_status
        ]
      end
    end
  end
end





