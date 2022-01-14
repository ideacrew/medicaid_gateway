# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :users

  # Must authenticate on routes for Devise to work with Stimulus Reflex/CableReady
  authenticate :user do
    root 'reports#events'

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
      end
    end

    namespace :aces do
      resources :inbound_transfers, only: [:show]
      resources :transfers, only: [:show]
    end
  end

  # Requests to external services -- no user authentication
  namespace :aces do
    resource :publishing_connectivity_tests, only: [:new, :create]
    namespace :soap do
      resource :atp_requests, only: [] do
        collection do
          get 'wsdl'
          post 'service'
        end
      end
    end
  end
end
