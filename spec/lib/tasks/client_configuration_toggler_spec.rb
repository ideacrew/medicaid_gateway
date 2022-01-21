# frozen_string_literal: true

require 'rails_helper'
require 'rake'
Rake.application.rake_require "tasks/client_configuration_toggler"
Rake::Task.define_task(:environment)

RSpec.describe 'Changing system config files based on client config templates', :type => :task, dbclean: :around_each do

  before do
    @current_committed_client = MedicaidGatewayRegistry[:state_abbreviation].item
  end

  let(:rake) { Rake::Task["configuration:client_configuration_toggler"] }
  let(:feature_file) { YAML.load_file("system/config/templates/features/features.yml") }
  let(:integration_file) { YAML.load_file("system/config/templates/features/integration/integration.yml") }
  let(:features) { feature_file["registry"].first["features"] }
  let(:state_abbreviation) { features.find { |f| f["key"] == :state_abbreviation }["item"] }
  let(:namespace) { integration_file["registry"].first["namespace"].first }

  before :each do
    rake.reenable
  end

  after :each do
    rake.reenable
    ENV['client'] = @current_committed_client
    rake.invoke
  end

  context "when raising errors" do
    context "with missing client target" do

      it "should raise RuntimeError" do
        ENV['client'] = nil
        error_message = "Please set your target client as an arguement. " \
                        "The rake command should look like:" \
                        " RAILS_ENV=production bundle exec rake configuration:client_configuration_toggler client='me'"
        expect { rake.invoke }.to raise_error(RuntimeError, error_message)
      end
    end

    context "with incorrect length of client target string" do
      it "should raise RuntimeError" do
        ENV['client'] = "Maine"
        error_message = "Incorrect state abbreviation length. Set abbreviation to two letters like 'ME' or 'DC'"
        expect { rake.invoke }.to raise_error(RuntimeError, error_message)
      end
    end
  end

  context "invoking rake" do
    context "when client is set to DC" do
      before do
        ENV['client'] = 'DC'
        rake.invoke
      end

      it "should create the integration directory in system config" do
        expect(Dir.exist?("system/config/templates/features/integration/")).to eq true
      end

      it "should create the integration config file in system config" do
        expect(File.exist?("system/config/templates/features/integration/integration.yml")).to eq true
      end

      it "should set the state abbreviation to 'DC' in the system config feature file" do
        expect(state_abbreviation).to eq 'DC'
      end

      it "should set the namespace to :curam_integration in the system config integration file" do
        expect(namespace).to eq :curam_integration
      end
    end

    context "when client is set to ME" do
      before do
        ENV['client'] = 'ME'
        rake.invoke
      end

      it "should create the integration directory in system config" do
        expect(Dir.exist?("system/config/templates/features/integration/")).to eq true
      end

      it "should create the integration config file in system config" do
        expect(File.exist?("system/config/templates/features/integration/integration.yml")).to eq true
      end

      it "should set the state abbreviation to 'ME' in the system config feature file" do
        expect(state_abbreviation).to eq 'ME'
      end

      it "should set the namespace to :aces_integration in the system config integration file" do
        expect(namespace).to eq :aces_integration
      end
    end
  end
end
