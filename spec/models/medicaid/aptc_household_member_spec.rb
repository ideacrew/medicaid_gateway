# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Medicaid::AptcHouseholdMember, type: :model, dbclean: :after_each do
  context 'embeds_many :member_determinations' do
    before do
      @association = described_class.reflect_on_association(:member_determinations)
    end

    it "should return association's class as EmbedsMany" do
      expect(@association.class).to eq(Mongoid::Association::Embedded::EmbedsMany)
    end

    it "should return association's name as member_determinations" do
      expect(@association.name).to eq(:member_determinations)
    end
  end

  context 'valid params' do
    let(:application) { FactoryBot.create(:application, :with_aptc_households) }

    before do
      application.save!
      @app = application
    end

    it 'should be saved correctly' do
      member = Medicaid::Application.find(@app.id).aptc_households.first.aptc_household_members.first
      expect(member).to be_a(::Medicaid::AptcHouseholdMember)
    end

    it 'should not return nil for determination_reasons attribute' do
      member = Medicaid::Application.find(@app.id).aptc_households.first.aptc_household_members.first
      expect(member.member_determinations).to_not eq nil
    end
  end
end
