require File.expand_path('../boot', __FILE__)

require 'rails'
%w[
  active_model
  active_record
  action_controller
  action_view
  rails/test_unit
  sprockets
].each do |framework|
	begin
		require "#{framework}/railtie"
	rescue LoadError
	end
end

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require *Rails.groups

module CryptcheckRails
	class Application < Rails::Application
		config.load_defaults 5.2

		# Settings in config/environments/* take precedence over those specified here.
		# Application configuration should go into files in config/initializers
		# -- all .rb files in that directory are automatically loaded.

		# Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
		# Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
		# config.time_zone = 'Central Time (US & Canada)'

		# The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
		# config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
		config.i18n.default_locale                   = :fr
		config.i18n.available_locales                = %w(en fr de)
		config.action_controller.include_all_helpers = false

		config.refresh_delay = 1.hour

		config.generators do |g|
			g.orm :active_record, primary_key_type: :uuid
		end
	end
end
