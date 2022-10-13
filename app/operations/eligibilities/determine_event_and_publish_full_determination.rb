# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  # DetermineEventAndPublishFullDetermination will publish financial assistance determination event
  # Event is determined based on the member determinations of all the tax households of the application
  # Input application should always be a fully determined application.
  # Fully Determined Application is an application with both member and tax_household determinations.
  class DetermineEventAndPublishFullDetermination
    include EventSource::Command
    include Dry::Monads[:result, :do]
    include EventSource::Logging

    # @option opts [AcaEntities::MagiMedicaid::Application] :mm_application
    # @return [Dry::Monads::Result]
    def call(mm_application, is_renewal = nil)
      event_name = yield determine_event(mm_application)
      event      = yield build_event(mm_application, event_name, is_renewal)
      _result    = yield publish_event(event)

      Success({ event: event_name, payload: mm_application })
    end

    private

    # rubocop:disable Metrics/CyclomaticComplexity
    def determine_event(mm_application)
      peds = mm_application.tax_households.flat_map(&:tax_household_members).map(&:product_eligibility_determination)

      event_name =
        if peds.all?(&:is_ia_eligible)
          :aptc_eligible
        elsif peds.all?(&:is_medicaid_chip_eligible)
          :medicaid_chip_eligible
        elsif peds.all?(&:is_totally_ineligible)
          :totally_ineligible
        elsif peds.all?(&:is_magi_medicaid)
          :magi_medicaid_eligible
        elsif peds.all?(&:is_uqhp_eligible)
          :uqhp_eligible
        else
          :mixed_determination
        end

      Success(event_name)
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def build_event(app, event_name, is_renewal)
      event_key = "determined_#{event_name}"
      if is_renewal.present?
        result = event("events.magi_medicaid.applications.aptc_csr_credits.renewals.#{event_key}", attributes: app.to_h)
        logger.info "MedicaidGateway Reponse Publisher to enroll, event_key: #{event_key}, attributes: #{app.to_h}, result: #{result}"
      else
        result = event("events.magi_medicaid.mitc.eligibilities.#{event_key}", attributes: app.to_h)
        logger.info "MedicaidGateway Reponse Publisher to enroll & polypress, event_key: #{event_key}, attributes: #{app.to_h}, result: #{result}"
      end

      logger.info('-' * 100)
      result
    end

    def publish_event(event)
      event.publish
      Success('Successfully published payload')
    end
  end
end
