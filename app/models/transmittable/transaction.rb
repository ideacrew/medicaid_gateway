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

    scope :application_mec_check, -> { where(:key.in => [:application_mec_check_response, :application_mec_check_request]) }

    def succeeded?
      process_status&.latest_state == :succeeded
    end

    def error_messages
      return [] unless errors

      transmittable_errors&.map {|error| "#{error.key}: #{error.message}"}&.join(";")
    end

    def mec_response_ui
      if transmittable_errors.present?
        errors = transmittable_errors.map(&:message).join(",")
        return errors if errors.present?
      end
      json_payload["code_description"] if json_payload.present?
    end

    def to_event
      {
        type: key.to_s.titleize,
        created_at: self.updated_at,
        success: self.succeeded?,
        app_id: self.transaction_id
      }
    end

    def self.succeeded(transaction_ids)
      ::Transmittable::ProcessStatus.where(:latest_state => :succeeded, :statusable_id.in => transaction_ids)
    end

    def self.not_succeeded(transaction_ids)
      ::Transmittable::ProcessStatus.where(:latest_state.nin => [:succeeded], :statusable_id.in => transaction_ids)
    end
  end
end
