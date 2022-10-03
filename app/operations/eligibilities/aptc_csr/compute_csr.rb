# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Eligibilities
  module AptcCsr
    # This Operation is to compute CSR values for each member of a given TaxHousehold
    class ComputeCsr
      include Dry::Monads[:result, :do]

      def call(params)
        # { tax_household: @tax_household,
        #   aptc_household: aptc_household,
        #   application: @application }

        aptc_household = yield calculate_expected_contribution(params)
        aptc_household = yield calculate_csr(aptc_household)
        # aptc_household = yield calculate_aptc(aptc_household)

        Success(aptc_household)
      end

      private

      def calculate_expected_contribution(params)
        @tax_household = params[:tax_household]
        @application = params[:application]
        ::Eligibilities::AptcCsr::CalculateExpectedContribution.new.call(
          { aptc_household: params[:aptc_household] }
        )
      end

      def applicant_by_reference(person_hbx_id)
        @application.applicants.detect do |applicant|
          applicant.person_hbx_id.to_s == person_hbx_id.to_s
        end
      end

      def calculate_csr(aptc_household)
        aptc_household[:members].each do |member|
          next member if member[:csr_eligible] == false
          applicant = applicant_by_reference(member[:member_identifier])
          fpl_level = aptc_household[:fpl_percent]
          csr = find_csr(applicant, fpl_level)
          member[:csr] = csr
        end

        aptc_household[:csr_annual_income_limit] = calculate_csr_annual_income_limit(aptc_household)

        Success(aptc_household)
      end

      def calculate_csr_annual_income_limit(aptc_household)
        fpl = aptc_household[:fpl]
        2.5 * (fpl[:annual_poverty_guideline] * (fpl[:annual_per_person_amount] * fpl[:household_size]))
      end

      def find_csr(applicant, fpl_level)
        if applicant.attested_for_aian?
          (fpl_level <= 300.0) ? '100' : 'limited'
        elsif fpl_level <= 150
          '94'
        elsif fpl_level > 150 && fpl_level <= 200
          '87'
        elsif fpl_level > 200 && fpl_level <= 250
          '73'
        else
          '0'
        end
      end
    end
  end
end
