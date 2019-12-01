require_relative 'boot'

require 'rails'
%w[
  active_model
  active_record
  action_controller
  action_view
  sprockets
  rails/test_unit
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
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale    = :fr
    config.i18n.available_locales = %w(en fr de)

    config.refresh_delay = 1.hour

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
  end
end
