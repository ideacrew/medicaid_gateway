# frozen_string_literal: true

require 'rails_helper'

# Spec for TransfersController
module Aces
  RSpec.describe TransfersController, type: :controller, dbclean: :after_each do

    describe 'GET new' do
      let(:user) { FactoryBot.create(:user) }

      before :each do
        sign_in user
        get :new
      end

      it 'returns success' do
        expect(response).to have_http_status(:success)
      end
    end

    describe 'POST create' do
      let(:user) { FactoryBot.create(:user) }
      let(:outbound_payload) do
        {}
      end

      before :each do
        sign_in user
        post :create, params: { transfer: { outbound_payload: outbound_payload } }
      end

      it 'returns redirect' do
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
