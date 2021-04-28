# frozen_string_literal: true

module Aces
  module Soap
    class AtpRequestsController < ApplicationController
      skip_before_action :verify_authenticity_token, only: [:wsdl, :service]

      def wsdl
        render "wsdl.wsdl", layout: false, formats: [:wsdl], content_type: "text/xml"
      end

      def service
        result = ProcessAtpSoapRequest.new.call(request.body)
        if result.success?
          head 200
        else
          case result.failure
          when :unknown_user
            head 401
          when :invalid_password
            head 401
          when :security_header_unreadable
            head 401
          when :xml_parse_failed
            head 400
          when :missing_body_node
            head 400
          else
            head 400
          end
        end
      end
    end
  end
end