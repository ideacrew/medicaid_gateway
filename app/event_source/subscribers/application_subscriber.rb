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

    # event_source branch: release_0.5.2
    subscribe(:on_enroll_iap_applications) do |delivery_info, _metadata, response|
      payload = JSON.parse(response, :symbolize_names => true)
      benchmark_measure = Benchmark.measure do
        @result = ::Eligibilities::Medicaid::RequestDetermination.new.call(payload)
      end

      logger.info "TimeNow: #{Time.now}, benchmark_measure: #{benchmark_measure} application_hbx_id: #{payload[:hbx_id]}, ApplicationSubscriber"

      if @result.success?
        ack(delivery_info.delivery_tag)
        logger.debug "application_submitted_subscriber_message; acked"
      else
        errors = @result.failure.errors.to_h
        ack(delivery_info.delivery_tag)
        logger.debug "application_submitted_subscriber_message; acked (nacked) due to:#{errors}"
      end
    rescue StandardError, SystemStackError => e
      ack(delivery_info.delivery_tag)
      logger.debug "application_submitted_subscriber_error: baacktrace: #{e.backtrace}; acked (nacked)"
    end
  end
end
