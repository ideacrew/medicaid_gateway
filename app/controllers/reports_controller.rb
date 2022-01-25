# frozen_string_literal: true

# ReportsController provides API access to reports
class ReportsController < ApplicationController

  def events
    @start_on = start_on || session_date(session[:start]) || Date.today
    @end_on = end_on || session_date(session[:end]) || Date.today
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
    @start_on = start_on || session_date(session[:ma_start]) || Date.today
    @end_on = end_on || session_date(session[:ma_end]) || Date.today
    @application_id = params.fetch(:app) if params.key?(:app)
    @applications = if @application_id
                      applications.where(application_identifier: @application_id).page params[:page]
                    else
                      applications.order(updated_at: :desc).page params[:page]
                    end
  end

  def account_transfers
    @start_on = start_on || session_date(session[:atp_start]) || Date.today
    @end_on = end_on || session_date(session[:atp_end]) || Date.today
    @transfers = transfers.order(updated_at: :desc).page params[:page]
    @success_count = transfers.select(&:successful?).count
    @fail_count = transfers.count - @success_count
  end

  def account_transfers_to_enroll
    @start_on = start_on || session_date(session[:inbound_start]) || Date.today
    @end_on = end_on || session_date(session[:inbound_end]) || Date.today
    @transfers = inbound_transfers.order(updated_at: :desc).page params[:page]
    @success_count = inbound_transfers.select(&:successful?).count
    @fail_count = inbound_transfers.count - @success_count
  end

  def mec_checks
    @start_on = start_on || session_date(session[:mc_sent_start]) || Date.today
    @end_on = end_on || session_date(session[:mc_sent_end]) || Date.today
    @checks = checks.order(updated_at: :desc).page params[:page]
    @success_count = checks.select(&:successful?).count
    @fail_count = checks.count - @success_count
  end

  def transfer_summary
    @start_on = start_on || session_date(session[:ts_start]) || Date.today
    @end_on = end_on || session_date(session[:ts_end]) || Date.today
    @at_sent_total = transfers.count
    @at_sent_successful = transfers.where(failure: nil).count
    @at_sent_failure = @at_sent_total - @at_sent_successful
    @at_received_total = inbound_transfers.count
    @at_received_successful = inbound_transfers.where(failure: nil).count
    @at_received_failure = @at_received_total - @at_received_successful
    @sent_from_cms = transfers.where(from_cms: true).count
    @received_from_cms = inbound_transfers.where(to_enroll: false).count
  end

  def update_transfer_requested # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    @start_on = start_on || session_date(session[:inbound_start]) || Date.today
    @end_on = end_on || session_date(session[:inbound_end]) || Date.today
    transfers = inbound_transfers.select(&:waiting_to_transfer?)
    external_ids = transfers&.map(&:external_id)&.uniq
    external_ids&.map do |external_id|
      result = Transfers::ToEnrollBatch.new.call(external_id, transfers.select {|t| t.external_id == external_id })
      if result.success?
        result.value![0]&.each { |transfer| transfer.update!(result: 'Sent to Enroll') }
      else
        trs = Aces::InboundTransfer.all.select {|t| t.external_id == external_id }
        trs&.each { |transfer| transfer.update!(result: 'Failure', failure: result.failure) } if trs.present?
      end
    end
    redirect_to account_transfers_to_enroll_reports_path
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
    Medicaid::Application.only(:application_identifier, :created_at, :application_response_payload).where(created_at: range).or(updated_at: range)
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

  def session_date(date)
    return unless date
    return date if date.is_a? Date
    Date.parse(date, "%Y-%m-%d")
  end
end
