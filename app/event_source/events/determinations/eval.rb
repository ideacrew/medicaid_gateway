# frozen_string_literal: true

module Events
  module Determinations
    # Eval will register event publisher for MiTC
    class Eval < EventSource::Event
      publisher_path 'publishers.mitc_publisher'

    end
  end
end