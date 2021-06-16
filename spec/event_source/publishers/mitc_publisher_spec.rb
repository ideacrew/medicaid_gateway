# frozen_string_literal: true

# rubocop:disable Lint/ConstantDefinitionInBlock, Style/Documentation
require 'rails_helper'

RSpec.describe ::Publishers::MitcPublisher, dbclean: :after_each do

  module Events
    module Mitc
      class DeterminationsEval < EventSource::Event
        publisher_path 'publishers.mitc_publisher'
      end
    end
  end

  module Operations
    class MitcDetermination
      include EventSource::Command

      def execute(payload)
        event = event('events.mitc.determinations_eval', attributes: payload).success
        event.publish
      end
    end
  end

  let(:payload) { { message: "Hello world!!" } }
  let(:publish_params) do
    {
      protocol: :http,
      publish_operation_name: '/determinations/eval'
    }
  end

  let(:connection_manager_instance) { EventSource::ConnectionManager.instance }
  let(:connection) do
    connection_manager_instance.find_connection(publish_params)
  end

  let(:publish_operation) { connection_manager_instance.find_publish_operation(publish_params) }

  let(:subscribe_params) do
    {
      protocol: :http,
      subscribe_operation_name: '/on/determinations/eval'
    }
  end

  let(:subscribe_operation) { connection_manager_instance.find_subscribe_operation(subscribe_params) }

  # context "When valid event published" do 

  #   it 'should publish payload with exchange' do
  #     publish_operation
  #     subscribe_operation

  #     # Operations::MitcDetermination.new.execute(payload)

  #     # expect(bunny_exchange).to receive(:publish).at_least(1).times
  #     # Operations::DetermineEligibility.new.execute(payload)
  #   end
  # end
end
