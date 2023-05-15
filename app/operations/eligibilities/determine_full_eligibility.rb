# frozen_string_literal: true

require "dry/monads"
require "dry/monads/do"

module Eligibilities
  # This class is for detemining the full eligibility for a MedicaidApplication
  class DetermineFullEligibility
    include Dry::Monads[:result, :do]

    # @param [Hash] opts The options to determine eligibility
    # @option opts [Hash] :medicaid_application_id MedicaidApplication identifier
    # @option opts [Hash] :medicaid_response_payload
    # @return [Dry::Monads::Result]
    def call(params)
      medicaid_application = yield find_medicaid_application(params)
      mm_application_entity = yield get_magi_medicaid_application(medicaid_application)
      mm_app_with_medicaid_determination = yield add_medicaid_determination_to_mm_application(mm_application_entity)
      mm_app_with_eligibility_overrides = yield apply_eligibility_overrides(mm_app_with_medicaid_determinations)
      mm_app_with_member_determinations = yield determine_member_eligibilities(mm_app_with_eligibility_overrides)
      result = yield compute_aptcs_and_publish(mm_app_with_member_determinations)

      Success(result)
    end

    private

    def find_medicaid_application(params)
      @medicaid_response_payload = params[:medicaid_response_payload]
      medicaid_app = ::Medicaid::Application.where(application_identifier: params[:medicaid_application_id]).last
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

    def apply_eligibility_overrides(mm_application_entity)
      ::Eligibilities::AptcCsr::ApplyEligibilityOverrides.new.call({ magi_medicaid_application: mm_application_entity })
    end

    # Eligibilities include MagiMedicaid, APTC, CSR, Totally Ineligible & UQHP Eligible
    def determine_member_eligibilities(mm_application)
      @result_mm_application ||= mm_application
      mm_application.tax_households.each do |mm_thh|
        # Do not determine APTC/CSR if all members are ineligible
        next mm_thh if all_members_are_aptc_csr_ineligible?(mm_thh)

        result = ::Eligibilities::AptcCsr::DetermineMemberEligibility.new.call({ magi_medicaid_application: @result_mm_application,
                                                                                 magi_medicaid_tax_household: mm_thh })
        return result if result.failure?
        update_medicaid_application_with_ahs(result.success[:aptc_household])
        @result_mm_application = result.success[:magi_medicaid_application]
      end
      Success(@result_mm_application)
    end

    # Compute APTC and Publish
    def compute_aptcs_and_publish(mm_application)
      ::Eligibilities::AptcCsr::ComputeAptcsAndPublish.new.call({ magi_medicaid_application: mm_application })
    end

    def all_members_are_aptc_csr_ineligible?(mm_thh)
      mm_thh.tax_household_members.all? do |thhm|
        # Applicant is APTC/CSR ineligible if:
        # magi_medicaid/medicaid_chip eligible
        # incarcerated
        ped = thhm.product_eligibility_determination
        ped.is_medicaid_chip_eligible || ped.is_magi_medicaid || ped.chip_ineligibility_reasons&.include?("Applicant is incarcerated")
      end
    end

    # ahs: AptcHouseholds
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
  end
end
