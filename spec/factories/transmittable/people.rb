# frozen_string_literal: true

FactoryBot.define do
  factory :person, class: "::Transmittable::Person" do
    person_name {"hbx_id"}
    encrypted_ssn {"hbx_id"}
    dob {Date.today.to_s}
    gender {"Male"}
    hbx_id {"hbx_id"}
  end
end
