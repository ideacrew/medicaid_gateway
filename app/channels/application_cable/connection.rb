# frozen_string_literal: true

module ApplicationCable

  # stimulus reflex connection differentiator
  class Connection < ActionCable::Connection::Base
    # identified_by :session_id
    identified_by :current_user

    def connect
      # self.current_user = find_verified_user
      # self.session_id = request.session.id
      # reject_unauthorized_connection unless session_id
      user_id = cookies.encrypted[:user_id]
      return reject_unauthorized_connection if user_id.nil?
      user = User.find(user_id)
      return reject_unauthorized_connection if user.nil?
      self.current_user = user
    end

    protected

    def find_verified_user
      env["warden"].user || reject_unauthorized_connection
    end
  end
end
