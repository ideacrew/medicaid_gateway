# frozen_string_literal: true

module Aces
  module Soap
    # Accepts and processes requests to OpenHBX that originate from the ACES
    # system.
    class AtpRequestsController < ApplicationController
      skip_before_action :verify_authenticity_token, only: [:wsdl, :service]
      skip_before_action :authenticate_user!, only: [:wsdl, :service]

      def wsdl
        render "wsdl.wsdl", layout: false, formats: [:wsdl], content_type: "text/xml"
      end

      def service
        record = Aces::InboundTransfer.create!(payload: request.body, result: "Received")
        result = Aces::ProcessAtpSoapRequest.new.call(request.body, record.id)
        result_status = result.success? ? result.value! : result.failure
        update_transfer(record.id, result)
        render inline: result_status, status: 200, content_type: "application/soap+xml" if result_status.to_s.include?("<?xml")
      end

      private

      def update_transfer(id, request)
        transfer = Aces::InboundTransfer.find(id)
        if request.success?
          result_text = transfer.to_enroll ? "Sent to Enroll" : "Waiting to Send"
        else
          result_text = "Failed"
        end
        failure_text = request.failure? ? request.failure : transfer.failure
        transfer.update!(result: result_text, failure: failure_text)
      end
    end
  end
end