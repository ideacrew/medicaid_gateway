# frozen_string_literal: true

EventSource.configure do |config|
  config.protocols = %w[amqp http]
  config.pub_sub_root = Pathname.pwd.join('app', 'event_source')
  config.server_key = ENV['RAILS_ENV'] || Rails.env.to_sym
  config.app_name = :medicaid_gateway

  config.servers do |server|

    server.http do |http|
      http.host = ENV['MITC_HOST'] || "http://localhost"
      http.port = ENV['MITC_PORT'] || "3000"
      http.url = ENV['MITC_URL'] || "http://localhost:3000"
    end

    server.amqp do |rabbitmq|
      rabbitmq.host = ENV['RABBITMQ_HOST'] || "amqp://localhost"
      warn rabbitmq.host
      rabbitmq.vhost = ENV['RABBITMQ_VHOST'] || "/"
      warn rabbitmq.vhost
      rabbitmq.port = ENV['RABBITMQ_PORT'] || "5672"
      warn rabbitmq.port
      rabbitmq.url = ENV['RABBITMQ_URL'] || "amqp://localhost:5672"
      warn rabbitmq.url
      rabbitmq.user_name = ENV['RABBITMQ_USERNAME'] || "guest"
      warn rabbitmq.user_name
      rabbitmq.password = ENV['RABBITMQ_PASSWORD'] || "guest"
      warn rabbitmq.password
    end
  end

  config.async_api_schemas =
    if Rails.env.test? || ENV['RABBITMQ_HOST'].nil?
      publishers_dir = Pathname.pwd.join('spec', 'async_api_resources', 'publishers')
      resource_files = ::Dir[::File.join(publishers_dir, '**', '*')].reject { |p| ::File.directory? p }

      subscribers_dir = Pathname.pwd.join('spec', 'async_api_resources', 'subscribers')
      resource_files += ::Dir[::File.join(subscribers_dir, '**', '*')].reject { |p| ::File.directory? p }

      resource_files.collect do |file|
        EventSource::AsyncApi::Operations::AsyncApiConf::LoadPath.new.call(path: file).success.to_h
      end
    else
      ::AcaEntities.async_api_config_find_by_service_name(nil).success
    end
end

EventSource.initialize!
