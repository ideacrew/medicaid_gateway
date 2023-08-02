# frozen_string_literal: true

module Transmittable
  class AcesApplication
    include Mongoid::Document
    include Mongoid::Timestamps
    include Transmittable::Subject

    field :application_id, type: String
  end
end
