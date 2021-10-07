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
        record = Aces::InboundTransfer.create!(payload: request.body, result: "Received")
        result = Aces::ProcessAtpSoapRequest.new.call(request.body, record.id)

        update_transfer(record.id, result)

        render inline: result.value!, status: 200, content_type: "application/soap+xml" if result.success?
      end

      private

      def update_transfer(id, request)
        result_text = request.success? ? "Sent" : "Failed"
        transfer = Aces::InboundTransfer.find(id)
        transfer.update!(payload: '', result: result_text, failure: request.failure)
      end
    end
  end
end