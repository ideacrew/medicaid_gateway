# frozen_string_literal: true

require "rails_helper"
require File.join(Rails.root, "spec/shared_contexts/eligibilities/magi_medicaid_application_data")

describe Eligibilities::AptcCsr::ApplyEligibilityOverrides do
  let(:current_date) { Date.today }
  let(:citizenship_immigration_status_information2) do
    { citizen_status: "not_lawfully_present_in_us",
      is_lawful_presence_self_attested: false }
  end
  include_context "setup magi_medicaid application with two applicants"
  context "with applicant over 18 not lawfully present" do
    let(:product_eligibility_determination2) do
      { is_ia_eligible: false,
        is_medicaid_chip_eligible: false,
        is_non_magi_medicaid_eligible: false,
        is_totally_ineligible: false,
        is_without_assistance: false,
        is_magi_medicaid: false,
        magi_medicaid_monthly_household_income: 6474.42,
        medicaid_household_size: 1,
        magi_medicaid_monthly_income_limit: 3760.67,
        magi_as_percentage_of_fpl: 10.0,
        magi_medicaid_category: "parent_caretaker",
        magi_medicaid_ineligibility_reasons: ["Applicant did not meet citizenship/immigration requirements"] }
    end

    context "with applicant 21 or over" do
      let(:input_application) do
        app_params = mm_application_entity.to_h
        app_params[:applicants].first[:age_of_applicant] = 21
        app_params[:applicants].first[:citizenship_immigration_status_information] = citizenship_immigration_status_information2
        app_params[:tax_households].first[:tax_household_members].first[:product_eligibility_determination] = product_eligibility_determination2
        ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
      end

      let(:input_params) do
        { magi_medicaid_application: input_application }
      end

      before do
        @result = subject.call(input_params)
      end

      it "should return success" do
        expect(@result).to be_success
      end

      it "should return a MagiMedicaidApplication entity" do
        expect(@result.success).to be_a(::AcaEntities::MagiMedicaid::Application)
      end

      it "should not return medicaid eligible" do
        expect(@result.success.tax_households.first.tax_household_members.first.product_eligibility_determination.is_magi_medicaid).to eq(false)
      end
    end
    context "with pregnant applicant 21 or over" do
      let(:pregnancy_information2) do
        { is_pregnant: true,
          is_post_partum_period: false,
          expected_children_count: 1,
          pregnancy_due_on: Date.today.next_month }
      end
      let(:input_application) do
        app_params = mm_application_entity.to_h
        app_params[:applicants].first[:pregnancy_information] = pregnancy_information2
        app_params[:applicants].first[:age_of_applicant] = 21
        app_params[:applicants].first[:citizenship_immigration_status_information] = citizenship_immigration_status_information2
        app_params[:tax_households].first[:tax_household_members].first[:product_eligibility_determination] = product_eligibility_determination2
        ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
      end

      let(:input_params) do
        { magi_medicaid_application: input_application }
      end

      before do
        pregnant_override_flag = MedicaidGatewayRegistry[:eligibility_override].setting(:mitc_override_not_lawfully_present_pregnant)
        allow(pregnant_override_flag).to receive(:item).and_return("true")
        @result = subject.call(input_params)
      end

      it "should return success" do
        expect(@result).to be_success
      end

      it "should return a MagiMedicaidApplication entity" do
        expect(@result.success).to be_a(::AcaEntities::MagiMedicaid::Application)
      end

      it "should return medicaid eligible" do
        expect(@result.success.tax_households.first.tax_household_members.first.product_eligibility_determination.is_magi_medicaid).to eq(true)
      end
    end
    context "with applicant 19-20 and not pregnant" do
      let(:input_application) do
        app_params = mm_application_entity.to_h
        app_params[:applicants].first[:age_of_applicant] = 19
        app_params[:applicants].first[:citizenship_immigration_status_information] = citizenship_immigration_status_information2
        app_params[:tax_households].first[:tax_household_members].first[:product_eligibility_determination] = product_eligibility_determination2
        ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
      end

      let(:input_params) do
        { magi_medicaid_application: input_application }
      end

      before do
        under_twenty_one_override_flag = MedicaidGatewayRegistry[:eligibility_override].setting(:mitc_override_not_lawfully_present_under_twenty_one)
        allow(under_twenty_one_override_flag).to receive(:item).and_return("true")
        @result = subject.call(input_params)
      end

      it "should return medicaid eligible" do
        expect(@result.success.tax_households.first.tax_household_members.first.product_eligibility_determination.is_magi_medicaid).to eq(true)
      end
    end

    context "with applicant not lawfully present and 18 or under" do
      let(:product_eligibility_determination3) do
        { is_ia_eligible: false,
          is_medicaid_chip_eligible: false,
          is_non_magi_medicaid_eligible: false,
          is_totally_ineligible: false,
          is_without_assistance: false,
          is_magi_medicaid: false,
          magi_medicaid_monthly_household_income: 6474.42,
          medicaid_household_size: 1,
          magi_medicaid_monthly_income_limit: 3760.67,
          magi_as_percentage_of_fpl: 10.0,
          magi_medicaid_category: "parent_caretaker",
          chip_ineligibility_reasons: ["Applicant did not meet citizenship/immigration requirements"] }
      end
      let(:input_application) do
        app_params = mm_application_entity.to_h
        app_params[:applicants].first[:age_of_applicant] = 18
        app_params[:applicants].first[:citizenship_immigration_status_information] = citizenship_immigration_status_information2
        app_params[:tax_households].first[:tax_household_members].first[:product_eligibility_determination] = product_eligibility_determination3
        ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(app_params).success
      end

      let(:input_params) do
        { magi_medicaid_application: input_application }
      end

      before do
        chip_override_flag = MedicaidGatewayRegistry[:eligibility_override].setting(:mitc_override_not_lawfully_present_chip_eligible)
        allow(chip_override_flag).to receive(:item).and_return("true")
        @result = subject.call(input_params)
      end

      it "should return chip eligible" do
        chip_eligible = @result.success.tax_households.first.tax_household_members.first.product_eligibility_determination.is_medicaid_chip_eligible
        expect(chip_eligible).to eq(true)
      end
    end
  end
end
