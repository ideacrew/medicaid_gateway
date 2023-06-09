# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  module AptcCsr
    # This class determine if an applicant is eligible for QHP or is totally ineligible for a given TaxHousehold
    class DetermineOtherEligibilities
      include Dry::Monads[:result, :do]

      # @param [Hash] opts The options to find if an applicant is QHP eligible to totally ineligible
      # @option opts [AcaEntities::MagiMedicaid::TaxHoushold] :magi_medicaid_tax_household
      # @option opts [AcaEntities::MagiMedicaid::Application] :magi_medicaid_application
      # @option opts [Hash] :aptc_household
      # @return [Dry::Result]
      def call(params)
        # params = { tax_household: @tax_household,
        #            aptc_household: @aptc_household,
        #            application: @application }

        aptc_household = yield determine_other_eligibilities(params)
        Success(aptc_household)
      end

      private

      def determine_other_eligibilities(params)
        @tax_household = params[:tax_household]
        @aptc_household = params[:aptc_household]
        @application = params[:application]

        @aptc_household[:members].each do |aptc_member|
          applicant = applicant_by_reference(aptc_member[:member_identifier])
          next aptc_member unless applicant.is_applying_coverage
          next aptc_member if eligble_for_medicaid_or_aptc?(aptc_member)
          find_and_add_other_determination(aptc_member, applicant)
        end

        Success(@aptc_household)
      end

      def find_and_add_other_determination(aptc_member, applicant)
        totally_ineligible_reasons = member_totally_ineligible_reasons(applicant)
        if totally_ineligible_reasons.present?
          aptc_member[:totally_ineligible] = true
          te_determ = aptc_member[:member_determinations].detect {|md| md[:kind] == 'Total Ineligibility Determination' }
          te_determ[:criteria_met] = true
          te_determ[:determination_reasons] = totally_ineligible_reasons
        else
          aptc_member[:uqhp_eligible] = true
        end
      end

      def member_totally_ineligible_reasons(applicant)
        reasons = []
        reasons << :total_ineligibility_incarceration if applicant.incarcerated? && !MedicaidGatewayRegistry.feature_enabled?(:medicaid_eligible_incarcerated)
        reasons << :total_ineligibility_no_lawful_presence if applicant.non_citizen_and_no_lawful_presence_attestation
        reasons << :total_ineligibility_no_state_residency if state_residency_requirement_not_met?(applicant)
        reasons
      end

      def state_residency_requirement_not_met?(applicant)
        is_non_filer = applicant.tax_filer_kind == 'non_filer'
        return false if is_non_filer && residential_address_in_state?(applicant)
        !tax_filer_is_state_resident?
      end

      def state_resident?(applicant)
        residential_address_in_state?(applicant) ||
          applicant.is_homeless ||
          temporarily_absent?(applicant)
      end

      # any member of the tax household may enroll in a QHP through any of the Exchanges for which one of the tax filers meets the residency standard
      def tax_filer_is_state_resident?
        tax_filer_applicants.any? {|applicant| residential_address_in_state?(applicant)}
      end

      def tax_filer_applicants
        @tax_household.tax_household_members.each_with_object([]) do |thhm, filers|
          member_identifier = thhm.applicant_reference.person_hbx_id
          applicant = applicant_by_reference(member_identifier)
          filers << applicant if applicant.tax_filer_kind == "tax_filer"
        end
      end

      def residential_address_in_state?(applicant)
        home_address = applicant.home_address
        return false if home_address.blank?

        home_address.state == @application.us_state
      end

      def temporarily_absent?(applicant)
        applicant.is_temporarily_out_of_state
      end

      # Checks if member is eligible for magi_medicaid, medicaid_chip or aptc
      def eligble_for_medicaid_or_aptc?(aptc_member)
        return true if aptc_member[:aptc_eligible] || aptc_member[:magi_medicaid_eligible]
        ped = find_matching_ped(aptc_member[:member_identifier])
        ped.is_magi_medicaid || ped.is_medicaid_chip_eligible
      end

      def applicant_by_reference(member_identifier)
        @application.applicants.detect do |applicant|
          applicant.person_hbx_id.to_s == member_identifier.to_s
        end
      end

      def find_matching_ped(member_identifier)
        @tax_household.tax_household_members.detect do |thhm|
          thhm.applicant_reference.person_hbx_id.to_s == member_identifier.to_s
        end&.product_eligibility_determination
      end
    end
  end
end
