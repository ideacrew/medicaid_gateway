# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Applications
  # Operation creates persitance application object with
  # application_identifier, application_request_payload & medicaid_request_payload
  # params only.
  class Find
    include Dry::Monads[:result, :do]

    # @param [Hash] opts The options to create application object
    # @option opts [Hash] :params Medicaid Application params
    # @return [Dry::Monads::Result]
    def call(application_identifier)
      application = yield find(application_identifier)

      Success(application)
    end

    private

    def find(application_identifier)
      Success(::Medicaid::Application.find_by!(application_identifier: application_identifier))
    rescue StandardError
      Failure("Application not found for #{application_identifier}")
    end
  end
end
