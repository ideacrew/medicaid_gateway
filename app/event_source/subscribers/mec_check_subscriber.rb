# frozen_string_literal: true

module Subscribers
  # Subscriber will receive request payload from EA
  class MecCheckSubscriber
    include ::EventSource::Subscriber[amqp: 'enroll.iap.mec_check']

    subscribe(:on_enroll_iap_mec_check) do |delivery_info, metadata, response|
      payload_type = metadata[:headers]["payload_type"]
      transmittable_data = metadata[:headers]["transmittable_data"]
      # In future all the incoming calls would be processed through Transmittable.
      # At that point we could get rid of explicit naming 'transmittable_data' in headers
      result = if transmittable_data.present? && payload_type == "application"
                 params = { payload: response, message_id: transmittable_data["message_id"] }
                 MecCheck::InitiateApplicationMecChecks.new.call(params)
               elsif payload_type == "person"
                 Aces::InitiateMecCheck.new.call(response)
               else
                 Aces::InitiateMecChecks.new.call(response)
               end
      if result.success?
        ack(delivery_info.delivery_tag)
        logger.debug "mec_check_subscriber_message; acked"
      else
        error = result.failure[:error]
        if result.failure[:mc_id]
          mc_id = result.failure[:mc_id]
          mec_check = Aces::MecCheck.find(mc_id)
          mec_check.update!(failure: error)
        end
        ack(delivery_info.delivery_tag)
        logger.error "mec_check_subscriber_message; acked (nacked) due to: #{error}"
      end
    rescue StandardError, SystemStackError => e
      # In the case of subscriber error, saving details for reporting purposes, repurposing existing fields.
      logger.error "mec_check_subscriber_message message: #{e} backtrace: #{e.backtrace}; acked (nacked)"
      Aces::CreateMecCheck.new.call(
        {
          application_identifier: response.to_s,
          family_identifier: result,
          type: "subscriber failure",
          failure: "Exception: '#{e.class}' / message: #{e}"
        }
      )
      ack(delivery_info.delivery_tag)
    end
  end
end
