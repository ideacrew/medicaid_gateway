# frozen_string_literal: true

require 'rails_helper'
require "#{Rails.root}/spec/shared_contexts/eligibilities/magi_medicaid_application_data.rb"

RSpec.describe 'app/views/medicaid/applications/show.html.erb', type: :view do
  include_context 'setup magi_medicaid application with two applicants'

  let(:user) { FactoryBot.create(:user) }
  let(:json_application_payload) { magi_medicaid_application.to_json }

  let(:application) do
    FactoryBot.create(
      :application,
      application_request_payload: json_application_payload,
      application_response_payload: json_application_payload,
      medicaid_request_payload: json_application_payload,
      medicaid_response_payload: json_application_payload,
      dynamic_slcsp_request_payload: json_application_payload,
      dynamic_slcsp_response_payload: json_application_payload
    )
  end

  before do
    assign(:application, application)
    assign(:application_request_payload, application.application_request_payload)
    assign(:application_response_payload, application.application_response_payload)
    assign(:medicaid_request_payload, application.medicaid_request_payload)
    assign(:medicaid_response_payload, application.medicaid_response_payload)
    assign(:dynamic_slcsp_request_payload, application.dynamic_slcsp_request_payload)
    assign(:dynamic_slcsp_response_payload, application.dynamic_slcsp_response_payload)

    render file: Rails.root.join('app', 'views', 'medicaid', 'applications', 'show.html.erb')
  end

  it 'displays the expected labels for SLCSP payloads' do
    expect(rendered).to have_content('Dynamic SLCSP Request Payload (to Enroll)')
    expect(rendered).to have_content('Dynamic SLCSP Response Payload (from Enroll)')
  end
end
