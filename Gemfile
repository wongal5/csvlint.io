source 'https://rubygems.org'
ruby '2.4.10'

gem 'rake', '~> 13.0'
gem 'rails', '~> 4.2'
gem 'dotenv-rails'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 6.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.2'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.9'

gem 'sdoc', '~> 1.1', group: :doc

gem 'foreman'

group :production do
  gem 'thin'
  gem 'rails_12factor'
  gem 'puma'
end

group :development, :test do
  gem 'rspec-rails', "< 4" # version 4 requires rails 5
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'coveralls', require: false
  gem 'simplecov', '~> 0.16'
  gem 'guard-rspec'
  gem 'guard-cucumber'
  gem 'guard-bundler'
  gem 'webmock', require: false
  gem 'pry'
  gem 'timecop'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'poltergeist'
  gem 'vcr'
  gem 'cucumber-api-steps', require: false, git: 'https://github.com/theodi/cucumber-api-steps.git', branch: 'feature-test-content-type'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

group :development do
  gem 'travis'
  gem 'web-console', '~> 3.3'
  gem 'spring'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

gem 'bootstrap-sass', '~> 3.4'
gem 'rack-google-analytics'
gem 'mongoid', '~> 5.1'
gem 'kaminari-mongoid'
gem 'bson', '~> 3.2'
gem 'mongoid-grid_fs', '~> 2.4'
gem 'bson_ext'
gem 'kaminari'
gem 'bootstrap-kaminari-views'
gem 'data_kitten', git: 'https://github.com/theodi/data_kitten.git', ref: "e343510bd15e3329c1f2fab35035e248195348be", require: false
gem 'rubyzip'

gem 'csvlint', '~> 0.4'
gem 'datapackage', '0.0.4' # temporarily pinned to avoid breaking the build
gem 'rest-client'

gem 'nokogiri', '~> 1.8'

gem 'airbrake'
gem 'font-awesome-rails'
gem 'sidekiq', '~> 5.2'
gem 'data_uri'
gem 'jquery-dotdotdot-rails'
gem 'alternate_rails', git: 'https://github.com/theodi/alternate-rails.git', ref: 'v4.2.0'
gem 'rack-cors'

gem 'resumable_upload', git: 'https://github.com/theodi/resumable-upload'
gem 'pusher'
gem 'cloudflare'
