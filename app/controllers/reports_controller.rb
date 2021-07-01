# frozen_string_literal: true

# ReportsController provides API access to reports
class ReportsController < ApplicationController

  def medicaid_applications
    range = range_from_params
    applications = Medicaid::Application.where(created_at: range).or(updated_at: range)
    render json: applications
  end

  private

  def range_from_params
    start_on = params.key?(:start_on) ? Date.strptime(params.fetch(:start_on), "%m/%d/%Y") : Date.today
    end_on = params.key?(:end_on) ? Date.strptime(params.fetch(:end_on), "%m/%d/%Y") : Date.today
    start_on.beginning_of_day..end_on.end_of_day
  end
end