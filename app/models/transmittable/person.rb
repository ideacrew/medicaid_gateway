# frozen_string_literal: true

module Transmittable
  class Person
    include Mongoid::Document
    include Mongoid::Timestamps
    include Transmittable::Subject

    field :person_name, type: String
    field :encrypted_ssn, type: String
    field :dob, type: String
    field :gender, type: String
    field :hbx_id, type: String
  end
end
