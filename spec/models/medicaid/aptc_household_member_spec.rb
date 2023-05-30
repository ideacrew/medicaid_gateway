# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Medicaid::AptcHouseholdMember, type: :model, dbclean: :after_each do
  context 'with valid params' do
    let(:application) { FactoryBot.create(:application, :with_aptc_households) }

    before do
      application.save!
      @app = application
    end

    it 'should not return nil for determination_reasons attribute' do
      member = Medicaid::Application.find(@app.id).aptc_households.first.aptc_household_members.first
      expect(member.member_determinations).to_not eq nil
    end
  end
end
