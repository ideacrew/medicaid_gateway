# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Aces
  # Takes a raw payload, encodes it, and invokes the ACES service with it.
  class PublishRawPayload
    send(:include, Dry::Monads[:result, :do])

    # @param [String] raw_payload
    # @return [Dry::Result]
    def call(raw_payload)
      built_request = yield build_request(raw_payload)
      encoded_request = yield encode_request(built_request)
      submit_request(encoded_request)
    end

    protected

    def build_request(raw_payload)
      Aces::BuildAccountTransferRequest.new.call(raw_payload.value!)
    end

    def encode_request(request)
      Aces::EncodeAccountTransferRequest.new.call(request)
    end

    def submit_request(encoded_request)
      Aces::SubmitAccountTransferPayload.new.call(encoded_request)
    end
  end
end