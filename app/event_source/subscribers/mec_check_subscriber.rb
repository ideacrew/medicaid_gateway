# frozen_string_literal: true

module Subscribers
  # Subscriber will receive request payload from EA
  class MecCheckSubscriber
    include ::EventSource::Subscriber[amqp: 'enroll.iap.mec_check']

    subscribe(:on_enroll_iap_mec_check) do |delivery_info, _metadata, response|
      result = Aces::InitiateMecCheck.new.call(response)      
      if result.success?
        ack(delivery_info.delivery_tag)
        logger.debug "application_submitted_subscriber_message; acked"
      else
        byebug
        mc_id = result.failure.value!.mc_id
        error = result.failure.value!.error
        unless error.include?("Failed to save MEC check")
          mec_check = Aces::MecCheck.find(mc_id)
          mec_check.update!(failure: error)
        end
        nack(delivery_info.delivery_tag)
        logger.debug "application_submitted_subscriber_message; nacked due to:#{error}"
      end
    rescue StandardError => e
      nack(delivery_info.delivery_tag)
      logger.debug "application_submitted_subscriber_error: backtrace: #{e.backtrace}; nacked"
    end
  end
end