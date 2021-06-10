# frozen_string_literal: true

EventSource.configure do |config|
  config.protocols = %w[amqp http]
  config.pub_sub_root =
    Pathname.pwd.join('spec', 'rails_app', 'app', 'event_source')

  # config.environment = Rails.env

  config.servers do |server|
    # - RABBITMQ_HOST=""
    # - RABBITMQ_PORT=""
    # - RABBITMQ_URL=${RABBITMQ_URL:-amqp://guest:guest@amqp:5672}
    # - RABBITMQ_VERSION=""
    # - RABBITMQ_USERNAME=${RABBITMQ_USERNAME:-guest}
    # - RABBITMQ_PASSWORD=${RABBITMQ_PASSWORD:-guest}
    server.amqp do |rabbitmq|
      rabbitmq.environment = :production
      rabbitmq.host = ENV['RABBITMQ_HOST']
      rabbitmq.vhost = ENV['RABBITMQ_VHOST']
      rabbitmq.port = ENV['RABBITMQ_PORT']
      rabbitmq.user_name = ENV['RABBITMQ_USERNAME']
      rabbitmq.password = ENV['RABBITMQ_PASSWORD']

      # rabbitmq.url = "" # ENV['RABBITMQ_URL']
    end
  end
  mg_schemas = Gem.loaded_specs.values.inject([]) do |ps,s|
    ps.concat(s.matches_for_glob("aca_entities/async_api/medicaid_gateway.yml"))
  end
  config.async_api_schemas = mg_schemas
end


EventSource.initialize!
