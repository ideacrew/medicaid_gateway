# frozen_string_literal: true

# factory for users
FactoryBot.define do
  factory :user do
    email { "abc123@example.com" }
    password { "dfkjghfj!!123" }
  end
end
