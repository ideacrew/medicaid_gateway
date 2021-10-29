# frozen_string_literal: true

module Medicaid
  # Determinations from MITC
  class ApplicationsController < ActionController::Base
    def show
      @application = Medicaid::Application.find(params[:id])
      @application_request_payload = parse_json(@application.application_request_payload)
      @application_response_payload = parse_json(@application.application_response_payload)
      @medicaid_request_payload = parse_json(@application.medicaid_request_payload)
      @medicaid_response_payload = parse_json(@application.medicaid_response_payload)
      @other_factors = parse_json(@application.other_factors)
      render layout: "application"
    end

    private

    def parse_json(value)
      JSON.parse(value)
    rescue JSON::ParserError
      value
    end

  end
end