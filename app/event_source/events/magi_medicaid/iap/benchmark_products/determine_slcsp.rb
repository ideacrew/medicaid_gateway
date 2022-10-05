# frozen_string_literal: true

module Events
  module MagiMedicaid
    module Iap
      module BenchmarkProducts
        class DetermineSlcsp < EventSource::Event
          publisher_path 'publishers.determine_slcsp_publisher'
        end
      end
    end
  end
end
