module RexPort
  module Errors
    class StartupError < RuntimeError; end

    class DiedBeforeListeningError < RuntimeError; end

    class ResponseTimeoutError < RuntimeError; end

    class ResponseReadError < RuntimeError; end
  end
end