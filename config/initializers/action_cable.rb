# frozen_string_literal: true

# ActionCable logs are redundant when Stimulus Reflex logging is also enabled;
# disabling increases performance
ActionCable.server.config.logger = Logger.new(nil)