# frozen_string_literal: true

# Application Controller
class ApplicationController < ActionController::Base
  before_action :manual_authenticate_user

  def manual_authenticate_user
    authenticate_user!
  rescue StandardError => e
    puts "manual_authenticate_user"
    puts e.backtrace.join("\n")
    raise e
  end
end
