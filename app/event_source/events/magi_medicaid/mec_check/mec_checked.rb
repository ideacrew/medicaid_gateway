# frozen_string_literal: true

module Events
  module MagiMedicaid
    module MecCheck
      module Enroll
        class MecChecked < EventSource::Event
          publisher_path 'publishers.mec_check_publisher'
        end
      end
    end
  end
end