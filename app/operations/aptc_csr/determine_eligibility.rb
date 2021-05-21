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
      # params = { magi_medicaid_application: magi_medicaid_application,
      #            magi_medicaid_tax_household: magi_medicaid_tax_household }
      # 1. Check for Medicaid eligibility
      #  aptc_household = yield calculate_thh_size(params)
      #  aptc_household = yield calculate_annual_income(aptc_household)
      #  aptc_household = yield calculate_fpl(aptc_household)
      #  aptc_household = yield compare_with_medicaid_fpl_levels(aptc_household)
      # 2. Calculate FPL for APTC and CSR determination
      #  Already done in method calculate_fpl i.e. fpl_data
      # 3. Divide annual income by 100% of 2020 FPL for the household size
      #  Already done in method calculate_fpl i.e. the returned fpl_percentage
      # 4. Calculate expected contribution
      #  Identify expected contribution bracket
      #  Calculate exact expected contribution percentage
      #  Calculate the expected contribution

      aptc_household = yield check_for_medicaid_eligibility(params)
      aptc_household = yield determine_eligible_members(aptc_household)
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

    def determine_eligible_members(aptc_household)
      ::AptcCsr::DetermineEligibleMembers.new.call({ tax_household: @mm_tax_household,
                                                     aptc_household: aptc_household,
                                                     application: @mm_application })
    end

    def compute_aptc_and_csr(aptc_household)
      # TODO: Do not compute aptc and csr values if all members are ineligible for aptc/csr
      # return Success(aptc_household) if aptc_household[:are_all_members_medicaid_eligible]

      ::AptcCsr::ComputeAptcAndCsr.new.call({ tax_household: @mm_tax_household,
                                              aptc_household: aptc_household,
                                              application: @mm_application })
    end

    def init_aptc_household(aptc_household)
      ::AptcCsr::InitAptcHousehold.new.call(aptc_household)
    end

    def add_determination_to_application(aptc_household)
      mm_application_hash = @mm_application.to_h
      mm_application_hash[:tax_households].each do |thh|
        next unless thh[:hbx_id].to_s == @mm_tax_household.hbx_id.to_s
        thh[:max_aptc] = aptc_household.maximum_aptc_amount
        thh[:is_insurance_assistance_eligible] =
          aptc_household.aptc_calculation_members.present? ? 'Yes' : 'No'

        thh[:tax_household_members].each do |thhm|
          ped = thhm[:product_eligibility_determination]
          aptc_hh_membr = aptc_household.members.detect do |aptc_mem|
            aptc_mem.member_identifier.to_s == thhm[:applicant_reference][:person_hbx_id].to_s
          end
          ped[:is_ia_eligible] = aptc_hh_membr.aptc_eligible
          ped[:is_csr_eligible] = aptc_hh_membr.csr_eligible
          ped[:csr] = aptc_hh_membr.csr
        end
      end

      entity_result = ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(mm_application_hash)
      return entity_result if entity_result.failure?
      Success({ magi_medicaid_application: entity_result.success,
                aptc_household: aptc_household })
    end
  end
end
