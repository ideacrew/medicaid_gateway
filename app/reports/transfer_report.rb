# frozen_string_literal: true

require 'csv'

# Class used for returning Transfer reports
class TransferReport
  def self.run
    timestamp = Time.zone.now.to_s
    start_on = ENV['start_on'].present? ? Date.strptime(ENV['start_on'].to_s, "%m/%d/%Y") : (Date.today - 10.years)
    end_on = ENV['end_on'].present? ? Date.strptime(ENV['end_on'].to_s, "%m/%d/%Y") : Date.today
    range = start_on.beginning_of_day..end_on.end_of_day
    report_name = "transfer_report_#{timestamp}.csv"
    FileUtils.touch(report_name)
    CSV.open(report_name, "w") do |csv|
      csv << %w[ApplicationIdentifer FamilyIdentifier Service
                ResponsePayload CreatedAt]
      todays_transfers = Aces::Transfer.where(created_at: range).or(updated_at: range)
      break if todays_transfers.blank?
      todays_transfers.each do |transfer|
        csv << [
          transfer.application_identifier,
          transfer.family_identifier,
          transfer.service,
          transfer.response_payload,
          transfer.created_at
        ]
      end
    end
  end
end





