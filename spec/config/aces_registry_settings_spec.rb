# frozen_string_literal: true

require "rails_helper"

describe "configured aces settings" do
  it "exists" do
    expect(MedicaidGatewayRegistry[:aces_connection].setting(:aces_endpoint_root)).not_to eq nil
  end
end
