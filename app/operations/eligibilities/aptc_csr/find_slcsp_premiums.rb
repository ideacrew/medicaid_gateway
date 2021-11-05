# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

# This operation is private to Eligibilities::AptcCsr::DetermineEligibleMembers
module Eligibilities
  module AptcCsr
    # This Operation is to find the SLCSP values for a given AptcHousehold
    class FindSlcspPremiums
      include Dry::Monads[:result, :do]

      def call(params)
        # { aptc_household: aptc_household,
        #   application: @application }
        aptc_members   = yield determine_aptc_eligible_members(params)
        aptc_household = yield determine_slcsp_premiums(aptc_members)

        Success(aptc_household)
      end

      private

      def determine_aptc_eligible_members(params)
        @application = params[:application]
        @aptc_household = params[:aptc_household]

        Success(@aptc_household[:members].select { |mbr| mbr[:aptc_eligible] })
      end

      def determine_slcsp_premiums(aptc_members)
        return Success(@aptc_household) if aptc_members.blank?

        slcsp_member_premiums =
          if all_members_have_pediatric_dental_premiums?
            fetch_pediatric_dental_slcsp_premiums(aptc_members)
          else
            fetch_default_slcsp_premiums(aptc_members)
          end

        @aptc_household[:members].each do |member|
          next member unless member[:aptc_eligible]
          member[:benchmark_plan_monthly_premium_amount] = slcsp_member_premiums.detect do |m_premium|
            m_premium.member_identifier == member[:member_identifier]
          end.monthly_premium
        end

        Success(@aptc_household)
      end

      def all_members_have_pediatric_dental_premiums?
        @application.applicants.all? { |applicant| applicant&.benchmark_premium&.health_and_ped_dental_slcsp_premiums.present? }
      end

      def applicant_by_reference(person_hbx_id)
        @application.applicants.detect do |applicant|
          applicant.person_hbx_id.to_s == person_hbx_id.to_s
        end
      end

      def fetch_pediatric_dental_slcsp_premiums(aptc_members)
        if aptc_members.any? { |member| member[:age_of_applicant] < 19 }
          if aptc_members.all? { |member| member[:age_of_applicant] > 19 }
            aptc_members.inject([]) do |member_premiums, aptc_member|
              member_identifier = aptc_member[:member_identifier]
              member_premiums << applicant_by_reference(member_identifier).benchmark_premium.health_and_dental_slcsp_premiums
              member_premiums.flatten.uniq
            end
          else
            aptc_members.inject([]) do |member_premiums, aptc_member|
              member_identifier = aptc_member[:member_identifier]
              member_premiums << applicant_by_reference(member_identifier).benchmark_premium.health_and_ped_dental_slcsp_premiums
              member_premiums.flatten.uniq
            end
          end
        else
          fetch_default_slcsp_premiums(aptc_members)
        end
      end

      def fetch_default_slcsp_premiums(aptc_members)
        aptc_members.inject([]) do |member_premiums, aptc_member|
          member_identifier = aptc_member[:member_identifier]
          member_premiums << applicant_by_reference(member_identifier).benchmark_premium.health_only_slcsp_premiums
          member_premiums.flatten.uniq
        end
      end
    end
  end
end
