# frozen_string_literal: true

module ApplicationCable

  # stimulus reflex connection differentiator
  class Connection < ActionCable::Connection::Base
    # identified_by :session_id
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      # self.session_id = request.session.id
      # reject_unauthorized_connection unless session_id
    end

    protected

    def find_verified_user
      env["warden"].user || reject_unauthorized_connection
    end
  end
end
