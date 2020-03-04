source 'https://rubygems.org'

ruby '2.4.3'

gem 'active_link_to'
gem 'active_interaction'
gem 'autoprefixer-rails'
gem 'bootstrap', '~> 4.0.0'
gem 'bourbon', '~> 5.0.0.beta.7'
gem 'bitters'
gem 'cancancan'
gem 'clowne'
gem 'devise'
gem 'devise_openid_authenticatable', git: 'https://github.com/a1tavista/devise_openid_authenticatable.git', ref: '35e7d83'
gem 'high_voltage'
gem 'jquery-rails'
gem 'nested_form_fields'
gem 'normalize-rails', '~> 3.0.0'
gem 'pg'
gem 'puma'
gem 'rack-canonical-host'
gem 'rails', '~> 5.1'
gem 'rails_event_store'
gem 'ransack'
gem 'recipient_interceptor'
gem 'responders'
gem 'ruby-openid'
gem 'kaminari'
gem 'sass-rails', '~> 5.0'
gem 'savon'
gem 'sentry-raven'
gem 'slim-rails'
gem 'sidekiq'
gem 'sprockets', '>= 3.0.0'
gem 'uglifier'
gem 'webpacker'
gem 'write_xlsx'
gem 'jbuilder'

group :development do
  gem 'listen'
end

group :development, :test do
  gem 'awesome_print'
  gem 'bullet'
  gem 'bundler-audit', '>= 0.5.0', require: false
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.5.0.beta4'
  gem 'web-console'
end

group :development, :staging do
  gem 'rack-mini-profiler', require: false
end

group :test do
  gem 'database_cleaner'
  gem 'faker'
  gem 'formulaic'
  gem 'launchy'
  gem 'mocha'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'webmock'
end

group :staging, :production do
  gem 'rails_stdout_logging'
end
