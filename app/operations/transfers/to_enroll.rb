# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'
require 'aca_entities/serializers/xml/medicaid/atp'
require 'aca_entities/atp/transformers/cv/family'

module Transfers
  # Transfer an account from ACES to enroll
  class ToEnroll
    send(:include, Dry::Monads[:result, :do, :try])

    # @param [String] Take in the raw payload and serialize and transform it, then tranfer the result to EA.
    # @return [Dry::Result]
    def call(params, transfer_id)
      payload = yield create_transfer(params)
      transformed_params = yield transform_params(payload, transfer_id)
      updated_transformed_params = yield update_inferred_defaults(transformed_params)
      initiate_transfer(updated_transformed_params)
    end

    private

    def create_transfer(input)
      record = ::AcaEntities::Serializers::Xml::Medicaid::Atp::AccountTransferRequest.parse(input)
      result = record.is_a?(Array) ? record.first : record
      Success(result)
    rescue StandardError => e
      Failure("serializer error #{e}")
    end

    def transform_params(result, transfer_id)
      transformed = ::AcaEntities::Atp::Transformers::Cv::Family.transform(result.to_hash(identifier: true))
      uniq_id = "#{transfer_id}_#{transformed[:family][:magi_medicaid_applications][0][:transfer_id]}"
      application = transformed.dig(:family, :magi_medicaid_applications)
      applicants = application&.first&.dig(:applicants)&.select {|a| a[:is_applying_coverage]}
      applicants = applicants&.map { |a| "#{a[:name][:first_name]}: #{a[:transfer_referral_reason]}" }
      update_transfer(transfer_id, uniq_id, applicants)
      transformed[:family][:magi_medicaid_applications][0][:transfer_id] = uniq_id
      Success(transformed)
    rescue StandardError => e
      Failure("to_aces transformer #{e}")
    end

    def update_transfer(transfer_id, external_id, applicants)
      transfer = Aces::InboundTransfer.find(transfer_id)
      transfer.update!(external_id: external_id, applicants: applicants)
    end

    def update_inferred_defaults(transformed_params)
      return Success(transformed_params) unless MedicaidGatewayRegistry.feature_enabled?(:infer_post_partum_period)
      transformed_params[:family][:magi_medicaid_applications][0][:applicants].each do |applicant|
        applicant[:pregnancy_information][:is_post_partum_period] = false if applicant[:pregnancy_information][:is_post_partum_period].nil?
      end
      Success(transformed_params)
    end

    def initiate_transfer(payload)
      transfer = Transfers::InitiateTransferToEnroll.new.call(payload)
      transfer.success? ? Success("Transferred account to Enroll") : Failure(transfer)
    end
  end
end