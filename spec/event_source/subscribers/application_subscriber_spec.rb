require 'rails_helper'

RSpec.describe ::Subscribers::ApplicationSubscriber, dbclean: :after_each do

  module Publishers
    class DetermineEligibilityPublisher
      include ::EventSource::Publisher[amqp: 'enroll.iap.applications']

      register_event 'determine_eligibility'
    end
  end

  module Events
    module Determinations
      # Eval will register event publisher for MiTC
      class DetermineEligibility < EventSource::Event
        publisher_path 'publishers.determine_eligibility_publisher'

      end
    end
  end

  module Operations
    class DetermineEligibility
      include EventSource::Command

      def execute(payload)
        event = event('events.determinations.determine_eligibility', attributes: payload).success
        event.publish
      end
    end
  end

  let(:payload) { {message: "Hello world!!"} }
  let(:publish_params) {
    {
      protocol: :amqp,
      publish_operation_name: 'enroll.iap.applications.determine_eligibility'
    }
  }

  let(:connection_manager_instance) { EventSource::ConnectionManager.instance }
  let(:connection) { connection_manager_instance.find_connection(publish_params) }

  let(:publish_operation) { connection_manager_instance.find_publish_operation(publish_params) }
  let(:publish_proxy) { publish_operation.subject }
  let(:bunny_exchange) { publish_proxy.subject }


  let(:subscribe_params) {
    {
      protocol: :amqp,
      subscribe_operation_name: 'on_medicaid_gateway.enroll.iap.applications'
    }
  }

  let(:subscribe_operation) { connection_manager_instance.find_subscribe_operation(subscribe_params) }
  let(:queue_proxy) { subscribe_operation.subject }
  let(:bunny_queue) { queue_proxy.subject }
  let(:consumer) { queue_proxy.consumers.first }
  
  it 'should create exchanges and queues, consumers' do
    expect(bunny_exchange).to be_present 
    expect(bunny_queue).to be_present 
    expect(bunny_queue.consumer_count).to eq 1 
    expect(consumer).to be_a EventSource::Protocols::Amqp::BunnyConsumerProxy
  end

  context "When valid event published" do 

    it 'should publish payload with exchange' do
      expect(bunny_exchange).to receive(:publish).at_least(1).times
      Operations::DetermineEligibility.new.execute(payload)
    end
  end
end