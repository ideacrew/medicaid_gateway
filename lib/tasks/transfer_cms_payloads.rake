# frozen_string_literal: true

# RAILS_ENV=production bundle exec rake transfer:cms_payloads start_on="06/21/2021" end_on='06/22/202'
namespace :transfer do
  task :cms_payloads => :environment do
    # get all inbound transfers from the given time range that are from cms and have a payload then transfer them to aces
    start_on = ENV['start_on'].present? ? Date.strptime(ENV['start_on'].to_s, "%m/%d/%Y") : Date.today
    end_on = ENV['end_on'].present? ? Date.strptime(ENV['end_on'].to_s, "%m/%d/%Y") : Date.today
    range = start_on.beginning_of_day..end_on.end_of_day
    transfers = Aces::InboundTransfer.where(created_at: range).select(&:from_cms_to_aces?)
    transfers.map(&:from_cms_to_aces)
  end
  task :initial_cms_payloads => :environment do
    # for initial payloads pre-fix: RAILS_ENV=production bundle exec rake transfer:initial_cms_payloads
    atp = "http://at.dsh.cms.gov/exchange/1.0"
    soap = "http://www.w3.org/2003/05/soap-envelope"
    transfers = Aces::InboundTransfer.all
    transfers.each do |transfer|
      next unless transfer.payload.present?
      document = Nokogiri::XML(transfer.payload)
      body_node = document.at_xpath("//soap:Envelope/soap:Body/atp:AccountTransferRequest", { atp: atp, soap: soap })
      next unless body_node
      payload = body_node.canonicalize
      transfer.update!(payload: payload, to_enroll: false, failure: nil, result: "Waiting to Send")
    end
  end
end