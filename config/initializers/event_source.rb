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
      rabbitmq.host = ENV['RABBITMQ_HOST'] || "amqp://localhost"
      rabbitmq.vhost = ENV['RABBITMQ_VHOST'] || "/event_source"
      rabbitmq.port = ENV['RABBITMQ_PORT'] || "5672"
      rabbitmq.url = ENV['RABBITMQ_URL'] || ""
      rabbitmq.user_name = ENV['RABBITMQ_USERNAME'] || "guest"
      rabbitmq.password = ENV['RABBITMQ_PASSWORD'] || "guest"

      # rabbitmq.url = "" # ENV['RABBITMQ_URL']
    end
  end
  mg_schemas = Gem.loaded_specs.values.inject([]) do |ps, s|
    ps.concat(s.matches_for_glob("aca_entities/async_api/medicaid_gateway.yml"))
  end
  config.async_api_schemas = mg_schemas.map do |mgs|
    EventSource::AsyncApi::Operations::AsyncApiConf::LoadPath.new.call(path: mgs).success.to_h
  end
end

EventSource.initialize!
