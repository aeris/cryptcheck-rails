require File.expand_path('../boot', __FILE__)

%w(
  action_controller
  action_view
  active_job
  rails/test_unit
  sprockets
).each do |framework|
	begin
		require "#{framework}/railtie"
	rescue LoadError
	end
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
groups = Rails.groups
unless Rails.env == 'production'
	groups << :assets
	Rails.env = 'production' if Rails.env == 'staging'
end
Bundler.require(*groups)

module CryptcheckRails
	class Application < Rails::Application
		# Settings in config/environments/* take precedence over those specified here.
		# Application configuration should go into files in config/initializers
		# -- all .rb files in that directory are automatically loaded.

		# Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
		# Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
		# config.time_zone = 'Central Time (US & Canada)'

		# The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
		# config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
		config.i18n.default_locale = :fr
		config.action_controller.include_all_helpers = false

		config.refresh_delay = 1.hour
	end
end
