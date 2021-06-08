# frozen_string_literal: true

require "#{Rails.root}/app/reports/medicaid_application_report"

require 'csv'

namespace :reports do
  task :medicaid_application => :environment do
    MedicaidApplicationReport.run
  end
end