# frozen_string_literal: true

module Publishers
  module MagiMedicaid
    module Applications
      module AptcCsrCredits
        module Renewals
          # Publisher will send response payload to EA
          class RenewalsDeterminationPublisher
            # TODO: enable below after eventsource initializer is updated acccordingly to acaentities async_api yml files
            include ::EventSource::Publisher[amqp: 'magi_medicaid.applications.aptc_csr_credits.renewals']

            register_event 'determined_uqhp_eligible'
            register_event 'determined_mixed_determination'
            register_event 'determined_magi_medicaid_eligible'
            register_event 'determined_totally_ineligible'
            register_event 'determined_medicaid_chip_eligible'
            register_event 'determined_aptc_eligible'
          end
        end
      end
    end
  end
end


