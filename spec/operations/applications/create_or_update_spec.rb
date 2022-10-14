# frozen_string_literal: true

require 'rails_helper'
require File.join(Rails.root, 'spec/shared_contexts/eligibilities/magi_medicaid_application_data')
require 'aca_entities/magi_medicaid/contracts/create_federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/contracts/federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/federal_poverty_level'
require 'aca_entities/operations/magi_medicaid/create_federal_poverty_level'

describe Applications::CreateOrUpdate, dbclean: :after_each do
  include_context 'setup magi_medicaid application with two applicants'

  let(:application_request_payload) do
    AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(magi_medicaid_application).success
  end

  let(:medicaid_request_payload) do
    AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_request_payload).success
  end

  context 'with required data ' do
    before do
      @result = subject.call({ application_identifier: application_request_payload.to_h[:hbx_id].to_s,
                               application_request_payload: application_request_payload.to_json,
                               medicaid_request_payload: medicaid_request_payload.to_json })
    end

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should create only one Application' do
      expect(::Medicaid::Application.all.count).to eq(1)
    end

    it 'should persisted the data' do
      expect(@result.success.persisted?).to eq true
    end
  end

  context 'update application' do
    before do
      ::Medicaid::Application.new(application_identifier: application_request_payload.to_h[:hbx_id].to_s).save!

      @result = subject.call({ application_identifier: application_request_payload.to_h[:hbx_id].to_s,
                               application_request_payload: application_request_payload.to_json,
                               medicaid_request_payload: medicaid_request_payload.to_json })
    end

    it 'should return success' do
      expect(@result).to be_success
    end

    it 'should update existing Application and not create new applications' do
      expect(::Medicaid::Application.all.count).to eq(1)
    end

    it 'should persisted the data' do
      expect(@result.success.persisted?).to eq true
    end
  end

  context 'with missing data ' do
    before do
      @result = subject.call({ application_request_payload: application_request_payload.to_json,
                               medicaid_request_payload: medicaid_request_payload.to_json })
    end

    it 'should return failure' do
      expect(@result).to be_failure
    end

    it 'should not persisted the data and return error message' do
      expect(@result.failure.errors(full: true).to_h.values.flatten).to eq ["application_identifier is missing",
                                                                            "application_identifier must be a string"]
    end
  end

  context 'with required data and renewal flag' do
    context 'when is_renewal is true' do
      before do
        @result = subject.call({ application_identifier: application_request_payload.to_h[:hbx_id].to_s,
                                 application_request_payload: application_request_payload.to_json,
                                 medicaid_request_payload: medicaid_request_payload.to_json,
                                 is_renewal: true })
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should create only one Application' do
        expect(::Medicaid::Application.all.count).to eq(1)
      end

      it 'should persisted the data' do
        expect(@result.success.persisted?).to eq true
      end

      it 'should return true for is_renewal' do
        expect(@result.success.is_renewal).to eq true
      end
    end

    context 'when is_renewal is nil' do
      before do
        @result = subject.call({ application_identifier: application_request_payload.to_h[:hbx_id].to_s,
                                 application_request_payload: application_request_payload.to_json,
                                 medicaid_request_payload: medicaid_request_payload.to_json,
                                 is_renewal: nil })
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should create only one Application' do
        expect(::Medicaid::Application.all.count).to eq(1)
      end

      it 'should persisted the data' do
        expect(@result.success.persisted?).to eq true
      end

      it 'should return nil for is_renewal' do
        expect(@result.success.is_renewal).to eq nil
      end
    end
  end
end
