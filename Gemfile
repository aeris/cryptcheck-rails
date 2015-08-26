source 'https://rubygems.org'

gem 'rails', '4.2.1'

gem 'cryptcheck', '~> 1.0.0', path: File.expand_path(File.join File.dirname(__FILE__), '../cryptcheck')
gem 'sidekiq', '~> 3.4.2'
gem 'stretcher', '~> 1.21.1'
gem 'faraday', '~> 0.8.9' # For stretcher compatibility
gem 'simpleidn', '~> 0.0.5'

group :assets do
	gem 'therubyracer', platforms: :ruby
	gem 'uglifier'

	gem 'sass-rails', '~> 5.0.3'
	gem 'coffee-rails', '~> 4.1.0'
	gem 'jquery-rails', '~> 4.0.4'
	gem 'bootstrap-sass', '~> 3.3.5'
	gem 'font-awesome-sass', '~> 4.4.0'
end

group :development, :test do
	gem 'puma'
	gem 'byebug'
	gem 'web-console'
	gem 'spring'

	gem 'debase'
	gem 'ruby-debug-ide'
	gem 'pry-rails'

	gem 'better_errors'
	gem 'binding_of_caller'
	gem 'quiet_assets'

	gem 'guard-livereload', require: false
	gem 'rack-livereload'
end

