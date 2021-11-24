# frozen_string_literal: true

require 'csv'

# Failed determinations report
class DeterminationFailuresReport
  def self.run
    start_on = ENV['start_on'].present? ? Date.strptime(ENV['start_on'].to_s, "%m/%d/%Y") : Date.yesterday
    end_on = ENV['end_on'].present? ? Date.strptime(ENV['end_on'].to_s, "%m/%d/%Y") : Date.yesterday
    domain_url = ENV['domain_url'] || 'qa-medicaid-gateway.cme.openhbx.org'
    puts ":: Generating Determination Failure Report for #{start_on} -- #{end_on}::"
    self.run_report(start_on, end_on, domain_url)
  end

  def self.run_report(start_on, end_on, domain_url)
    timestamp = Time.zone.now.strftime("%Y%m%d_%H%M%S")

    failed_determinations = Medicaid::Application.all.where(:created_at.gte => start_on.beginning_of_day,
                                                            :created_at.lte => end_on.end_of_day)
                                                 .not(medicaid_response_payload: nil).select do |application|
      JSON.parse(
        application.medicaid_response_payload
      ).keys.find {|k| k.match(/error/i)}
    end

    report_name = "determination_failures_#{timestamp}.csv"
    FileUtils.touch(report_name)
    CSV.open(report_name, "w") do |csv|
      csv << %w[CreatedAt Errors Link]

      failed_determinations.each do |determination|
        errors = JSON.parse(determination.medicaid_response_payload).find {|k, _v| k.match(/error/i)}[1]
        link = "https://#{domain_url}/medicaid/applications/#{determination.id}"
        csv << [
          determination.created_at,
          errors,
          link
        ]
      end
    end

    puts ":: Report generated with #{failed_determinations.length} records ::"
  end
end
