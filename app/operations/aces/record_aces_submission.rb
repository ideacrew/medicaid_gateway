# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Aces
  # Record the payload submitted by aces for later viewing
  class RecordAcesSubmission
    send(:include, Dry::Monads[:result, :do])

    # @param [Hash] options the options hash
    # @option options [String] :body the request body
    # @option options [String] :result the result from processing the atp result
    # @return [Dry::Result]
    def call(options)
      options[:body].rewind
      body = options[:body].read
      result = options[:result]
      Success(
        AcesAtpTestingEntry.create!(
          payload: body,
          result: result.to_s
        )
      )
    end
  end
end