# frozen_string_literal: true

# Update report pages based on user actions
class ReportReflex < ApplicationReflex

  def change_date(session_name, date)
    session[session_name] = Date.parse(date) ? Date.strptime(date, "%Y-%m-%d") : Date.strptime(date.to_date, "%Y-%m-%d")
  end

  def check_payload
    Curam::CheckPayload.new.call(element.dataset[:id])
  end

  def resubmit_to_enroll
    Transfers::ToEnroll.new.call(element.dataset[:payload], element.dataset[:id])
    morph :nothing
  end

  def resubmit_to_service
    Transfers::ToService.new.call(element.dataset[:payload], element.dataset[:id])
  end

  COUNT_MESSAGES = {
    account_transfers: "transfers during this range",
    account_transfers_to_enroll: "transfers during this range",
    mec_checks: "checks during this range",
    medicaid_application_check: "determinations during this range"
  }.freeze

  def increment_counts(report, total, success, failure, result)
    count_text = COUNT_MESSAGES[report.to_sym]
    morph "#total-count", "#{total.to_i + 1} #{count_text}"
    morph "#success-count", "#{success.to_i + 1} Successful" if result == "Success"
    morph "#fail-count", "#{failure.to_i + 1} Failures" if result == "Failure"
  end

  # rubocop:disable Metrics/ParameterLists
  def increment_event_log(event, total, transfers, inbound_transfers, determinations, mec_checks)
    event = event.split("-")[1]
    transfers = transfers.split.last.to_i
    inbound_transfers = inbound_transfers.last.to_i
    determinations = determinations.last.to_i
    mec_checks = mec_checks.last.to_i

    case event
    when "transfer"
      morph "#transfers-count", "Transfers Out: #{transfers.to_i + 1}"
    when "inbound"
      morph "#inbound-transfers-count", "Transfers In: #{inbound_transfers.to_i + 1}"
    when "determination"
      morph "#determinations-count", "Determinations: #{determinations.to_i + 1}"
    when "check"
      morph "#mec-checks-count", "MEC Checks: #{mec_checks.to_i + 1}"
    end

    morph "#total-count", "#{total.to_i + 1} events during this range"
  end
  # rubocop:enable Metrics/ParameterLists
end