# frozen_string_literal: true

module Events
  module MagiMedicaid
    module Applications
      module AptcCsrCredits
        module Renewals
          class DeterminedAptcEligible < EventSource::Event
            publisher_path 'publishers.magi_medicaid.applications.aptc_csr_credits.renewals.renewals_determination_publisher'
          end
        end
      end
    end
  end
end