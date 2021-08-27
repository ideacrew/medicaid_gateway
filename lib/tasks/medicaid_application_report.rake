# frozen_string_literal: true

require "#{Rails.root}/app/reports/medicaid_application_report"
require "#{Rails.root}/app/reports/transfer_report"

require 'csv'

# medicaid: RAILS_ENV=production bundle exec rake reports:medicaid_application start_on="06/21/2021" end_on='06/22/202'
# transfers: RAILS_ENV=production bundle exec rake reports:account_transfer start_on="06/21/2021" end_on='06/22/202'
namespace :reports do
  task :medicaid_application => :environment do
    MedicaidApplicationReport.run
  end
  task :account_transfer => :environment do
    TransferReport.run
  end
end