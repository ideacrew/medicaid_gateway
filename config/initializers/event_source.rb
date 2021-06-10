# frozen_string_literal: true

require 'event_source'

EventSource.configure do |config|
  config.protocols = %w[amqp http]
  config.pub_sub_root = Pathname.pwd.join('components', 'mitc_service', 'app', 'event_source')
  config.server_key = Rails.env.to_sym

  config.servers do |server|
    server.http do |http|
      # TODO: update production URL when go live
      http.host = "http://localhost"
      http.port = "3000"
    end
  end
end

dir = Pathname.pwd.join('components', 'mitc_service', 'app', 'async_api_files')
EventSource.async_api_schemas = ::Dir[::File.join(dir, '**', '*')].reject { |p| ::File.directory? p }.reduce([]) do |memo, file|
  memo << EventSource::AsyncApi::Operations::AsyncApiConf::LoadPath.new.call(path: file).success.to_h
end

EventSource.initialize!
