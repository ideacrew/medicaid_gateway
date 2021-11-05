# frozen_string_literal: true

require 'rails_helper'
require "#{Rails.root}/spec/shared_contexts/eligibilities/magi_medicaid_application_data.rb"
Dir["#{Rails.root}/spec/shared_contexts/eligibilities/cms/me_simple_scenarios/*.rb"].sort.each { |file| require file }
Dir["#{Rails.root}/spec/shared_contexts/eligibilities/cms/me_complex_scenarios/*.rb"].sort.each { |file| require file }
Dir["#{Rails.root}/spec/shared_contexts/eligibilities/cms/me_test_scenarios/*.rb"].sort.each { |file| require file }
require 'aca_entities/magi_medicaid/contracts/create_federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/contracts/federal_poverty_level_contract'
require 'aca_entities/magi_medicaid/federal_poverty_level'
require 'aca_entities/operations/magi_medicaid/create_federal_poverty_level'

RSpec.describe ::Eligibilities::Medicaid::RequestDetermination, dbclean: :after_each do
  include Dry::Monads[:result, :do]

  before :each do
    # Stub cable ready callbacks to prevent view rendering
    allow_any_instance_of(Medicaid::Application).to receive(:row_morph).and_return('')
    allow_any_instance_of(Medicaid::Application).to receive(:event_row_morph).and_return('')
  end

  let(:event) { Success(double) }
  let(:obj)  {MitcService::CallMagiInTheCloud.new}

  it 'should be a container-ready operation' do
    expect(subject.respond_to?(:call)).to be_truthy
  end

  context 'for success' do
    before do
      allow(MitcService::CallMagiInTheCloud).to receive(:new).and_return(obj)
      allow(obj).to receive(:build_event).and_return(event)
      allow(event.success).to receive(:publish).and_return(true)
    end

    # Dwayne is UQHP eligible and eligible for non_magi_reasons
    context 'cms simle test_case_a' do
      include_context 'cms ME simple_scenarios test_case_a'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # Aisha is MagiMedicaid eligible
    context 'cms simle test_case_c' do
      include_context 'cms ME simple_scenarios test_case_c'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # Gerald is APTC and CSR eligible
    context 'cms simle test_case_d' do
      include_context 'cms ME simple_scenarios test_case_d'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    context 'cms simle test_case_g' do
      include_context 'cms ME simple_scenarios test_case_g'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    context 'cms simle test_case_e' do
      include_context 'cms ME simple_scenarios test_case_e'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # Soren	Sharp family. Soren, Mia are APTC eligible, Christian, Monika are Medicaid eligible
    context 'cms simle test_case_f with state ME' do
      include_context 'cms ME simple_scenarios test_case_f'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # Betty	CurtisH family
    context 'cms simle test_case_h with state ME' do
      include_context 'cms ME simple_scenarios test_case_h'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # Jane Doe
    context 'cms complex test_case_d with state ME' do
      include_context 'cms ME complex_scenarios test_case_d'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # Medicaid Gap Filling case, medicaid_or_chip_denial
    context 'cms simple test_case_c_1 with state ME' do
      include_context 'cms ME simple_scenarios test_case_c_1'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # SBMaya should be eligible for MagiMedicaid because of Medicaid Gap Filling,
    # but just because SBMaya attested that her medicaid_or_chip_termination in the last 90 days,
    # she is eligible for aqhp.
    context 'cms simple test_case_1_mgf_aqhp with state ME' do
      include_context 'cms ME simple_scenarios test_case_1_mgf_aqhp'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # Fix MitC depending income counting issue
    context 'cms complex test_case_e with state ME' do
      include_context 'cms ME complex_scenarios test_case_e'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # Medicaid gap filling for Simple test_case_k
    context 'cms simple test_case_k with state ME' do
      include_context 'cms ME simple_scenarios test_case_k'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # Non-MAGI referral missing if already eligible for MAGI Medicaid
    # Complex TestCaseE1
    context 'cms complex test_case_e_1 with state ME' do
      include_context 'cms ME complex_scenarios test_case_e_1'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # US citizen applicant with income under 100% getting APTC instead of UQHP
    context 'cms me_test_scenarios test_one state ME' do
      include_context 'cms ME me_test_scenarios test_one'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # Medicaid eligibility for I-766 lawfully present immigrant due to Medicaid gap fill
    context 'cms me_test_scenarios test_two state ME' do
      include_context 'cms ME me_test_scenarios test_two'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # Eligibility response error 999
    context 'cms me_test_scenarios test_three state ME' do
      include_context 'cms ME me_test_scenarios test_three'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # Primary should get APTC instead of UQHP
    context 'cms me_test_scenarios test_four state ME' do
      include_context 'cms ME me_test_scenarios test_four'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # Child claimed by married filing separately parent given APTC
    context 'cms me_test_scenarios test_5 state ME' do
      include_context 'cms ME me_test_scenarios test_5'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # AI/AN member given eligibility of 87% CSR instead of 100%
    context 'cms me_test_scenarios test_6 state ME' do
      include_context 'cms ME me_test_scenarios test_6'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # Parent is getting APTC/CSR as expected. Child is getting UQHP instead of APTC/CSR
    context 'cms me_test_scenarios test_7 state ME' do
      include_context 'cms ME me_test_scenarios test_7'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # AI/AN member given eligibility of 87% CSR instead of 100%
    # SystemDate: xx/xx/2021
    # OEStartOn: xx/xx/2021
    #   Application:
    #     assistance_year: 2022
    context 'cms me_test_scenarios test_five state ME' do
      include_context 'cms ME me_test_scenarios test_five'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # This test is to make sure the deduction amounts are reduced from total income
    context 'cms me_test_scenarios test_six state ME' do
      include_context 'cms ME me_test_scenarios test_six'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # Children eligible for UQHP, parents eligible for APTC. Children don't have any issues with tax or other coverage that would cause UQHP
    context 'cms me_test_scenarios test_seven state ME' do
      include_context 'cms ME me_test_scenarios test_seven'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end

    # TaxHousehold effective date calculation when all MedicaidChip or MagiMedicaid
    context 'cms me_test_scenarios test_eight state ME' do
      include_context 'cms ME me_test_scenarios test_eight'

      before do
        @result = subject.call(input_application)
        @application = @result.success
      end

      let(:medicaid_request_payload) do
        ::AcaEntities::MagiMedicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
      end

      it 'should create only one Medicaid::Application object with given hbx_id' do
        expect(::Medicaid::Application.where(application_identifier: application_entity.hbx_id).count).to eq(1)
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should return Medicaid::Application persistence object' do
        expect(@application).to be_a(::Medicaid::Application)
      end

      it 'should create Medicaid::Application persistence object' do
        expect(@application.persisted?).to be_truthy
      end

      it 'should store application_request_payload' do
        expect(@application.application_request_payload).to eq(input_application.to_json)
      end

      it 'should store medicaid_request_payload' do
        expect(@application.medicaid_request_payload).not_to be_nil
        expect(@application.medicaid_request_payload).to eq(medicaid_request_payload.to_json)
      end
    end
  end

  context 'for failure' do
    include_context 'cms ME simple_scenarios test_case_d'

    let(:medicaid_request_payload) do
      ::AcaEntities::Magi Medicaid::Operations::Mitc::GenerateRequestPayload.new.call(application_entity).success
    end

    context 'when input is invalid' do
      before do
        allow(MitcService::CallMagiInTheCloud).to receive(:new).and_return(obj)
        allow(obj).to receive(:build_event).and_return(event)
        allow(event.success).to receive(:publish).and_return(true)
        @result = subject.call({ test: "test" })
        @application = @result.success
      end

      it 'should return failure' do
        expect(@result).to be_failure
      end

      it 'should return error message' do
        errors = @result.failure.errors(full: true).to_h.values.flatten
        expect(errors).to include("family_reference is missing", "assistance_year is missing",
                                  "aptc_effective_date is missing", "applicants is missing", "us_state is missing",
                                  "hbx_id is missing", "oe_start_on is missing")
      end
    end
  end
end
