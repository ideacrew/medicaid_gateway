# frozen_string_literal: true

module Subscribers
  # Subscriber will receive response payload from mitc and perform validation along with persisting the payload
  class MitcResponseSubscriber
    include ::EventSource::Subscriber[http: '/determinations/eval']
    extend EventSource::Logging

    # From medicaid_gateway request is published to mitc from call_magi_in_the_cloud operation
    # Response from mitc is received in this subscriber
    # headers: Hash contains correlation id
    # response Hash[determination_hash] contains determination from mitc
    #
    # @return [success/failure message]
    subscribe(:on_determinations_eval) do |body, status, headers|
      @subscriber_logger = Logger.new(
        File.join(Rails.root, 'log', "mitc_response_subscriber_#{Date.today.strftime('%Y_%m_%d')}.log")
      )
      @subscriber_logger.info '-' * 100
      @subscriber_logger.info "MitcResponseSubscriber#on_determinations_eval body: #{body}, status: #{status}, headers: #{headers}"

      logger.info "MitcResponseSubscriber#on_determinations_eval body: #{body}, status: #{status}, headers: #{headers}"
      correlation_id = headers["CorrelationID"]
      persist(body, correlation_id)
    end

    def self.persist(response, correlation_id)
      logger.info "MitcResponseSubscriber response: #{response}, response_class: #{response.class}"
      params = { medicaid_application_id: correlation_id, medicaid_response_payload: response }

      @subscriber_logger.info "MitcResponseSubscriber#persist params: #{params}"

      result = Eligibilities::DetermineFullEligibility.new.call(params.deep_symbolize_keys!)

      @subscriber_logger.info "MitcResponseSubscriber#persist result: #{result.inspect}"

      message = if result.success?
                  result.success
                else
                  result.failure
                end
      # TODO: log message
      logger.info "mitc_response_subscriber_message: #{message.is_a?(Hash) ? message[:event] : message}"
    rescue StandardError => e
      # TODO: log error message
      logger.error "mitc_response_subscriber_error: #{e} backtrace: #{e.backtrace}"
    end
  end
end
