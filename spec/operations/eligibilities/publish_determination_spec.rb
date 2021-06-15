# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Eligibilities::PublishDetermination, dbclean: :after_each do
  it "should send payload" do
    event_name = "aptc_eligible"
    Eligibilities::PublishDetermination.new.call({ test: "test" }, event_name)
  end
end