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
        if member_totally_ineligible?(applicant)
          aptc_member[:totally_ineligible] = true
        else
          aptc_member[:uqhp_eligible] = true
        end
      end

      def member_totally_ineligible?(applicant)
        applicant.incarcerated? ||
          applicant.non_citizen_and_no_lawful_presence_attestation ||
          !state_resident?(applicant)
      end

      def state_resident?(applicant)
        residential_address_in_state?(applicant) ||
          applicant.is_homeless ||
          temporarily_absent?(applicant)
      end

      def residential_address_in_state?(applicant)
        hme_address = applicant.home_address
        return false if hme_address.blank?

        hme_address.state == @application.us_state
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
