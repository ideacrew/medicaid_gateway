# frozen_string_literal: true

module Subscribers
  # Subscriber will receive request payload from EA
  class ApplicationSubscriber
    # TODO: enable below after eventsource initializer is updated acccordingly to acaentities async_api yml files
    include ::EventSource::Subscriber[amqp: 'enroll.iap.applications']

    # # After application is submitted, EA request for determination is published to medicaid gateway
    # # request from EA is received in this subscriber
    # # headers Hash[]
    # # payload Hash[application_hash]
    # #
    # # @return [success/failure message]
    subscribe(:on_medicaid_gateway_enroll_iap_applications) do |_delivery_info, _metadata, payload|
      result = ::Eligibilities::Medicaid::RequestDetermination.new.call(payload)

      message = if result.success?
                  result.success
                else
                  result.failure
                end

      # TODO: log message
      puts "application_submitted_subscriber_message: #{message}"
    rescue StandardError => e
      # TODO: log error message
      puts "application_submitted_subscriber_error: #{e.backtrace}"
    end
  end
end
