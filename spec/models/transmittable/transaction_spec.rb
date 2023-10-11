# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transmittable::Transaction, "with index definitions" do
  it "creates correct indexes" do
    Transmittable::Transaction.remove_indexes
    Transmittable::Transaction.create_indexes
  end
end
