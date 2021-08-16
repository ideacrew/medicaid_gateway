# frozen_string_literal: true

module Aces
  module Soap
    # Accepts and processes requests to OpenHBX that originate from the ACES
    # system.
    class AtpRequestsController < ApplicationController
      skip_before_action :verify_authenticity_token, only: [:wsdl, :service]

      def wsdl
        render "wsdl.wsdl", layout: false, formats: [:wsdl], content_type: "text/xml"
      end

      def service
        result = ProcessAtpSoapRequest.new.call(request.body)
        if result.success?
          Transfers::ToEnroll.new.call(request.body)
          Aces::RecordAcesSubmission.new.call({
                                                body: request.body,
                                                result: result.value!
                                              })
          render inline: result.value!, status: 200, content_type: "application/soap+xml"
        else
          Aces::RecordAcesSubmission.new.call({
                                                body: request.body,
                                                result: result.failure
                                              })
          case result.failure
          when :unknown_user, :invalid_password, :security_header_unreadable
            head 401
          when :xml_parse_failed, :missing_body_node
            head 400
          else
            head 500
          end
        end
      end
    end
  end
end