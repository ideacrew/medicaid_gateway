# frozen_string_literal: true

# ReportsController provides API access to reports
class ReportsController < ApplicationController

  def medicaid_applications
    range = range_from_params
    applications = Medicaid::Application.where(created_at: range).or(updated_at: range)
    render json: applications
  end

  def medicaid_application_check
    @range = range_from_params
    @applications = Medicaid::Application.where(created_at: @range).or(updated_at: @range)
  end

  def account_transfers
    @range = range_from_params
    @transfers = Aces::Transfer.where(created_at: @range).or(updated_at: @range)
  end

  def account_transfers_to_enroll
    @range = range_from_params
    @transfers = Aces::InboundTransfer.where(created_at: @range).or(updated_at: @range)
  end

  def mec_checks
    @range = range_from_params
    @checks = Aces::MecCheck.where(created_at: @range).or(updated_at: @range)
  end

  def transfer_summary
    @range = range_from_params
    @start_on = params.fetch(:start_on) if params.key?(:start_on)
    @end_on = params.fetch(:end_on) if params.key?(:end_on)
    at_sent = Aces::Transfer.where(created_at: @range).or(updated_at: @range)
    @at_sent_total = at_sent.count
    @at_sent_successful = at_sent.where(failure: nil).count
    @at_sent_failure = @at_sent_total - @at_sent_successful

    at_received = Aces::InboundTransfer.where(created_at: @range).or(updated_at: @range)
    @at_received_total = at_received.count
    @at_received_successful = at_received.where(failure: nil).count
    @at_received_failure = @at_received_total - @at_received_successful
  end

  private

  def range_from_params
    start_on = params.key?(:start_on) ? Date.strptime(params.fetch(:start_on), "%m/%d/%Y") : Time.now.utc
    end_on = params.key?(:end_on) ? Date.strptime(params.fetch(:end_on), "%m/%d/%Y") : Time.now.utc
    start_on.beginning_of_day..end_on.end_of_day
  end
end
