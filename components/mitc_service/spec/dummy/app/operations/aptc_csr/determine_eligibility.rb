# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module AptcCsr
  # This class determine the aptc and csr subsidies for a given TaxHousehold
  class DetermineEligibility
    include Dry::Monads[:result, :do]

    # @param [Hash] opts The options to calculate the aptc and csr subsidies
    # @option opts [AcaEntities::MagiMedicaid::TaxHoushold] :magi_medicaid_tax_household
    # @option opts [AcaEntities::MagiMedicaid::Application] :magi_medicaid_application(includes MAGI Medicaid Deteminations)
    # @return [Dry::Result]
    # Returns a hash: { magi_medicaid_application: AcaEntities::MagiMedicaid::Application, aptc_household: AptcCsr::AptcHousehold }
    def call(params)
      aptc_household = yield check_for_medicaid_eligibility(params)
      aptc_household = yield compute_aptc_and_csr(aptc_household)
      aptc_household_entity = yield init_aptc_household(aptc_household)
      result = yield add_determination_to_application(aptc_household_entity)

      Success(result)
    end

    private

    def check_for_medicaid_eligibility(params)
      @mm_application = params[:magi_medicaid_application]
      @mm_tax_household = params[:magi_medicaid_tax_household]

      ::AptcCsr::CheckForMedicaidEligibility.new.call({ tax_household: @mm_tax_household,
                                                        application: @mm_application })
    end

    def init_aptc_household(aptc_household)
      ::AptcCsr::InitAptcHousehold.new.call(aptc_household)
    end

    def compute_aptc_and_csr(aptc_household)
      ::AptcCsr::ComputeAptcAndCsr.new.call({ tax_household: @mm_tax_household,
                                              aptc_household: aptc_household,
                                              application: @mm_application })
    end

    def add_determination_to_application(aptc_household)
      mm_application_hash = @mm_application.to_h
      mm_application_hash[:tax_households].each do |thh|
        next unless thh[:hbx_id].to_s == @mm_tax_household.hbx_id.to_s
        thh[:max_aptc] = aptc_household.maximum_aptc_amount
        thh[:csr] = aptc_household.csr_percentage
        thh[:tax_household_members].each do |thhm|
          ped = thhm[:product_eligibility_determination]
          matching_member = aptc_household.aptc_calculation_members.detect do |member|
            member.member_identifier.to_s == thhm[:applicant_reference][:person_hbx_id]
          end
          ped[:is_ia_eligible] = matching_member.present?
        end
      end

      entity_result = ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(mm_application_hash)
      return entity_result if entity_result.failure?
      Success({ magi_medicaid_application: entity_result.success,
                aptc_household: aptc_household })
    end
  end
end
