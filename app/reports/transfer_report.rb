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
    yesterday = Date.yesterday
    timestamp = if start_on == yesterday && end_on == yesterday
                  yesterday.strftime("%Y_%m_%d")
                else
                  "#{start_on.strftime('%Y_%m_%d')}_to_#{end_on.strftime('%Y_%m_%d')}"
                end
    range = start_on.beginning_of_day..end_on.end_of_day
    report_name = "transfer_report_#{timestamp}.csv"
    FileUtils.touch(report_name)
    CSV.open(report_name, "w") do |csv|
      csv << headers
      row = [range] + transfer_values(range)

      if MedicaidGatewayRegistry.feature_enabled?(:transfer_to_enroll)
        inbound_vals = inbound_transfer_values(range)
        row.insert(2, inbound_vals[:total])
        row << inbound_vals[:successful]
        row << inbound_vals[:failure]
        row << inbound_vals[:from_cms]
      end

      csv << row
    end
  end

  def self.headers
    if MedicaidGatewayRegistry.feature_enabled?(:transfer_to_enroll)
      %w[DateRange Sent Received SentSuccesses SentFailures SentFromCMS ReceivedSuccesses ReceivedFailures ReceivedFromCMS]
    else
      %w[DateRange Sent SentSuccesses SentFailures]
    end
  end

  def self.transfer_values(range)
    at_sent = Aces::Transfer.where(created_at: range).or(updated_at: range)
    at_sent_total = at_sent.count
    at_sent_successful = at_sent.where(failure: nil).count
    at_sent_failure = at_sent_total - at_sent_successful
    at_from_cms = at_sent.where(from_cms: true).count
    [
      at_sent_total,
      at_sent_successful,
      at_sent_failure,
      at_from_cms
    ]
  end

  def self.inbound_transfer_values(range)
    at_received = Aces::InboundTransfer.where(created_at: range).or(updated_at: range)
    at_received_total = at_received.count
    at_received_successful = at_received.where(failure: nil).count
    at_received_failure = at_received_total - at_received_successful
    at_received_from_cms = at_received.where(to_enroll: false).count
    {
      total: at_received_total,
      successful: at_received_successful,
      failure: at_received_failure,
      from_cms: at_received_from_cms
    }
  end
end





