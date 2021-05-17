# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module AptcCsr
  # This Operation is to check if all members are eligible for Medicaid
  class CheckForMedicaidEligibility
    include Dry::Monads[:result, :do]

    def call(params)
      # { tax_household: @tax_household,
      #   application: @application }
      aptc_household = yield calculate_thh_size(params)
      aptc_household = yield calculate_annual_income(aptc_household)
      aptc_household = yield calculate_fpl(aptc_household)
      aptc_household = yield compare_with_medicaid_fpl_levels(aptc_household)

      Success(aptc_household)
    end

    private

    def calculate_thh_size(params)
      @application = params[:application]
      @tax_household = params[:tax_household]

      aptc_members = @tax_household.tax_household_members.inject([]) do |members, thhm|
        applicant = applicant_by_reference(thhm.applicant_reference.person_hbx_id)
        members << { member_identifier: thhm.applicant_reference.person_hbx_id,
                     household_count: 1 + child_count(applicant),
                     tax_filer_status: applicant.tax_filer_kind,
                     is_applicant: applicant.is_applying_coverage }
        members
      end
      aptc_household = {
        members: aptc_members,
        assistance_year: @application.assistance_year,
        total_household_count: aptc_members.inject(0) { |sum, hash| sum + hash[:household_count] }
      }
      Success(aptc_household)
    end

    def child_count(applicant)
      pregnancy_info = applicant.pregnancy_information
      return 0 unless pregnancy_info.is_pregnant
      pregnancy_info.expected_children_count
    end

    def applicant_by_reference(person_hbx_id)
      @application.applicants.detect do |applicant|
        applicant.person_hbx_id.to_s == person_hbx_id.to_s
      end
    end

    def calculate_annual_income(aptc_household)
      # Compute Annual TaxHouseholdIncome here instead of MagiMedicaidEngine.
      # income = @tax_household.annual_tax_household_income
      # if income.present?
      #   Success(income)
      # else
      #   Failure("No annual_tax_household_income: #{income}, for given application with hbx_id: #{@application.hbx_id}")
      # end
      aptc_household[:annual_tax_household_income] = BigDecimal('20_000.00')
      Success(aptc_household)
    end

    def calculate_fpl(aptc_household)
      # aptc_effective_date    assistance_year        aptc     medicaid
      #   2020/11/1               2020               2020       2020
      #   2021/1/15               2021               2020       2020
      #   2021/2/1                2021               2020       2021

      # TODO: Check with Sarah related to OE/15th month of rule.
      assistance_year = @application.assistance_year
      start_date = Date.new(assistance_year, 11, 1)
      end_of_year = start_date.end_of_year
      fpl_year =
        if (start_date..end_of_year).cover?(@application.aptc_effective_date)
          assistance_year
        else
          assistance_year - 1
        end

      fpl_data = ::Types::FederalPovertyLevels.detect do |fpl_hash|
        fpl_hash[:medicaid_year] == fpl_year
      end
      total_annual_poverty_guideline = fpl_data[:annual_poverty_guideline] +
                                       ((aptc_household[:total_household_count] - 1) * fpl_data[:annual_per_person_amount])
      fpl = aptc_household[:annual_tax_household_income].div(total_annual_poverty_guideline, 2) * 100

      aptc_household[:fpl_percent] = fpl
      Success(aptc_household)
    end

    def compare_with_medicaid_fpl_levels(aptc_household)
      @tax_household.tax_household_members.each do |thhm|
        appli_identifier = thhm.applicant_reference.person_hbx_id
        mec, medicaid_fpl = medicaid_eligibility_category_and_fpl(thhm.product_eligibility_determination.magi_medicaid_category)
        aptc_household[:members].each do |aptc_member|
          if aptc_member[:member_identifier] == appli_identifier
            aptc_member.merge!({ medicaid_eligibility_category: mec,
                                 medicaid_fpl: medicaid_fpl })
          end
        end
      end

      compare_result = aptc_household[:members].any? do |member|
        aptc_household[:fpl_percent] > member[:medicaid_fpl]
      end

      aptc_household[:are_all_members_medicaid_eligible] = !compare_result
      Success(aptc_household)
    end

    def medicaid_eligibility_category_and_fpl(value)
      mec = Types::MedicaidEligibilityCategoriesMap.detect do |_mec_key, mec_value|
        mec_value[:mitc_key] == value
      end
      [mec.first, mec.second[:medicaid_fpl_percentage]]
    end

  end
end