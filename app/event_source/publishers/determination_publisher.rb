# frozen_string_literal: true

module Publishers
  # Publisher will send response payload to EA
  class DeterminationPublisher
    # TODO: enable below after eventsource initializer is updated acccordingly to acaentities async_api yml files
    # include ::EventSource::Publisher[amqp: 'magi_medicaid.mitc.eligibilities']

    # register_event 'determined_medicaid_eligible'

    # remove this method
    def test
    end
  end
end

