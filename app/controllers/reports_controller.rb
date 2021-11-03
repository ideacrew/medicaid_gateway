# frozen_string_literal: true

# ReportsController provides API access to reports
class ReportsController < ApplicationController

  def events
    @start_on = start_on || session[:start] || Date.today
    @end_on = end_on || session[:end] || Date.today
    events = applications + transfers + inbound_transfers + checks
    events.map!(&:to_event).sort_by! { |event| event[:created_at] }.reverse!
    @events_count = events.count
    @events = Kaminari.paginate_array(events).page params[:page]
    @transfers_total = transfers.count
    @inbound_transfers_total = inbound_transfers.count
    @determinations_total = applications.count
    @mec_checks_total = checks.count
  end

  def medicaid_applications
    render json: Medicaid::Application.where(created_at: range_from_params).or(updated_at: range_from_params)
  end

  def medicaid_application_check
    @start_on = start_on || session[:ma_start] || Date.today
    @end_on = end_on || session[:ma_end] || Date.today
    ordered_applications = applications.order(updated_at: :desc)
    @applications = ordered_applications.page params[:page]
    @applications = ordered_applications.where(application_identifier: params.fetch(:app)) if params.key?(:app)
  end

  def account_transfers
    @start_on = start_on || session[:atp_start] || Date.today
    @end_on = end_on || session[:atp_end] || Date.today
    @transfers = transfers.order(updated_at: :desc).page params[:page]
    @success_count = transfers.select(&:successful?).count
    @fail_count = transfers.count - @success_count
  end

  def account_transfers_to_enroll
    @start_on = start_on || session[:atp_start] || Date.today
    @end_on = end_on || session[:atp_end] || Date.today
    @transfers = inbound_transfers.order(updated_at: :desc).page params[:page]
    @success_count = inbound_transfers.select(&:successful?).count
    @fail_count = inbound_transfers.count - @success_count
  end

  def mec_checks
    @start_on = start_on || session[:mc_sent_start] || Date.today
    @end_on = session[:mc_sent_end] || Date.today
    @checks = checks.order(updated_at: :desc).page params[:page]
    @success_count = checks.select(&:successful?).count
    @fail_count = checks.count - @success_count
  end

  def transfer_summary
    @start_on = start_on || session[:atp_start] || Date.today
    @end_on = end_on || session[:atp_end] || Date.today
    @at_sent_total = transfers.count
    @at_sent_successful = transfers.where(failure: nil).count
    @at_sent_failure = @at_sent_total - @at_sent_successful
    @at_received_total = inbound_transfers.count
    @at_received_successful = inbound_transfers.where(failure: nil).count
    @at_received_failure = @at_received_total - @at_received_successful
    @sent_from_cms = transfers.where(from_cms: true).count
    @received_from_cms = inbound_transfers.where(to_enroll: false).count
  end

  private

  def range_from_params
    start_on = params.key?(:start_on) ? Date.strptime(params.fetch(:start_on), "%m/%d/%Y") : Time.now.utc
    end_on = params.key?(:end_on) ? Date.strptime(params.fetch(:end_on), "%m/%d/%Y") : Time.now.utc
    start_on.beginning_of_day..end_on.end_of_day
  end

  def start_on
    Date.strptime(params.fetch(:start_on), "%m/%d/%Y") if params.key?(:start_on)
  end

  def end_on
    Date.strptime(params.fetch(:end_on), "%m/%d/%Y") if params.key?(:end_on)
  end

  def range
    @start_on.beginning_of_day..@end_on.end_of_day
  end

  def applications
    Medicaid::Application.where(created_at: range).or(updated_at: range)
  end

  def transfers
    Aces::Transfer.where(created_at: range).or(updated_at: range)
  end

  def inbound_transfers
    Aces::InboundTransfer.where(created_at: range).or(updated_at: range)
  end

  def checks
    Aces::MecCheck.where(created_at: range).or(updated_at: range)
  end
end
