# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'
require 'aca_entities/operations/create_person'

module Transmittable
  # create Transmission that takes params of key (required), job (required), started_at(required)
  class CreatePerson
    include Dry::Monads[:result, :do, :try]

    def call(person)
      person = yield validate_params(person)
      person_hash = yield build_person_hash(person)
      person_entity = yield person_entity(person_hash)
      person = yield create_person(person_entity)
      Success(person)
    end

    private

    def validate_params(person)
      return Failure('Person is blank') if person.blank?

      Success(person)
    end

    def build_person_hash(person)
      person_demographics = {
        encrypted_ssn: person["identifying_information"]["encrypted_ssn"],
        gender: person["identifying_information"]["encrypted_ssn"],
        dob: person["demographic"]["dob"]
      }
      person_name = { first_name: person["name"]["first_name"], last_name: person["name"]["last_name"] }
      Success({ person_name: person_name,
                hbx_id: person["person_hbx_id"],
                person_health: {},
                is_active: true,
                person_demographics: person_demographics })
    end

    def person_entity(person_hash)
      validation_result = AcaEntities::Operations::CreatePerson.new.call(person_hash)
      validation_result.success? ? Success(validation_result.value!) : Failure("Unable to create Person due to invalid params")
    end

    def create_person(person_entity)
      person_hash = convert_entity_to_subject_hash(person_entity)
      person = Transmittable::Person.new(person_hash)

      person.save ? Success(person) : Failure("Failed to create person subject")
    end

    def convert_entity_to_subject_hash(person_entity)
      entity_hash = person_entity.to_h

      { first_name: entity_hash[:person_name][:first_name],
        middle_name: entity_hash[:person_name][:middle_name],
        last_name: entity_hash[:person_name][:last_name], hbx_id: entity_hash[:hbx_id],
        encrypted_ssn: entity_hash[:person_demographics][:encrypted_ssn],
        gender: entity_hash[:person_demographics][:gender],
        dob: entity_hash[:person_demographics][:dob] }
    end
  end
end
