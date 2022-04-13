# frozen_string_literal: true

module Medicaid
  # Determinations from MITC
  class ApplicationsController < ApplicationController
    def show
      @application = find_application(params)
      @application_request_payload = parse_json(@application.application_request_payload)
      @application_response_payload = parse_json(@application.application_response_payload)
      @medicaid_request_payload = parse_json(@application.medicaid_request_payload)
      @medicaid_response_payload = parse_json(@application.medicaid_response_payload)
      render layout: "application"
    end

    private

    def find_application(params)
      Medicaid::Application.where(id: params[:id]).first || Medicaid::Application.where(application_identifier: params[:id]).last
    end

    def parse_json(value)
      return value unless value.present?
      JSON.parse(value)
    rescue JSON::ParserError
      value
    end

  end
end
