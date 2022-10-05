# frozen_string_literal: true

module Publishers
  # Publisher will send request payload to EA for slcsp determination
  class DetermineSlcspPublisher
    include ::EventSource::Publisher[amqp: 'magi_medicaid.iap.benchmark_products']

    register_event 'determine_slcsp'
  end
end
