# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  module Medicaid
    # This class is for requesting the medicaid determination for all the Applicants.
    class DeterminationError
      include Dry::Monads[:result, :do]
      include EventSource::Command

      # @param [Hash] opts The options to request medicaid determination
      # @option opts [Hash] :params MagiMedicaid Application request payload
      # @return [Dry::Monads::Result]
      def call(failure, payload)
        @application = yield init_or_find_magi_medicaid_application(payload)
        error_message = yield build_and_log_error_message(failure)
        yield publish_error(error_message)

        Success(@application)
      end

      private

      def publish_event(error_message)
        event("events.determinations.error",
              attributes: { error: error_message }
        ).publish
      end

      # We need to find the app that may have already been created or
      # if the error occured prior to creation we'll create a new one ourselves
      def init_or_find_magi_medicaid_application(payload)
        application_identifier = payload[:hbx_id]
        existing_application = ::Applications::Find.new.call(application_identifier)

        if existing_application
          Success(existing_application)
        else
          Success(::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(payload))
        end
      end

      def build_and_log_error_message(failure)
        case failure
        when Dry::Validation::Result
          error = validation_errors_parser(failure)
          log_failure(error)
          error
        when Exception
          log_exception(failure)
          failure.message
        else
          log_failure(failure)
          "Submission Error: #{failure}"
        end
      end

      def log_exception(exception)
        @application.update exception: {
          message: exception.message,
          backtrace: exception.backtrace
        } || Rails.logger.warn("Couldn't log exception #{exception} with #{@application}")
      end

      def log_failure(failure)
        @application.update(failure: failure) ||
          Rails.logger.warn("Couldn't log failure #{failure} with #{@application}")
      end

      # TODO: this is not a great parser and could use improvements
      def validation_errors_parser(failure)
        failure.errors.each_with_object([]) do |error, collect|
          collect << if error.is_a?(Dry::Schema::Message)
                       message = error.path.reduce("The ") do |attribute_message, path|
                         next_element = error.path[(error.path.index(path) + 1)]
                         attribute_message + if next_element.is_a?(Integer)
                                               "#{(next_element + 1).ordinalize} #{path.to_s.humanize.downcase}'s "
                                             elsif path.is_a? Integer
                                               ""
                                             else
                                               "#{path.to_s.humanize.downcase}:"
                                             end
                       end
                       message + " #{error.text}."
                     else
                       error.flatten.flatten.join(',').gsub(",", " ").titleize
                     end
        end
      end
    end
  end
end
