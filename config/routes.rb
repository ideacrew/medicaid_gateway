# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :aces do
    resource :publishing_connectivity_tests, only: [:new, :create]

    namespace :soap do
      resource :atp_requests, only: [:create]
    end
  end
end
