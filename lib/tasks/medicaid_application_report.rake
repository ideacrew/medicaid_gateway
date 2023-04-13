# frozen_string_literal: true

require "#{Rails.root}/app/reports/medicaid_application_report"
require "#{Rails.root}/app/reports/transfer_report"

require 'csv'

# medicaid: RAILS_ENV=production bundle exec rake reports:medicaid_application start_on="06/21/2021" end_on='06/22/2021'
# transfers: RAILS_ENV=production bundle exec rake reports:account_transfer start_on="06/21/2021" end_on='06/22/2021'
# sent transfer details: RAILS_ENV=production bundle exec rake reports:account_transfer_sent start_on="06/21/2021" end_on='06/22/2021'
# received transfer details: RAILS_ENV=production bundle exec rake reports:account_transfer_received start_on="06/21/2021" end_on='06/22/2021'
# determination failures: RAILS_ENV=production bundle exec rake reports:determination_failures start_on="06/21/2021" end_on='06/22/2021'
# outbound transfer failures: RAILS_ENV=production bundle exec rake reports:outbound_transfer_failures start_on="04/01/2023" end_on='04/20/2023'
namespace :reports do
  task :medicaid_application => :environment do
    MedicaidApplicationReport.run
  end
  task :account_transfer => :environment do
    TransferReport.run
  end
  task :account_transfer_sent => :environment do
    TransferSentReport.run
  end
  task :account_transfer_received => :environment do
    TransferReceivedReport.run
  end
  task :determination_failures => :environment do
    DeterminationFailuresReport.run
  end
  task :outbound_transfer_failures => :environment do
    OutboundTransferFailureReport.run
  end
end