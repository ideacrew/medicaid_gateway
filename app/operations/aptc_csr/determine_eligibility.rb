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
    # @return [Dry::Result<AcaEntities::MagiMedicaid::Application>]
    def call(params)
      tax_household_size = yield calculate_thh_size(params)
      tax_household_income = yield calculate_annual_income
      fpl = yield calculate_fpl(tax_household_income, tax_household_size)
      eligibility = yield compare_with_medicaid_fpl_levels(fpl)
      result = yield response_hash(eligibility, fpl)

      Success(result)
    end

    private

    def calculate_thh_size(params)
      @mm_application = params[:magi_medicaid_application]
      @mm_tax_household = params[:magi_medicaid_tax_household]
      total_count = @mm_tax_household.tax_household_members.inject(0) do |count, thhm|
        count + 1 + child_count(thhm)
      end

      Success(total_count)
    end

    def child_count(thhm)
      applicant = mm_applicant_by_ref(thhm.applicant_reference.person_hbx_id)
      pregnancy_info = applicant.pregnancy_information
      return 0 unless pregnancy_info.is_pregnant

      pregnancy_info.expected_children_count
    end

    def mm_applicant_by_ref(person_hbx_id)
      @mm_application.applicants.detect do |applicant|
        applicant.person_hbx_id.to_s == person_hbx_id.to_s
      end
    end

    def calculate_annual_income
      income = @mm_tax_household.annual_tax_household_income
      if income.present?
        Success(income)
      else
        Failure("No annual_tax_household_income: #{income}, for given application with hbx_id: #{@mm_application.hbx_id}")
      end
    end

    def calculate_fpl(tax_household_income, tax_household_size)
      fpl_data = ::Types::FederalPovertyLevels.detect do |fpl_hash|
        fpl_hash[:medicaid_year] == @mm_application.assistance_year
      end
      total_annual_poverty_guideline = fpl_data[:annual_poverty_guideline] +
                                       ((tax_household_size - 1) * fpl_data[:annual_per_person_amount])
      Success(tax_household_income.div(total_annual_poverty_guideline, 2) * 100)
    end

    def compare_with_medicaid_fpl_levels(fpl)
      result = @mm_tax_household.tax_household_members.any? do |thhm|
        applicant = mm_applicant_by_ref(thhm.applicant_reference.person_hbx_id)

        medicaid_fpl = if pregnant_women?(applicant) || child_under_19?(applicant)
                         324
                       elsif child_aged_btw_19_and_20?(applicant) || parent_or_caretaker?(applicant)
                         221
                       elsif adults_without_children_aged_btw_21_and_64?(applicant)
                         215
                       else
                         0
                       end

        fpl > medicaid_fpl
      end

      Success(result)
    end

    def child_under_19?(applicant)
      child?(applicant) && applicant.age_of_applicant < 19
    end

    def pregnant_women?(applicant)
      applicant.demographic.gender == 'Female' && applicant.pregnancy_information.is_pregnant
    end

    def child_aged_btw_19_and_20?(applicant)
      child?(applicant) && (19..20).include?(applicant.age_of_applicant)
    end

    def adults_without_children_aged_btw_21_and_64?(applicant)
      any_rel = @mm_application.applicant_relationships(applicant).any? do |rel|
        rel.kind == 'parent'
      end
      # return false if there are any parent relationships
      return !any_rel if any_rel
      (21..64).include?(applicant)
    end

    def parent_or_caretaker?(applicant)
      @mm_application.applicant_relationships(applicant).any? do |rel|
        # Caretaker relationship is not included in AcaEntities::MagiMedicaid::Types::RelationshipKind yet.
        ['parent'].include?(rel.kind)
      end
    end

    def child?(applicant)
      relationship_to_primary(applicant).to_s == 'child'
    end

    def relationship_to_primary(applicant)
      @mm_application.relationship_kind(applicant, @mm_application.primary_applicant)
    end

    def response_hash(eligibility, fpl)
      Success({ aptc_eligible: eligibility, tax_household_fpl: fpl })
    end
  end
end
