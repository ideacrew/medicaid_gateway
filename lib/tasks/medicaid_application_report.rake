# frozen_string_literal: true

require "#{Rails.root}/app/reports/medicaid_application_report"

require 'csv'

# RAILS_ENV=production bundle exec rake reports:medicaid_application
namespace :reports do
  task :medicaid_application => :environment do
    MedicaidApplicationReport.run
  end
end