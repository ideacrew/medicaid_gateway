# frozen_string_literal: true

MedicaidGatewayRegistry = ResourceRegistry::Registry.new

MedicaidGatewayRegistry.configure do |config|
  config.name       = :medicaid_gateway
  config.created_at = DateTime.now
  config.load_path  = Rails.root.join('system', 'config', 'templates', 'features').to_s
end
