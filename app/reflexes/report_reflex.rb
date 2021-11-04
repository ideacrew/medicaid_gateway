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
  end

  def resubmit_to_service
    Transfers::ToService.new.call(element.dataset[:payload], element.dataset[:id])
  end

  def log_reflex
    cable_ready.console_log(message: "Cable Ready and Stimulus Reflex working!").broadcast
  end
end