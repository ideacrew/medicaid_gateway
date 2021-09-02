# frozen_string_literal: true

# ReportsController provides API access to reports
class ReportsController < ApplicationController

  def medicaid_applications
    range = range_from_params
    applications = Medicaid::Application.where(created_at: range).or(updated_at: range)
    render json: applications
  end

  def medicaid_application_check
    range = range_from_params
    @applications = Medicaid::Application.where(created_at: range).or(updated_at: range)
  end

  def account_transfers
    range = range_from_params
    @transfers = Aces::Transfer.where(created_at: range).or(updated_at: range)
  end

  private

  def range_from_params
    start_on = params.key?(:start_on) ? Date.strptime(params.fetch(:start_on), "%m/%d/%Y") : Time.now.utc
    end_on = params.key?(:end_on) ? Date.strptime(params.fetch(:end_on), "%m/%d/%Y") : Time.now.utc
    start_on.beginning_of_day..end_on.end_of_day
  end
end
