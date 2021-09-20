# frozen_string_literal: true

module Publishers
    # Publisher will send MEC check results payload to EA
    class MecCheckPublisher
      include ::EventSource::Publisher[amqp: 'magi_medicaid.mec_check.enroll']
  
      register_event 'mec_checked'
    end
  end