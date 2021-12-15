# frozen_string_literal: true

# RAILS_ENV=production bundle exec rake send:to_enroll start_on="06/21/2021" end_on='06/22/202'
namespace :send do
  desc 'get all inbound transfers from the given time range that are from aces and transfers complete applications to enroll'
  task :to_enroll => :environment do

    start_on = ENV['start_on'].present? ? Date.strptime(ENV['start_on'].to_s, "%m/%d/%Y") : Date.today
    end_on = ENV['end_on'].present? ? Date.strptime(ENV['end_on'].to_s, "%m/%d/%Y") : Date.today
    range = start_on.beginning_of_day..end_on.end_of_day
    transfers = Aces::InboundTransfer.where(created_at: range).select(&:waiting_to_transfer?)
    external_ids = transfers.map(&:external_id).uniq
    external_ids.map do |external_id|
      result = Transfers::ToEnrollBatch.new.call(external_id)
      if result.success?
        result.value![0]&.each { |transfer| transfer.update!(result: 'Sent to Enroll') }
        p result.value![1][:family][:magi_medicaid_applications].first[:applicants].count
      else
        trs = Aces::InboundTransfer.all.select {|t| t.external_id == external_id }
        next unless trs.present?
        trs.each { |transfer| transfer.update!(result: 'Failure', failure: result.failure) }
      end
    end
  end
end