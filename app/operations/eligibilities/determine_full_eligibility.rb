# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  # This class is for detemining the full eligibility for a MedicaidApplication
  class DetermineFullEligibility
    include Dry::Monads[:result, :do]

    # @param [Hash] opts The options to determine eligibility
    # @option opts [Hash] :medicaid_application_id MedicaidApplication identifier
    # @option opts [Hash] :medicaid_response_payload
    # @return [Dry::Monads::Result]
    def call(params)
      # { medicaid_application_id: '200000123',
      #   medicaid_response_payload: medicaid_response_payload }
      medicaid_application = yield find_medicaid_application(params)
      mm_application_entity = yield get_magi_medicaid_application(medicaid_application)
      mm_app_with_medicaid_determination = yield add_medicaid_determination_to_mm_application(mm_application_entity)
      mm_app_with_full_determination = yield determine_all_eligibilities_except_medicaid(mm_app_with_medicaid_determination)
      result = yield determine_event_name_and_publish_payload(mm_app_with_full_determination)

      # { event: event_name, payload: mm_app_with_full_determination }
      Success(result)
    end

    private

    def find_medicaid_application(params)
      @medicaid_response_payload = params[:medicaid_response_payload]
      medicaid_app = ::Medicaid::Application.where(application_identifier: params[:medicaid_application_id]).first
      medicaid_app ? Success(medicaid_app) : Failure("Unable to find Medicaid Application with given identifier: #{params[:medicaid_application_id]}")
    end

    def get_magi_medicaid_application(medicaid_application)
      @medicaid_application = medicaid_application
      mm_app_hash = JSON.parse(@medicaid_application.application_request_payload, :symbolize_names => true)
      ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(mm_app_hash)
    end

    def add_medicaid_determination_to_mm_application(mm_application_entity)
      # Based on RR configuration we have to pick the service
      update_medicaid_application_with_medicaid_response
      ::MitcService::AddMitcDeterminationToApplication.new.call({ magi_medicaid_application: mm_application_entity,
                                                                  mitc_response: @medicaid_response_payload })
    end

    def update_medicaid_application_with_medicaid_response
      @medicaid_application.update_attributes!(medicaid_response_payload: @medicaid_response_payload.to_json)
    end

    # Other eligibilities include APTC, CSR, Totally Ineligible & UQHP Eligible
    def determine_all_eligibilities_except_medicaid(mm_application)
      @result_mm_application ||= mm_application
      mm_application.tax_households.each do |mm_thh|
        # Do not determine APTC/CSR if all members are eligible for magi_medicaid/medicaid_chip eligible
        next mm_thh if all_members_are_medicaid_eligible?(mm_thh)

        result = ::Eligibilities::AptcCsr::DetermineEligibility.new.call({ magi_medicaid_application: @result_mm_application,
                                                                           magi_medicaid_tax_household: mm_thh })
        return result if result.failure?
        update_medicaid_application_with_ahs(result.success[:aptc_household])
        @result_mm_application = result.success[:magi_medicaid_application]
      end
      update_medicaid_application_with_app_response(@result_mm_application)
      Success(@result_mm_application)
    end

    def all_members_are_medicaid_eligible?(mm_thh)
      mm_thh.tax_household_members.all? do |thhm|
        ped = thhm.product_eligibility_determination
        ped.is_medicaid_chip_eligible || ped.is_magi_medicaid
      end
    end

    def update_medicaid_application_with_ahs(aptc_household_entity)
      benchmark_calculation_members = init_bcms(aptc_household_entity)
      aptc_household_members = init_ahms(aptc_household_entity)
      aptc_household = @medicaid_application.aptc_households.build
      ah_params = aptc_household_entity.to_h.except(:members, :benchmark_calculation_members)
      aptc_household.assign_attributes(ah_params)
      aptc_household.benchmark_calculation_members = benchmark_calculation_members
      aptc_household.aptc_household_members = aptc_household_members
      @medicaid_application.save!
    end

    def update_medicaid_application_with_app_response(mm_application)
      @medicaid_application.update_attributes!(application_response_payload: mm_application.to_json)
    end

    def init_bcms(aptc_household_entity)
      return [] if aptc_household_entity.benchmark_calculation_members.blank?

      aptc_household_entity.benchmark_calculation_members.inject([]) do |bcm_array, bcm_entity|
        bcm_array << ::Medicaid::BenchmarkCalculationMember.new(bcm_entity.to_h)
        bcm_array
      end
    end

    def init_ahms(aptc_household_entity)
      return [] if aptc_household_entity.members.blank?

      aptc_household_entity.members.inject([]) do |ahm_array, member_entity|
        ahm_array << ::Medicaid::AptcHouseholdMember.new(member_entity.to_h)
        ahm_array
      end
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def determine_event_name_and_publish_payload(mm_application)
      # TODO: determine the event name
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

      Eligibilities::PublishDetermination.new.call(mm_application, event_name.to_s)

      Success({ event: event_name, payload: mm_application })
    end
    # rubocop:enable Metrics/CyclomaticComplexity
  end
end

# TODO
#   1. Store magi_medicaid_request_payload, mitc_request_payload, mitc_response_payload and magi_medicaid_request_payload
#   2. Send out an event.
#   3. Log all Failure moands for finding failure cases.
#   4. Resource Registry configurations.
#   5. Member Level Determinations.
#   6. Correct MagiMedicaid/MedicaidChip Determinations.

