# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Medicaid::ApplicationsController, type: :controller do
  before :all do
    DatabaseCleaner.clean
  end

  after :all do
    DatabaseCleaner.clean
  end

  let(:application) { FactoryBot.create(:application, :with_aptc_households) }
  let(:user) { FactoryBot.create(:user) }

  before :each do
    sign_in user
  end

  describe 'GET #show' do
    let(:params) { { id: application.id } }

    before :each do
      get :show, params: params
    end

    context 'when:
      - the application is found by id
      - the dynamic_slcsp_request_payload is present
      - the dynamic_slcsp_response_payload is present
      ' do

      it 'returns a 200 status code' do
        expect(response).to have_http_status(:ok)
      end

      it 'assigns dynamic_slcsp_request_payload and dynamic_slcsp_response_payload' do
        expect(controller.instance_variable_get(:@dynamic_slcsp_request_payload)).not_to be_nil
        expect(controller.instance_variable_get(:@dynamic_slcsp_response_payload)).not_to be_nil
      end
    end
  end
end
