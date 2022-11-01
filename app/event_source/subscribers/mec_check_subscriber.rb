# frozen_string_literal: true

module Subscribers
  # Subscriber will receive request payload from EA
  class MecCheckSubscriber
    include ::EventSource::Subscriber[amqp: 'enroll.iap.mec_check']

    subscribe(:on_enroll_iap_mec_check) do |delivery_info, metadata, response|
      payload_type = metadata[:headers]["payload_type"]
      result = if payload_type == "person"
                 Aces::InitiateMecCheck.new.call(response)
               else
                 Aces::InitiateMecChecks.new.call(response)
               end
      if result.success?
        ack(delivery_info.delivery_tag)
        logger.debug "application_submitted_subscriber_message; acked"
      else
        error = result.failure[:error]
        if result.failure[:mc_id]
          mc_id = result.failure[:mc_id]
          mec_check = Aces::MecCheck.find(mc_id)
          mec_check.update!(failure: error)
        end
        ack(delivery_info.delivery_tag)
        logger.debug "application_submitted_subscriber_message; acked (nacked) due to: #{error}"
      end
    rescue StandardError, SystemStackError => e
      # In the case of subscriber error, saving details for reporting purposes, repurposing existing fields.
      Aces::CreateMecCheck.new.call(
        {
          application_identifier: response.to_s,
          family_identifier: result,
          type: "subscriber failure",
          failure: "Exception: '" + e.class.to_s + "' / message: " + e.to_s
        }
      )
      ack(delivery_info.delivery_tag)
      logger.debug "application_submitted_subscriber_error: backtrace: #{e.backtrace}; acked (nacked)"
    end
  end
end