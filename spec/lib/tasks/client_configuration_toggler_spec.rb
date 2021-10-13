# frozen_string_literal: true

require 'rails_helper'
require 'rake'
Rake.application.rake_require "tasks/client_configuration_toggler"
Rake::Task.define_task(:environment)

RSpec.describe 'Changing system config files based on client config templates', :type => :task, dbclean: :around_each do
  before :each do
    Rake::Task["configuration:client_configuration_toggler"].reenable
  end

  context "when raising errors" do
    context "with missing client target" do
      it "should raise RuntimeError" do
        error_message = "Please set your target client as an arguement. " \
        "The rake command should look like:" \
        " RAILS_ENV=production bundle exec rake client_config_toggler:migrate client='me'"
        rake = Rake::Task["configuration:client_configuration_toggler"]
        expect { rake.invoke }.to raise_error(RuntimeError, error_message)
      end
    end

    context "with incorrect length of client target string" do
      it "should raise RuntimeError" do
        ENV['client'] = "Maine"
        error_message = "Incorrect state abbreviation length. Set abbreviation to two letters like 'ME' or 'DC'"
        expect { Rake::Task["configuration:client_configuration_toggler"].invoke }.to raise_error(RuntimeError, error_message)
      end
    end
  end

  context "invoking rake" do
    it "should work" do
        # TODO
    end
  end
end
