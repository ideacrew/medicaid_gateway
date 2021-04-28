# frozen_string_literal: true

require "rails_helper"

describe "configured aces settings" do
  it "contains the atp_service_uri" do
    expect(MedicaidGatewayRegistry[:aces_connection].setting(:aces_atp_service_uri)).not_to eq nil
  end

  it "contains the atp_service_username" do
    expect(MedicaidGatewayRegistry[:aces_connection].setting(:aces_atp_service_username)).not_to eq nil
  end

  it "contains the atp_service_password" do
    expect(MedicaidGatewayRegistry[:aces_connection].setting(:aces_atp_service_password)).not_to eq nil
  end

  it "contains the atp_caller_username" do
    expect(MedicaidGatewayRegistry[:aces_connection].setting(:aces_atp_caller_username)).not_to eq nil
  end

  it "contains the atp_caller_password" do
    expect(MedicaidGatewayRegistry[:aces_connection].setting(:aces_atp_caller_password)).not_to eq nil
  end
end
