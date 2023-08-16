# frozen_string_literal: true

module Transmittable
  # A single workflow event instance for transmission to an external service
  class Transaction
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :transactable, polymorphic: true, index: true
    has_many :transactions_transmissions, class_name: 'Transmittable::TransactionsTransmissions'
    has_one :process_status, as: :statusable, class_name: 'Transmittable::ProcessStatus'
    accepts_nested_attributes_for :process_status
    has_many :transmittable_errors, as: :errorable, class_name: 'Transmittable::Error'
    accepts_nested_attributes_for :transmittable_errors

    field :key, type: Symbol
    field :title, type: String
    field :description, type: String
    field :started_at, type: DateTime
    field :ended_at, type: DateTime
    field :transaction_id, type: String
    field :json_payload, type: Hash
    field :xml_payload, type: String

    index({ key: 1 })
    index({ created_at: 1 })

    scope :succeeded, -> { where(:_id.in => ::Transmittable::ProcessStatus.where(latest_state => :succeeded).distinct(:statusable_id)) }
    scope :not_succeeded, -> { where(:_id.in => ::Transmittable::ProcessStatus.where(:latest_state.nin => [:succeeded]).distinct(:statusable_id)) }

    scope :application_mec_check, -> { where(:key.in => [:application_mec_check_response, :application_mec_check_request]) }

    def succeeded?
      process_status&.latest_state == :succeeded
    end

    def error_messages
      return [] unless errors

      transmittable_errors&.map {|error| "#{error.key}: #{error.message}"}&.join(";")
    end

    def mec_response_ui
      return if xml_payload.blank? || key != :application_mec_check_response
      parsed_xml = Nokogiri::XML(xml_payload)
      if MedicaidGatewayRegistry[:transfer_service].item == "aces"
        # binding.pry if transaction_id == "1624289008997663"
        parsed_xml.xpath("//xmlns:ResponseDescription")&.text
      else
        parsed_xml.xpath("//xmlns:GetEligibilityResponse", "xmlns" => "http://xmlns.dhcf.dc.gov/dcas/Medicaid/Eligibility/xsd/v1")&.text
      end
    end
  end
end
