# frozen_string_literal: true

module Subscribers
  # Subscriber will receive response payload from EA with SLCSP information.
  class SlcspDeterminedSubscriber
    include ::EventSource::Subscriber[amqp: 'enroll.iap.benchmark_products']

    # subscribe(:on_enroll_iap_benchmark_products) do |delivery_info, _metadata, response|
    subscribe(:on_slcsp_determined) do |delivery_info, _metadata, response|
      logger.info "on_slcsp_determined: response: #{response}"
      subscriber_logger = subscriber_logger_for(:on_slcsp_determined)
      payload = JSON.parse(response, symbolize_names: true)
      logger.info "on_slcsp_determined: payload: #{payload}"
      subscriber_logger.info "on_slcsp_determined: payload: #{payload}"

      process_slcsp_determined_event(subscriber_logger, payload) unless Rails.env.test?

      ack(delivery_info.delivery_tag)
    rescue StandardError, SystemStackError => e
      logger.info "on_slcsp_determined: error: #{e} backtrace: #{e.backtrace}; acked (nacked)"
      ack(delivery_info.delivery_tag)
    end

    private

    def process_slcsp_determined_event(subscriber_logger, payload)
      subscriber_logger.info "process_slcsp_determined_event: ------- start"
      result = ::ProcessSubscriberResponses::SlcspDetermined.new.call(payload)

      if result.success?
        message = result.success
        subscriber_logger.info "on_slcsp_determined: acked #{message.is_a?(Hash) ? message[:event] : message}"
      else
        err_messages = if result.failure.is_a?(Dry::Validation::Result)
                         result.failure.errors.to_h
                       else
                         result.failure
                       end
        subscriber_logger.info "process_slcsp_determined_event: failure: #{err_messages}"
      end
      subscriber_logger.info "process_slcsp_determined_event: ------- end"
    rescue StandardError => e
      subscriber_logger.info "process_slcsp_determined_event: error: #{e} backtrace: #{e.backtrace}"
      subscriber_logger.info "process_slcsp_determined_event: ------- end"
    end

    def subscriber_logger_for(event)
      Logger.new("#{Rails.root}/log/#{event}_#{Date.today.in_time_zone('Eastern Time (US & Canada)').strftime('%Y_%m_%d')}.log")
    end
  end
end
