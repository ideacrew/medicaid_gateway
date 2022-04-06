# frozen_string_literal: true

# Application controller
class ApplicationController < ActionController::Base
  include Pundit::Authorization
  # skip authentication on reflexes
  before_action :authenticate_user!, :if => proc { !@stimulus_reflex }
  before_action :set_action_cable_identifier

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # override Pundit authorize method to skip authorization on reflexes
  def authorize(record, query = nil)
    return if @stimulus_reflex
    super(record, query)
  end

  def user_not_authorized(_exception)
    respond_to do |format|
      format.json { render nothing: true, status: :forbidden }
      format.html { redirect_to((request.referrer || root_path), notice: "Access not allowed")}
      format.js   { render nothing: true, status: :forbidden }
    end
  end

  def set_action_cable_identifier
    cookies.encrypted[:user_id] = current_user&.id
  end
end
