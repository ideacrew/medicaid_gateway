# frozen_string_literal: true

require "rails_helper"

describe "configured aces settings", :if => MedicaidGatewayRegistry[:state_abbreviation].item.downcase == 'me' do

  let(:aces_connection) { MedicaidGatewayRegistry[:aces_connection] }

  it "contains the atp_service_uri" do
    expect(aces_connection.setting(:aces_atp_service_uri)).not_to eq nil
  end

  it "contains the atp_service_username" do
    expect(aces_connection.setting(:aces_atp_service_username)).not_to eq nil
  end

  it "contains the atp_service_password" do
    expect(aces_connection.setting(:aces_atp_service_password)).not_to eq nil
  end

  it "contains the atp_caller_username" do
    expect(aces_connection.setting(:aces_atp_caller_username)).not_to eq nil
  end

  it "contains the atp_caller_password" do
    expect(aces_connection.setting(:aces_atp_caller_password)).not_to eq nil
  end

  it "contains the aces_mec_check_uri" do
    expect(aces_connection.setting(:aces_mec_check_uri)).not_to eq nil
  end
end
