# frozen_string_literal: true

require 'csv'

# Class used for returning Transfer reports
class TransferReport
  def self.run
    start_on = ENV['start_on'].present? ? Date.strptime(ENV['start_on'].to_s, "%m/%d/%Y") : Date.yesterday
    end_on = ENV['end_on'].present? ? Date.strptime(ENV['end_on'].to_s, "%m/%d/%Y") : Date.yesterday
    self.run_report(start_on, end_on)
  end

  def self.run_report(start_on, end_on)
    timestamp = Time.zone.now.to_s
    range = start_on.beginning_of_day..end_on.end_of_day
    at_sent = Aces::Transfer.where(created_at: range).or(updated_at: range)
    at_sent_total = at_sent.count
    at_sent_successful = at_sent.where(failure: nil).count
    at_sent_failure = at_sent_total - at_sent_successful

    at_received = Aces::InboundTransfer.where(created_at: range).or(updated_at: range)
    at_received_total = at_received.count
    at_received_successful = at_received.where(failure: nil).count
    at_received_failure = at_received_total - at_received_successful

    report_name = "transfer_report_#{timestamp}.csv"
    FileUtils.touch(report_name)
    CSV.open(report_name, "w") do |csv|
      csv << %w[DateRange Sent Received SentSuccesses SentFailures ReceivedSuccesses ReceivedFailures]
      csv << [
        range,
        at_sent_total,
        at_received_total,
        at_sent_successful,
        at_sent_failure,
        at_received_successful,
        at_received_failure
      ]
    end
  end
end





