# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :users

  root 'reports#events'

  namespace :aces do
    resource :publishing_connectivity_tests, only: [:new, :create]
    resources :inbound_transfers, only: [:show, :new, :create]
    resources :transfers, only: [:show, :new, :create]
    namespace :soap do
      resource :atp_requests, only: [] do
        collection do
          get 'wsdl'
          post 'service'
        end
      end
    end
  end

  namespace :transmittable do
    resources :jobs, only: [:index, :show]
    resources :transactions, only: [:index, :show]
  end

  namespace :medicaid do
    resources :applications, only: [:show]
  end

  resources :reports, only: [] do
    collection do
      get 'medicaid_applications'
      get 'account_transfers'
      get 'account_transfers_to_enroll'
      get 'transfer_summary'
      get 'medicaid_application_check'
      get 'mec_checks'
      get 'events'
      put 'update_transfer_requested'
      put 'resubmit_to_service'
      put 'resubmit_to_enroll'
      get 'daily_iap_determinations'
      put 'change_dates'
    end
  end
end
