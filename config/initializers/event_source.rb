# frozen_string_literal: true

EventSource.configure do |config|
  config.protocols = %w[amqp http]
  config.pub_sub_root = Pathname.pwd.join('app', 'event_source')
  config.server_key = ENV['RAILS_ENV'] || Rails.env.to_sym
  config.app_name = :medicaid_gateway

  config.servers do |server|
    server.http do |http|
      http.ref = 'http://mitc:3001'
      http.host = ENV['MITC_HOST'] || 'http://localhost'
      http.port = ENV['MITC_PORT'] || '3000'
      http.url = ENV['MITC_URL'] || 'http://localhost:3000'
      http.default_content_type = 'application/json'
    end

    server.amqp do |rabbitmq|
      rabbitmq.ref = 'amqp://rabbitmq:5672/event_source'
      rabbitmq.host = ENV['RABBITMQ_HOST'] || 'amqp://localhost'
      warn rabbitmq.host
      rabbitmq.vhost = ENV['RABBITMQ_VHOST'] || '/'
      warn rabbitmq.vhost
      rabbitmq.port = ENV['RABBITMQ_PORT'] || '5672'
      warn rabbitmq.port
      rabbitmq.url = ENV['RABBITMQ_URL'] || 'amqp://localhost:5672/'
      warn rabbitmq.url
      rabbitmq.user_name = ENV['RABBITMQ_USERNAME'] || 'guest'
      warn rabbitmq.user_name
      rabbitmq.password = ENV['RABBITMQ_PASSWORD'] || 'guest'
      warn rabbitmq.password
      rabbitmq.default_content_type =
        ENV['RABBITMQ_CONTENT_TYPE'] || 'application/json'
    end
  end

  async_api_resources =
    ::AcaEntities.async_api_config_find_by_service_name(
      { protocol: :amqp, service_name: nil }
    ).success +
      ::AcaEntities.async_api_config_find_by_service_name(
        { protocol: :http, service_name: :medicaid_gateway }
      ).success

  config.async_api_schemas =
    async_api_resources.collect do |resource|
      EventSource.build_async_api_resource(resource)
    end
end

EventSource.initialize!
