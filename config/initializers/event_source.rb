# frozen_string_literal: true

EventSource.configure do |config|
  config.protocols = %w[amqp http]
  config.pub_sub_root =
    Pathname.pwd.join('spec', 'rails_app', 'app', 'event_source')

  config.server_key = ENV['RAILS_ENV'] # production, development# Rails.env.to_sym

  config.servers do |server|


    server.amqp do |rabbitmq|
      rabbitmq.host = ENV['RABBITMQ_HOST'] || "amqp://amqp"
      rabbitmq.vhost = ENV['RABBITMQ_VHOST'] || "event_source"
      rabbitmq.port = ENV['RABBITMQ_PORT'] || "5672"
      rabbitmq.url = ENV['RABBITMQ_URL'] || ""
      rabbitmq.user_name = ENV['RABBITMQ_USERNAME'] || "guest"
      rabbitmq.password = ENV['RABBITMQ_PASSWORD'] || "guest"
      # rabbitmq.url = "" # ENV['RABBITMQ_URL']
    end
  end

  app_schemas = Gem.loaded_specs.values.inject([]) do |ps, s|
    ps.concat(s.matches_for_glob("aca_entities/async_api/medicaid_gateway/amqp.yml"))
  end

  config.async_api_schemas = app_schemas.map do |schema|
    EventSource::AsyncApi::Operations::AsyncApiConf::LoadPath.new.call(path: schema).success.to_h
  end

  # config.asyncapi_resources = [AcaEntities::AsyncApi::MedicaidGataway]
  # config.asyncapi_resources = AcaEntities.find_resources_for(:enroll, %w[amqp resque_bus]) # will give you resouces in array of hashes form
  # AcaEntities::Operations::AsyncApi::FindResource.new.call(self)
end

EventSource.initialize!
