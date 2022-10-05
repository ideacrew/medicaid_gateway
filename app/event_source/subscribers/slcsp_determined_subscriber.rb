# frozen_string_literal: true

module Subscribers
  # Subscriber will receive response payload from EA with SLCSP information.
  class SlcspDeterminedSubscriber
    include ::EventSource::Subscriber[amqp: 'enroll.iap.benchmark_products']

    # subscribe(:on_enroll_iap_benchmark_products) do |delivery_info, _metadata, response|
    subscribe(:on_slcsp_determined) do |delivery_info, _metadata, response|
      payload = JSON.parse(response, :symbolize_names => true)
      logger.debug "on_enroll_iap_benchmark_products: payload: #{payload}"
      # result = ::Eligibilities::Medicaid::RequestDetermination.new.call(payload)

      if result.success?
        logger.debug "on_enroll_iap_benchmark_products: acked"
      else
        errors = result.failure.errors.to_h
        logger.debug "on_enroll_iap_benchmark_products: acked (nacked) due to:#{errors}"
      end
      ack(delivery_info.delivery_tag)
    rescue StandardError, SystemStackError => e
      logger.debug "on_enroll_iap_benchmark_products: error backtrace: #{e.backtrace}; acked (nacked)"
      ack(delivery_info.delivery_tag)
    end
  end
end
