# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # skip authentication on reflexes
  before_action :authenticate_user!, :if => proc { !@stimulus_reflex }
  before_action :set_action_cable_identifier

  def set_action_cable_identifier
    cookies.encrypted[:user_id] = current_user&.id
  end
end
