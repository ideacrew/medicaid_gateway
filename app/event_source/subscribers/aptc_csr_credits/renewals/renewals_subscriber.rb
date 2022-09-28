# frozen_string_literal: true

module Subscribers
  module AptcCsrCredits
    module Renewals
      class RenewalSubscriber
        include ::EventSource::Subscriber[amqp: 'enroll.applications.aptc_csr_credits.renewals']

        subscribe(:on_enroll_applications_aptc_csr_credits_renewals) do |delivery_info, _metadata, response|
          payload = JSON.parse(response, :symbolize_names => true)
          result = ::Eligibilities::Medicaid::RequestDetermination.new.call(payload)

          if result.success?
            ack(delivery_info.delivery_tag)
            logger.debug "renewal_subscriber_message; acked"
          else
            errors = result.failure.errors.to_h
            ack(delivery_info.delivery_tag)
            logger.debug "renewal_subscriber_message; acked (nacked) due to:#{errors}"
          end
        rescue StandardError, SystemStackError => e
          ack(delivery_info.delivery_tag)
          logger.debug "renewal_subscriber_error: baacktrace: #{e.backtrace}; acked (nacked)"
        end
      end
    end
  end
end
