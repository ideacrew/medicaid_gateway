# frozen_string_literal: true

require "mongoid"

module MitcService
  # MitcService::Engine
  class Engine < ::Rails::Engine
    isolate_namespace MitcService

    config.generators do |g|
      g.test_framework :rspec, fixture: false
    end
  end
end
