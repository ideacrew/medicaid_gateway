# frozen_string_literal: true

require 'csv'

# Class used for returning Transfer reports
# create report of all failing outbound atp transfers, if no start/end specified defaults to year to date
class OutboundTransferFailureReport
  def self.run
    start_on = ENV['start_on'].present? ? Date.strptime(ENV['start_on'].to_s, "%m/%d/%Y") : Date.today.beginning_of_year
    end_on = ENV['end_on'].present? ? Date.strptime(ENV['end_on'].to_s, "%m/%d/%Y") : Date.today
    puts ":: Generating Outbound Transfer Failure Report for #{start_on} -- #{end_on} ::"
    self.run_report(start_on, end_on)
  end

  def self.run_report(start_on, end_on) # rubocop:disable Metrics/MethodLength
    start_time = Time.now
    yesterday = Date.yesterday
    timestamp = if start_on == yesterday && end_on == yesterday
                  yesterday.strftime("%Y_%m_%d")
                else
                  "#{start_on.strftime('%Y_%m_%d')}_to_#{end_on.strftime('%Y_%m_%d')}"
                end
    range = start_on.beginning_of_day..end_on.end_of_day
    at_sent = Aces::Transfer.where(created_at: range).or(updated_at: range)
    only_failures = at_sent.not(failure: nil)

    report_name = "outbound_transfer_failure_report_#{timestamp}.csv"
    FileUtils.touch(report_name)
    CSV.open(report_name, "w") do |csv|
      csv << %w[TransferStatus CreatedAt FamilyHBXId ApplicationHBXId IngestionStatus FromCMS Failure]
      break if only_failures.blank?
      only_failures.each do |transfer|
        csv << [
          transfer.successful?,
          transfer.created_at,
          transfer.family_identifier,
          transfer.application_identifier,
          transfer.callback_status,
          transfer.from_cms,
          transfer.failure
        ]
      end
    end
    runtime = Time.current - start_time
    puts ":: Report generated with #{only_failures.length} records in #{runtime} seconds ::"
  end
end





