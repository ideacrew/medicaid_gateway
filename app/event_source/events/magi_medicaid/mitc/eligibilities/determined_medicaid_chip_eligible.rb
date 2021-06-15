# frozen_string_literal: true

module Events
  module MagiMedicaid
    module Mitc
      module Eligibilities
        class DeterminedMedicaidChipEligible < EventSource::Event
          publisher_path 'publishers.determination_publisher'

        end
      end
    end
  end
end