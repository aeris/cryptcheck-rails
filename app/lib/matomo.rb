class Matomo
  module Helpers
    def matomo_tag
      config = Matomo
      return unless config.enabled?
      render partial: 'matomo', locals: { config: config }
    end
  end

  cattr_reader :url, :path, :site

  def self.load
    @@url      = ENV.fetch 'MATOMO_URL'
    @@site     = ENV.fetch 'MATOMO_SITE'
    @@disabled = ENV['MATOMO_DISABLED']
  end

  def self.enabled?
    self.url && self.site && @@disabled.nil?
  end

  ActionView::Base.include Helpers
  self.load
end
