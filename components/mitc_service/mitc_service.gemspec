# frozen_string_literal: true

require_relative 'lib/mitc_service/version'

Gem::Specification.new do |spec|
  spec.name = 'mitc_service'
  spec.version = MitcService::VERSION
  spec.authors = ['Dan Thomas']
  spec.email = ['info@ideacrew.com']
  spec.homepage = 'https://github.com/ideacrew/medicaid_gateway'
  spec.summary = 'MitcService integrates with MAGI in the Cloud Application'
  spec.description = 'MitcService integrates with MAGI in the Cloud Application'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.6'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files =
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'dry-events', '~> 0.3'
  spec.add_dependency 'dry-initializer', '~> 3.0'
  spec.add_dependency 'dry-monads', '~> 1.3'
  spec.add_dependency 'dry-schema', '~> 1.5'
  spec.add_dependency 'dry-struct', '~> 1.4'
  spec.add_dependency 'dry-transaction', '~> 0.13'
  spec.add_dependency 'dry-types', '~> 1.5'
  spec.add_dependency 'dry-validation', '~> 1.6'
  spec.add_dependency 'httparty', '~> 0.16'
  spec.add_dependency 'mime-types'
  spec.add_dependency 'mongoid', '~> 7.5.4'

  spec.add_dependency 'rails', '~> 7.0.8.4'

  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'yard'
end
