# frozen_string_literal: true

module Subscribers
  # Subscriber will receive request payload from EA
  class VerificationSubscriber
    include ::EventSource::Subscriber[amqp: 'enroll.fdsh.verifications']

    subscribe(:on_enroll_fdsh_verifications) do |delivery_info, metadata, response|
      to_mec_check = metadata.to_hash.dig(:headers, "key") == "local_mec_check"
      result = Aces::InitiateMecChecks.new.call(response) if to_mec_check

      if !to_mec_check || result.success?
        ack(delivery_info.delivery_tag)
        logger.debug "verification_subscriber_message; acked"
      else
        error = result.failure[:error]
        if result.failure[:mc_id]
          mc_id = result.failure[:mc_id]
          mec_check = Aces::MecCheck.find(mc_id)
          mec_check.update!(failure: error)
        end
        nack(delivery_info.delivery_tag)
        logger.error "verification_subscriber_message; nacked due to: #{error}"
      end
    rescue StandardError => e
      # In the case of subscriber error, saving details for reporting purposes, repurposing existing fields.
      logger.error "verification_subscriber_message_error: message: #{e} backtrace: #{e.backtrace}; nacked"
      Aces::CreateMecCheck.new.call(
        {
          application_identifier: response.to_s,
          family_identifier: result,
          type: "subscriber failure",
          failure: "Exception: '#{e.class}' / message: #{e}"
        }
      )
      nack(delivery_info.delivery_tag)
    end
  end
end