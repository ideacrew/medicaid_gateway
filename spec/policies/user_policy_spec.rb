# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy, type: :policy, dbclean: :after_each do
  let(:user) { FactoryBot.create(:user) }

  shared_examples_for "policies" do |trait, result|
    let(:policy) { described_class.new(user, :user)}
    let(:user) { FactoryBot.create(:user, trait) } if trait

    [:transfer_summary?, :transfers_sent?, :transfers_received?, :determinations?, :mec_checks?, :irs_content?].each do |definition|
      it "returns #{result} for #{definition}" do
        expect(policy.send(definition)).to eq result
      end
    end
  end

  context 'user with no permissions object' do
    it_behaves_like "policies", nil, nil
  end

  context 'user with permissions set to false' do
    it_behaves_like "policies", :staff_with_no_permissions, false
  end

  context 'user with permissions set to true' do
    it_behaves_like "policies", :with_super_admin, true
  end
end
