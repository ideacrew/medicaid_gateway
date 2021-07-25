# frozen_string_literal: true

module Events
  module MagiMedicaid
    module Atp
      module Enroll
        class TransferIn < EventSource::Event
          publisher_path 'publishers.transfer_publisher'
        end
      end
    end
  end
end