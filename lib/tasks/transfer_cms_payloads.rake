# frozen_string_literal: true

# medicaid: RAILS_ENV=production bundle exec rake transfer:cms_payloads start_on="06/21/2021" end_on='06/22/202'
namespace :transfer do
  task :cms_payloads => :environment do
    # get all inbound transfers from the given time range that are from cms and have a payload then transfer them to aces
    start_on = ENV['start_on'].present? ? Date.strptime(ENV['start_on'].to_s, "%m/%d/%Y") : Date.today
    end_on = ENV['end_on'].present? ? Date.strptime(ENV['end_on'].to_s, "%m/%d/%Y") : Date.today
    range = start_on.beginning_of_day..end_on.end_of_day
    transfers = Aces::InboundTransfer.where(created_at: range).select(&:from_cms_to_aces?)
    transfers.map(&:from_cms_to_aces)
  end
end