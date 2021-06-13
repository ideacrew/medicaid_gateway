# frozen_string_literal: true

EventSource.configure do |config|
  config.protocols = %w[amqp http]
  config.pub_sub_root = Pathname.pwd.join('app', 'event_source')
  config.server_key = ENV['RAILS_ENV'] || Rails.env.to_sym

  config.servers do |server|
    server.http do |http|
      # TODO: update production URL when go live
      http.host = "http://localhost"
      http.port = "3000"
      http.url = "http://localhost:3000"
    end

    server.amqp do |rabbitmq|
      rabbitmq.host = ENV['RABBITMQ_HOST'] || "amqp://rabbitmq"
      STDERR.puts rabbitmq.host
      rabbitmq.vhost = ENV['RABBITMQ_VHOST'] || "event_source"
      STDERR.puts rabbitmq.vhost
      rabbitmq.port = ENV['RABBITMQ_PORT'] || "5672"
      STDERR.puts rabbitmq.port
      rabbitmq.url = ENV['RABBITMQ_URL'] || "amqp://rabbitmq:5672"
      STDERR.puts rabbitmq.url
      rabbitmq.user_name = ENV['RABBITMQ_USERNAME'] || "guest"
      STDERR.puts rabbitmq.user_name
      rabbitmq.password = ENV['RABBITMQ_PASSWORD'] || "guest"
      STDERR.puts rabbitmq.password
      # rabbitmq.url = "" # ENV['RABBITMQ_URL']
    end
  end

  config.async_api_schemas = ::AcaEntities.async_api_config_find_by_service_name('medicaid_gateway').success
end

EventSource.initialize!
