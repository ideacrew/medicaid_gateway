# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  module AptcCsr
    # This class determine the aptc and csr subsidies for a given TaxHousehold
    class DetermineMemberEligibility
      include Dry::Monads[:result, :do]

      # @param [Hash] opts The options to calculate the aptc and csr subsidies
      # @option opts [AcaEntities::MagiMedicaid::TaxHoushold] :magi_medicaid_tax_household
      # @option opts [AcaEntities::MagiMedicaid::Application] :magi_medicaid_application(includes MAGI Medicaid Deteminations)
      # @return [Dry::Result]
      # Returns a hash: { magi_medicaid_application: AcaEntities::MagiMedicaid::Application, aptc_household: AptcCsr::AptcHousehold }
      def call(params)
        # params = { magi_medicaid_application: magi_medicaid_application,
        #            magi_medicaid_tax_household: magi_medicaid_tax_household }

        aptc_household = yield check_for_medicaid_eligibility(params)
        aptc_household = yield determine_eligible_members(aptc_household)
        aptc_household = yield determine_other_eligibilities(aptc_household)
        aptc_household = yield compute_csr(aptc_household)
        aptc_household_entity = yield init_aptc_household(aptc_household)
        result = yield add_determination_to_application(aptc_household_entity)

        Success(result)
      end

      private

      def check_for_medicaid_eligibility(params)
        @mm_application = params[:magi_medicaid_application]
        @mm_tax_household = params[:magi_medicaid_tax_household]

        ::Eligibilities::AptcCsr::CheckForMedicaidEligibility.new.call({ tax_household: @mm_tax_household,
                                                                         application: @mm_application })
      end

      def determine_eligible_members(aptc_household)
        ::Eligibilities::AptcCsr::DetermineEligibleMembers.new.call({ tax_household: @mm_tax_household,
                                                                      aptc_household: aptc_household,
                                                                      application: @mm_application })
      end

      def compute_csr(aptc_household)
        # Do not compute csr values if all members are ineligible for aptc/csr
        return Success(aptc_household) if all_members_are_ineligible_for_aptc_csr?(aptc_household)

        ::Eligibilities::AptcCsr::ComputeCsr.new.call({ tax_household: @mm_tax_household,
                                                        aptc_household: aptc_household,
                                                        application: @mm_application })
      end

      def all_members_are_ineligible_for_aptc_csr?(aptc_household)
        aptc_household[:members].all? { |member| member[:aptc_eligible] == false }
      end

      def all_members_are_eligible_for_magi_medicaid_or_aptc_csr?(aptc_household)
        aptc_household[:members].all? { |member| member[:aptc_eligible] || member[:magi_medicaid_eligible] }
      end

      def determine_other_eligibilities(aptc_household)
        # Do not determine Totally Ineligible & UQHP Eligible if all members are eligible for MagiMedicaid/APTC_CSR
        return Success(aptc_household) if all_members_are_eligible_for_magi_medicaid_or_aptc_csr?(aptc_household)

        ::Eligibilities::AptcCsr::DetermineOtherEligibilities.new.call({ tax_household: @mm_tax_household,
                                                                         aptc_household: aptc_household,
                                                                         application: @mm_application })
      end

      def init_aptc_household(aptc_household)
        ::Eligibilities::AptcCsr::InitAptcHousehold.new.call(aptc_household)
      end

      def add_determination_to_application(aptc_household)
        mm_application_hash = @mm_application.to_h
        mm_application_hash[:tax_households].each do |thh|
          next unless thh[:hbx_id].to_s == @mm_tax_household.hbx_id.to_s
          thh[:max_aptc] = aptc_household.maximum_aptc_amount
          thh[:effective_on] = aptc_household.eligibility_date
          thh[:annual_tax_household_income] = aptc_household.annual_tax_household_income
          thh[:yearly_expected_contribution] = aptc_household.total_expected_contribution_amount
          thh[:csr_annual_income_limit] = aptc_household.csr_annual_income_limit
          add_member_level_info(thh, aptc_household)
        end

        entity_result = ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(mm_application_hash)
        return entity_result if entity_result.failure?
        Success({ magi_medicaid_application: entity_result.success,
                  aptc_household: aptc_household })
      end

      def add_member_level_info(thh, aptc_household)
        thh[:tax_household_members].each do |thhm|
          ped = thhm[:product_eligibility_determination]
          aptc_hh_membr = aptc_household.members.detect do |aptc_mem|
            aptc_mem.member_identifier.to_s == thhm[:applicant_reference][:person_hbx_id].to_s
          end
          ped[:is_magi_medicaid] = aptc_hh_membr.magi_medicaid_eligible if ped[:is_magi_medicaid].blank?
          ped[:is_gap_filling] = aptc_hh_membr.is_gap_filling
          ped[:is_totally_ineligible] = aptc_hh_membr.totally_ineligible
          ped[:is_uqhp_eligible] = aptc_hh_membr.uqhp_eligible
          ped[:is_ia_eligible] = aptc_hh_membr.aptc_eligible
          ped[:is_csr_eligible] = aptc_hh_membr.csr_eligible
          ped[:csr] = aptc_hh_membr.csr
          ped[:member_determinations] = aptc_hh_membr.member_determinations&.map(&:to_h) || []
        end
      end
    end
  end
end
