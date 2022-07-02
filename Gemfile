source 'https://rubygems.org'

gem 'rails', '~> 7.0'
gem 'puma'
gem 'bootsnap', require: false
gem 'dotenv-rails'
gem 'webpacker'

gem 'sentry-ruby'
gem 'sentry-rails'
gem 'sentry-sidekiq'

gem 'pg'
gem 'sidekiq'
gem 'sidekiq-workflow', git: 'https://git.imirhil.fr/aeris/sidekiq-workflow.git', branch: :master

gem 'simpleidn'
gem 'http_accept_language'
gem 'recursive-open-struct'
gem 'ruby-progressbar'
gem 'public_suffix'
gem 'amazing_print'

gem 'uglifier'
gem 'sass-rails'
gem 'jquery-rails'
gem 'bootstrap-sass'
gem 'font-awesome-sass'

gem 'cryptcheck', '~> 2.0.0', path: '../engine'

group :development do
  gem 'foreman'

  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'

  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'guard', require: false
  gem 'guard-rails', require: false
  gem 'guard-livereload', require: false
  gem 'rack-livereload'
end

group :development, :test do
  gem 'pry-byebug'
end

group :test do
  gem 'rspec-rails'
end
