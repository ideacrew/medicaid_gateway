# frozen_string_literal: true

module Subscribers
  # Subscriber will receive response payload from EA with SLCSP information.
  class SlcspDeterminedSubscriber
    include ::EventSource::Subscriber[amqp: 'enroll.iap.benchmark_products']

    # subscribe(:on_enroll_iap_benchmark_products) do |delivery_info, _metadata, response|
    subscribe(:on_slcsp_determined) do |delivery_info, _metadata, response|
      payload = JSON.parse(response, :symbolize_names => true)
      logger.info "on_slcsp_determined: payload: #{payload}"
      result = ::ProcessSubscriberResponses::SlcspDetermined.new.call(payload)

      if result.success?
        message = result.success
        logger.info "on_slcsp_determined: acked #{message.is_a?(Hash) ? message[:event] : message}"
      else
        errors = result.failure.errors.to_h
        logger.info "on_slcsp_determined: acked (nacked) due to:#{errors}"
      end
      ack(delivery_info.delivery_tag)
    rescue StandardError, SystemStackError => e
      logger.info "on_slcsp_determined: error: #{e} backtrace: #{e.backtrace}; acked (nacked)"
      ack(delivery_info.delivery_tag)
    end
  end
end
