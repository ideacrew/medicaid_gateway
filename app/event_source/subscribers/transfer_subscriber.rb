# frozen_string_literal: true

module Subscribers
  # Subscriber will receive request payload from EA
  class TransferSubscriber
    # TODO: enable below after eventsource initializer is updated acccordingly to acaentities async_api yml files
    include ::EventSource::Subscriber[amqp: 'enroll.iap.transfers']

    # # Account transfer request from EA is received in this subscriber
    # # headers Hash[]
    # # payload Hash[application_hash]
    # #
    # # @return [success/failure message]

    # event_source branch: release_0.5.2
    subscribe(:on_enroll_iap_transfers) do |delivery_info, _metadata, response|
      phash = JSON.parse(response)
      result = ::Transfers::ToAces.new.call(JSON.generate(phash.except("service")), phash["service"])

      if result.success?
        ack(delivery_info.delivery_tag)
        logger.debug "application_submitted_subscriber_message; acked"
      else
        errors = result.failure
        error = result.failure[:error]
        transfer_id = result.failure[:transfer_id]
        transfer = Aces::Transfer.find(transfer_id)
        transfer.update!(failure: error)
        nack(delivery_info.delivery_tag)
        logger.debug "application_submitted_subscriber_message; nacked due to:#{errors}"
      end
    rescue StandardError => e
      # In the case of subscriber error, saving details for reporting purposes, repurposing existing fields.
      Aces::Transfer.new.call(
        {
          application_identifier: response.to_s,
          family_identifier: result,
          service: "subscriber failure",
          failure: e
        }
      )
      nack(delivery_info.delivery_tag)
      logger.debug "application_submitted_subscriber_error: baacktrace: #{e.backtrace}; nacked"
    end

  end
end
