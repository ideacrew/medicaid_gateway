# frozen_string_literal: true

module Publishers
  # Publisher will send account transfer payload to EA
  class TrasnferPublisher
    include ::EventSource::Publisher[amqp: 'magi_medicaid.atp.enroll']

    register_event 'transfer_in'
  end
end