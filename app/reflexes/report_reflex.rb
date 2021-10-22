# frozen_string_literal: true

# Update report pages based on user actions
class ReportReflex < ApplicationReflex

  def change_date
    session_name = element.dataset[:session]
    session[session_name] = Date.parse(element.value)
  end

  def check_payload
    Curam::CheckPayload.new.call(element.dataset[:id])
  end

  def resubmit_to_enroll
    Transfers::ToEnroll.new.call(element.dataset[:payload], element.dataset[:id])
  end
end