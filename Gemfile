source 'https://rubygems.org'

gem 'rails'

gem 'cryptcheck', '~> 2.0.0', path: File.expand_path(File.join File.dirname(__FILE__), '../cryptcheck')

gem 'dotenv-rails'
gem 'http_accept_language'
gem 'mongoid'
gem 'simpleidn'

gem 'redis-namespace'
gem 'sidekiq'

group :assets do
	gem 'therubyracer', platforms: :ruby
	gem 'uglifier'

	gem 'bootstrap-sass'
	gem 'coffee-rails'
	gem 'font-awesome-sass'
	gem 'jquery-rails'
	gem 'sass-rails'
end

group :development, :test do
	gem 'awesome_print'
	gem 'puma'
	gem 'web-console'

	gem 'pry-rails'

	gem 'better_errors'
	gem 'binding_of_caller'
	gem 'quiet_assets'

	gem 'guard', require: false
	gem 'guard-livereload', require: false
	gem 'rack-livereload'
end

