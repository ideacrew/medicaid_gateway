# frozen_string_literal: true

module Subscribers
  module AptcCsrCredits
    module Renewals
      # This class is to consume renewal events
      class RenewalsSubscriber
        include ::EventSource::Subscriber[amqp: 'enroll.applications.aptc_csr_credits.renewals']

        subscribe(:on_enroll_applications_aptc_csr_credits_renewals) do |delivery_info, _metadata, response|
          subscriber_logger =
          Logger.new(
            "#{Rails.root}/log/on_enroll_applications_aptc_csr_credits_renewals_mg_#{TimeKeeper.date_of_record.strftime('%Y_%m_%d')}.log"
          )

          payload = JSON.parse(response, :symbolize_names => true)
          is_renewal = true
          result = ::Eligibilities::Medicaid::RequestDetermination.new.call(payload, is_renewal)

          if result.success?
            ack(delivery_info.delivery_tag)
            subscriber_logger.info "renewal_subscriber_message, success: app_hbx_id: #{payload[:hbx_id]}"
            logger.debug "renewal_subscriber_message; acked"
          else
            errors = result.failure.errors.to_h
            ack(delivery_info.delivery_tag)
            subscriber_logger.info "renewal_subscriber_message; acked (nacked) for app_hbx_id: #{payload[:hbx_id]}, due to #{errors}"
            logger.debug "renewal_subscriber_message; acked (nacked) due to:#{errors}"
          end
        rescue StandardError, SystemStackError => e
          ack(delivery_info.delivery_tag)
           subscriber_logger.info "renewal_subscriber_message; for app_hbx_id: #{payload[:hbx_id]} | backtrace: #{e.backtrace}; acked (nacked)"
          logger.debug "renewal_subscriber_error: baacktrace: #{e.backtrace}; acked (nacked)"
        end
      end
    end
  end
end
