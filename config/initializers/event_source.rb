# frozen_string_literal: true

EventSource.configure do |config|
  config.protocols = %w[amqp http]
  config.pub_sub_root =
    Pathname.pwd.join('spec', 'rails_app', 'app', 'event_source')

  config.server_key = ENV['RAILS_ENV'] # production, development# Rails.env.to_sym

  config.servers do |server|
    # - RABBITMQ_HOST=""
    # - RABBITMQ_PORT=""
    # - RABBITMQ_URL=${RABBITMQ_URL:-amqp://guest:guest@amqp:5672}
    # - RABBITMQ_VERSION=""
    # - RABBITMQ_USERNAME=${RABBITMQ_USERNAME:-guest}
    # - RABBITMQ_PASSWORD=${RABBITMQ_PASSWORD:-guest}
    # server.amqp do |rabbitmq|
    #   rabbitmq.environment = :production
    #   rabbitmq.host = ENV['RABBITMQ_HOST']
    #   rabbitmq.vhost = ENV['RABBITMQ_VHOST']
    #   rabbitmq.port = ENV['RABBITMQ_PORT']
    #   rabbitmq.user_name = ENV['RABBITMQ_USERNAME']
    #   rabbitmq.password = ENV['RABBITMQ_PASSWORD']

    #   # rabbitmq.url = "" # ENV['RABBITMQ_URL']
    # end

    # server.amqp do |rabbitmq|
    #   rabbitmq.environment = :production
    #   rabbitmq.host = 'amqp://localhost'
    #   rabbitmq.vhost = '/event_source'
    #   rabbitmq.port = '5672'
    #   rabbitmq.url = ''
    #   rabbitmq.user_name = 'guest'
    #   rabbitmq.password = 'guest'
    # end

    server.amqp do |rabbitmq|
      rabbitmq.host = ENV['RABBITMQ_HOST'] || "amqp://localhost"
      STDERR.puts rabbitmq.host
      rabbitmq.vhost = ENV['RABBITMQ_VHOST'] || "/event_source"
      STDERR.puts rabbitmq.vhost
      rabbitmq.port = ENV['RABBITMQ_PORT'] || "5672"
      STDERR.puts rabbitmq.port
      rabbitmq.url = ENV['RABBITMQ_URL'] || ""
      STDERR.puts rabbitmq.url
      rabbitmq.user_name = ENV['RABBITMQ_USERNAME'] || "guest"
      STDERR.puts rabbitmq.user_name
      rabbitmq.password = ENV['RABBITMQ_PASSWORD'] || "guest"
      STDERR.puts rabbitmq.password
      # rabbitmq.url = "" # ENV['RABBITMQ_URL']
    end
  end

  # config.asyncapi_resources = [AcaEntities::AsyncApi::MedicaidGataway]
  # config.asyncapi_resources = AcaEntities.find_resources_for(:enroll, %w[amqp resque_bus]) # will give you resouces in array of hashes form
  # AcaEntities::Operations::AsyncApi::FindResource.new.call(self)
end


dir = Rails.root.join('asyncapi')
EventSource.async_api_schemas = ::Dir[::File.join(dir, '**', '*')].reject { |p| ::File.directory? p }.reduce([]) do |memo, file|
  # read
  # serialize yaml to hash
  # Add to memo
  memo << EventSource::AsyncApi::Operations::AsyncApiConf::LoadPath.new.call(path: file).success.to_h
end

EventSource.initialize!
