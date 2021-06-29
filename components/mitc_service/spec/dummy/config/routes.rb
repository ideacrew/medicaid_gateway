# frozen_string_literal: true

Rails.application.routes.draw do
  mount MitcService::Engine => "/mitc_service"
end
