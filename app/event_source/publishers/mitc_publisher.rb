# frozen_string_literal: true

module Publishers
  # Publisher will send request payload to MiTC for determinations
  class MitcPublisher
    include ::EventSource::Publisher[http: '/determinations/eval']

    # register_event '/determinations/eval'
  end
end

