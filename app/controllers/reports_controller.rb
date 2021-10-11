# frozen_string_literal: true

# ReportsController provides API access to reports
class ReportsController < ApplicationController

  def events
    start_on = Date.strptime(params.fetch(:start_on), "%m/%d/%Y") if params.key?(:start_on)
    @start_on = start_on || session[:start] || Date.today
    end_on = Date.strptime(params.fetch(:end_on), "%m/%d/%Y") if params.key?(:end_on)
    @end_on = end_on || session[:end] || Date.today
    range = @start_on.beginning_of_day..@end_on.end_of_day

    applications = Medicaid::Application.where(created_at: range).or(updated_at: range)
    transfers = Aces::Transfer.where(created_at: range).or(updated_at: range)
    inbound_transfers = Aces::InboundTransfer.where(created_at: range).or(updated_at: range)
    checks = Aces::MecCheck.where(created_at: range).or(updated_at: range)
    events = applications + transfers + inbound_transfers + checks
    @events = events.map(&:to_event).sort_by { |event| event[:created_at] }.reverse
  end

  def medicaid_applications
    range = range_from_params
    applications = Medicaid::Application.where(created_at: range).or(updated_at: range)
    render json: applications
  end

  def medicaid_application_check
    start_on = Date.strptime(params.fetch(:start_on), "%m/%d/%Y") if params.key?(:start_on)
    @start_on = start_on || session[:ma_start] || Date.today
    end_on = Date.strptime(params.fetch(:end_on), "%m/%d/%Y") if params.key?(:end_on)
    @end_on = end_on || session[:ma_end] || Date.today
    range = @start_on.beginning_of_day..@end_on.end_of_day
    @applications = Medicaid::Application.where(created_at: range).or(updated_at: range).reverse
  end

  def account_transfers
    start_on = Date.strptime(params.fetch(:start_on), "%m/%d/%Y") if params.key?(:start_on)
    @start_on = start_on || session[:atp_start] || Date.today
    end_on = Date.strptime(params.fetch(:end_on), "%m/%d/%Y") if params.key?(:end_on)
    @end_on = end_on || session[:atp_end] || Date.today
    range = @start_on.beginning_of_day..@end_on.end_of_day
    @transfers = Aces::Transfer.where(created_at: range).or(updated_at: range).reverse
  end

  def account_transfers_to_enroll
    start_on = Date.strptime(params.fetch(:start_on), "%m/%d/%Y") if params.key?(:start_on)
    @start_on = start_on || session[:atp_start] || Date.today
    end_on = Date.strptime(params.fetch(:end_on), "%m/%d/%Y") if params.key?(:end_on)
    @end_on = end_on || session[:atp_end] || Date.today
    range = @start_on.beginning_of_day..@end_on.end_of_day
    @transfers = Aces::InboundTransfer.where(created_at: range).or(updated_at: range).reverse
  end

  def mec_checks
    start_on = Date.strptime(params.fetch(:start_on), "%m/%d/%Y") if params.key?(:start_on)
    @start_on = start_on || session[:mc_sent_start] || Date.today
    @end_on = session[:mc_sent_end] || Date.today
    range = @start_on.beginning_of_day..@end_on.end_of_day
    @checks = Aces::MecCheck.where(created_at: range).or(updated_at: range).reverse
  end

  def transfer_summary
    start_on = Date.strptime(params.fetch(:start_on), "%m/%d/%Y") if params.key?(:start_on)
    @start_on = start_on || session[:atp_start] || Date.today
    end_on = Date.strptime(params.fetch(:end_on), "%m/%d/%Y") if params.key?(:end_on)
    @end_on = end_on || session[:atp_end] || Date.today
    range = @start_on.beginning_of_day..@end_on.end_of_day
    at_sent = Aces::Transfer.where(created_at: range).or(updated_at: range)
    @at_sent_total = at_sent.count
    @at_sent_successful = at_sent.where(failure: nil).count
    @at_sent_failure = @at_sent_total - @at_sent_successful

    at_received = Aces::InboundTransfer.where(created_at: range).or(updated_at: range)
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
