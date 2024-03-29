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
      transfer = delivery_info.routing_key == "enroll.iap.transfers.transfer_account"
      phash = JSON.parse(response, symbolize_names: true)

      result = if transfer
                 ::Transfers::ToService.new.call(JSON.generate(phash.except(:service)))
               else
                 ::Transfers::AddEnrollResponse.new.call(phash)
               end

      if result.success?
        ack(delivery_info.delivery_tag)
        logger.debug "transfer_subscriber_message; acked"
      else
        errors = result.failure
        error = result.failure[:failure]
        if transfer
          transfer_id = result.failure[:transfer_id]
          outbound_transfer = Aces::Transfer.find(transfer_id)
          outbound_transfer.update!(failure: error)
        end
        ack(delivery_info.delivery_tag)
        logger.error "transfer_subscriber_message; acked (nacked) due to:#{errors}"
      end
    rescue StandardError => e
      # In the case of subscriber error, saving details for reporting purposes, repurposing existing fields.
      logger.error "transfer_subscriber_message_error message: #{e} backtrace: #{e.backtrace}; acked (nacked)"
      if transfer
        Aces::Transfer.create(
          {
            application_identifier: response&.to_s,
            family_identifier: result&.to_s,
            service: "subscriber failure",
            failure: "Exception: '#{e.class}' / message: #{e}"
          }
        )
      else
        ib_transfer_id = phash[:transfer_id]
        inbound_transfer = Aces::InboundTransfer.where(external_id: ib_transfer_id).last
        inbound_transfer&.update!(failure: true)
      end
      ack(delivery_info.delivery_tag)
    end
  end
end
