# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # skip authentication on reflexes
  before_action :authenticate_user!, :unless => proc { !!@stimulus_reflex }
end
