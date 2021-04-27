# frozen_string_literal: true

require 'dry-types'

Dry::Types.load_extensions(:maybe)

module Types
  send(:include, Dry.Types())
  include Dry::Logic
end
