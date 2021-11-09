# frozen_string_literal: true

module ApplicationCable

  # stimulus reflex connection differentiator
  class Connection < ActionCable::Connection::Base
    identified_by :session_id

    def connect
      self.session_id = request.session.id
      reject_unauthorized_connection unless session_id
    end

    protected

    def find_verified_user
      self.current_user = env["warden"].user(:user) || reject_unauthorized_connection
    end
  end
end
