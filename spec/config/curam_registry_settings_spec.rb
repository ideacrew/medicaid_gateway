# frozen_string_literal: true

require "rails_helper"

describe "configured curam settings" do
  it "contains the curam_atp_service_uri" do
    expect(MedicaidGatewayRegistry[:curam_connection].setting(:curam_atp_service_uri)).not_to eq nil
  end

  it "contains the curam_atp_service_username" do
    expect(MedicaidGatewayRegistry[:curam_connection].setting(:curam_atp_service_username)).not_to eq nil
  end

  it "contains the curam_atp_service_password" do
    expect(MedicaidGatewayRegistry[:curam_connection].setting(:curam_atp_service_password)).not_to eq nil
  end

  it "contains the curam_check_service_uri" do
    expect(MedicaidGatewayRegistry[:curam_connection].setting(:curam_check_service_uri)).not_to eq nil
  end
end
