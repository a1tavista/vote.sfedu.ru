source 'https://rubygems.org'

ruby '2.4.1'

gem 'active_link_to'
gem 'autoprefixer-rails'
gem 'bourbon', '~> 5.0.0.beta.7'
gem 'bitters'
gem 'cancancan'
gem 'devise'
gem 'devise_openid_authenticatable', git: 'https://github.com/a1tavista/devise_openid_authenticatable.git'
gem 'high_voltage'
gem 'normalize-rails', '~> 3.0.0'
gem 'pg'
gem 'puma'
gem 'rack-canonical-host'
gem 'rails', '~> 5.1'
gem 'recipient_interceptor'
gem 'responders'
gem 'rollbar'
gem 'ruby-openid'
gem 'sass-rails', '~> 5.0'
gem 'savon'
gem 'slim-rails'
gem 'sprockets', '>= 3.0.0'
gem 'uglifier'

group :development do
  gem 'listen'
end

group :development, :test do
  gem 'awesome_print'
  gem 'bullet'
  gem 'bundler-audit', '>= 0.5.0', require: false
  gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.5.0.beta4'
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
  gem 'rack-timeout'
  gem 'rails_stdout_logging'
end
