# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :aces do
    resource :publishing_connectivity_tests, only: [:new, :create]
    resources :inbound_transfers, only: [:show]
    resources :transfers, only: [:show]
    namespace :soap do
      resource :atp_requests, only: [] do
        collection do
          get 'wsdl'
          post 'service'
        end
      end
    end
  end

  resources :reports, only: [] do
    collection do
      get 'medicaid_applications'
      get 'account_transfers'
      get 'account_transfers_to_enroll'
      get 'transfer_summary'
      get 'medicaid_application_check'
      get 'mec_checks'
    end
  end

end
