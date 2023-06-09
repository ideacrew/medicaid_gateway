# frozen_string_literal: true

require 'rails_helper'
require 'types'

RSpec.describe ::Medicaid::EligibilityOverride, type: :model, dbclean: :after_each do
  let(:params) do
    {
      override_rule: :not_lawfully_present_pregnant,
      override_applied: true
    }
  end
  context "validations" do
    it { should validate_inclusion_of(:override_rule).in_array(Types::EligibilityOverrideRule.values) }
  end

  context "callbacks" do
    context "before_validation" do
      context "symbolize_override_rule" do
        context "when override_rule is a string" do
          let(:params) do
            {
              override_rule: "not_lawfully_present_pregnant",
              override_applied: true
            }
          end

          it "should symbolize override_rule" do
            subject.assign_attributes(params)
            expect(subject.valid?).to be_truthy
            expect(subject.override_rule).to eq(:not_lawfully_present_pregnant)
          end
        end
      end
    end
  end
end