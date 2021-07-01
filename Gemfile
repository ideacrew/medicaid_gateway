# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

# Mount the Engines
gem 'mitc_service', path: 'components/mitc_service'

gem 'aca_entities',  git:  'https://github.com/ideacrew/aca_entities.git', branch: 'trunk'
gem 'event_source',  git:  'https://github.com/ideacrew/event_source.git', branch: 'release_0.5.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

gem 'resource_registry',  git:  'https://github.com/ideacrew/resource_registry.git', branch: 'trunk'

gem 'mongoid',             '~> 7.2.1'
gem "faraday", "~> 1.4.1"
gem 'typhoeus'
gem 'mime-types'
gem 'httparty',            '~> 0.16'
gem 'nokogiri', '>= 1.10.8', platforms: [:ruby, :mri]

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'factory_bot_rails',  '~> 6.2'
  gem 'pry-byebug'
  gem 'rspec-rails',            '~> 4.0'
  gem 'shoulda-matchers',       '~> 3'
  gem 'yard'
end

group :development do
  gem 'rubocop', '~> 1.13.0'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0', require: false
  gem 'listen', '~> 3.3'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'database_cleaner', '~> 1.7'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :production do
  gem 'eye',     '0.10.0'
  gem 'unicorn', '~> 4.8'
end
