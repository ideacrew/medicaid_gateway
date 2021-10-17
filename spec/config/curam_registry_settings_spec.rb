# frozen_string_literal: true

require "rails_helper"

describe "configured curam settings", :if => MedicaidGatewayRegistry[:state_abbreviation].item.downcase == 'dc' do

  let(:curam_connection) { MedicaidGatewayRegistry[:curam_connection] }

  it "contains the curam_atp_service_uri" do
    expect(curam_connection.setting(:curam_atp_service_uri)).not_to eq nil
  end

  it "contains the curam_atp_service_username" do
    expect(curam_connection.setting(:curam_atp_service_username)).not_to eq nil
  end

  it "contains the curam_atp_service_password" do
    expect(curam_connection.setting(:curam_atp_service_password)).not_to eq nil
  end

  it "contains the curam_check_service_uri" do
    expect(curam_connection.setting(:curam_check_service_uri)).not_to eq nil
  end
end
