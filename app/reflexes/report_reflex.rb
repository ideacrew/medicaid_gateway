# frozen_string_literal: true

# Update report pages based on user actions
class ReportReflex < ApplicationReflex

  def change_date(session_name, date)
    session[session_name] = Date.parse(date) ? Date.strptime(date, "%Y-%m-%d") : Date.strptime(date.to_date, "%Y-%m-%d")
  end

  def change_dates(session_name, start_date, end_date)
    session["#{session_name}start"] = Date.parse(start_date) ? Date.strptime(start_date, "%Y-%m-%d") : Date.strptime(start_date.to_date, "%Y-%m-%d")
    session["#{session_name}end"] = Date.parse(end_date) ? Date.strptime(end_date, "%Y-%m-%d") : Date.strptime(end_date.to_date, "%Y-%m-%d")

  def app_search(value)
    session["app"] = value == "" ? nil : value
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
end