# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module MitcService
  # This class is for calculating APTC and CSR values for MagiMedicaidTaxHousehold
  class CalculateAptcAndCsr
    include Dry::Monads[:result, :do]

    # @param [Hash] opts The options to calculate APTC, CSR
    # @option opts [::AcaEntities::MagiMedicaid::Application] :magi_medicaid_application
    # @option opts [::AcaEntities::MagiMedicaid::TaxHousehold] :magi_medicaid_tax_household
    # @return [Dry::Monads::Result]
    def call(params)
      # { magi_medicaid_application: @mm_application,
      #   magi_medicaid_tax_household: @mm_thh }
      fpl_percent = yield calculate_fpl(params)
      qualified_members = yield qualified_thhms_for_aptc
      aptc = yield calculate_aptc(fpl_percent, qualified_members)

      Success(aptc)
    end

    private

    def calculate_aptc(fpl_percent, qualified_members)
      input_params = { fpl_percent: fpl_percent,
                       qualified_members: qualified_members,
                       magi_medicaid_application: @mm_application,
                       magi_medicaid_tax_household: @mm_thh }
      ::MitcService::CalculateAptc.new.call(input_params)
    end

    def qualified_thhms_for_aptc
      members = @mm_thh.tax_household_members.select do |thhm|
        mm_applicant = mm_applicant_by_ref(thhm.applicant_reference.person_hbx_id)
        eligibile_for_aptc?(mm_applicant, thhm)
      end

      if members.present?
        Success(members)
      else
        Failure("No members qualify for APTC for the given TaxHousehold: #{@mm_thh.to_h}, of the MagiMedicaidApplication: #{@mm_application.to_h}")
      end
    end

    def eligibile_for_aptc?(_mm_applicant, _thhm)
      true
      # mm_applicant.is_applying_coverage &&
      # state_resident?(mm_applicant) &&
      # !mm_applicant.attestation.is_incarcerated &&
      # lawfully_present?(mm_applicant) &&
      # tax_filing?(mm_applicant) &&
      # !any_thhms_missing_income? &&
      # medicaid_or_chip_eligible?(mm_applicant, thhm) &&
      # !enrolled_in_other_coverage? &&
      # !eligibile_for_other_coverage? &&
      # any_affordable_esi? &&
      # any_ichra_not_affordable? &&
      # qshra_eligible?
    end

    def qshra_eligible?
      true
    end

    def any_ichra_not_affordable?
      true
    end

    def any_affordable_esi?
      true
    end

    def eligibile_for_other_coverage?
      false
    end

    def enrolled_in_other_coverage?
      false
    end

    def medicaid_or_chip_eligible?(_mm_applicant, _thhm)
      true
    end

    def any_thhms_missing_income?
      @mm_thh.tax_household_members.any? do |thhm|
        mm_applicant = mm_applicant_by_ref(thhm.applicant_reference.person_hbx_id)
        mm_applicant.incomes.blank?
      end
    end

    def tax_filing?(mm_applicant)
      mm_applicant.is_required_to_file_taxes ||
        mm_applicant.is_joint_tax_filing ||
        (mm_applicant.is_claimed_as_tax_dependent && applicant_claiming_has_income?(mm_applicant))
    end

    def applicant_claiming_has_income?(mm_applicant)
      claiming_applicant = mm_applicant_by_ref(mm_applicant.claimed_as_tax_dependent_by.person_hbx_id)
      claiming_applicant.incomes.present?
    end

    def lawfully_present?(mm_applicant)
      citizen_status = mm_applicant.citizenship_immigration_status_information.citizen_status
      ['us_citizen', 'naturalized_citizen', 'alien_lawfully_present', 'lawful_permanent_resident'].include?(citizen_status)
    end

    # TODO: fix below code based on configuration for state resident
    def state_resident?(mm_applicant)
      mm_applicant.addresses.any? do |addr|
        addr.state == @mm_application.us_state
      end
    end

    def mm_applicant_by_ref(mem_reference)
      @mm_application.applicants.detect do |mm_applicant|
        mm_applicant.person_hbx_id.to_s == mem_reference.to_s
      end
    end

    def calculate_fpl(params)
      @mm_application = params[:magi_medicaid_application]
      @mm_thh = params[:magi_medicaid_tax_household]
      thh_income = @mm_thh.tax_household_income

      # TODO: From where will we get the FPL information?
      # fpl_hash = ::AcaEntities::MagiMedicaid::Db::FederalPovertyLevelSeed.detect do |fpl|
      #   fpl[:medicaid_year] == magi_medicaid_application.assistance_year
      # end
      fpl_hash = { medicaid_year: 2021, annual_poverty_guideline: 12_880, annual_per_person_amount: 4_540 }
      input_params = { state_code: @mm_application.us_state,
                       household_size: @mm_thh.tax_household_members.count,
                       medicaid_year: fpl_hash[:medicaid_year],
                       annual_poverty_guideline: fpl_hash[:annual_poverty_guideline],
                       annual_per_person_amount: fpl_hash[:annual_per_person_amount] }
      # fpl_entity = ::AcaEntities::Operations::MagiMedicaid::CreateFederalPovertyLevel.new.call(input_params).success
      total_annual_poverty_guideline = input_params[:annual_poverty_guideline] +
                                       ((input_params[:household_size] - 1) * input_params[:annual_per_person_amount])
      Success((thh_income / total_annual_poverty_guideline) * 100)
    end
  end
end
