# frozen_string_literal: true

require 'csv'

# Class used for returning Medicaid Application reports
class MedicaidApplicationReport
  def self.run
    timestamp = Time.zone.now.to_s
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
          other_factors(application)
        ]
      end
    end
  end

  def self.other_factors(application)
    return 'No other factors' unless application.aptc_households.present?
    aptc_hh_keys = %w[total_household_count annual_tax_household_income csr_annual_income_limit
                      is_aptc_calculated maximum_aptc_amount total_expected_contribution_amount
                      total_benchmark_plan_monthly_premium_amount assistance_year fpl_percent eligibility_date
                      aptc_household_members benchmark_calculation_members]
    application.attributes['aptc_households'].inject([]) do |aptc_hh_array, aptc_hash|
      aptc_hh_array << aptc_hash.select { |k, _v| aptc_hh_keys.include?(k) }
    end
  end
end