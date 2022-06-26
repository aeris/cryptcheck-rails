class Analysis < ApplicationRecord
  enum service: %i[https smtp xmpp tls ssh].collect { |e| [e, e.to_s] }.to_h
  validates :service, presence: true
  validates :host, presence: true

  def self.[](service, host, args)
    key = self.key service, host, args
    self.find_by key
  end

  def self.pending!(service, host, args)
    key      = self.key service, host, args
    analysis = self.find_or_create_by! key
    analysis.pending!
  end

  def pending!
    self.update! pending: true
    self
  end

  def self.post!(service, host, args, result)
    analysis = self[service, host, args]
    analysis.post! result
  end

  RESOLVER              = ::Resolv::DNS.new
  DNS_TXT_FORMAT        = /^cryptcheck=(.*)/
  DEBUG                 = 'debug'
  DEFAULT_REFRESH_DELAY = Rails.configuration.refresh_delay

  def find_refresh_delay
    host = self.host
    loop do
      break unless host && PublicSuffix.valid?(host)
      RESOLVER.getresources(host, ::Resolv::DNS::Resource::IN::TXT).each do |txt|
        txt.strings.each do |value|
          if match = DNS_TXT_FORMAT.match(value)
            match = match[1]
            return if match == DEBUG
            begin
              delay = ::ActiveSupport::Duration.parse match
              delay = DEFAULT_REFRESH_DELAY if delay > DEFAULT_REFRESH_DELAY
              return delay
            rescue ActiveSupport::Duration::ISO8601Parser::ParsingError
            end
          end
        end
      end
      _, host = host.split '.', 2
    end
    DEFAULT_REFRESH_DELAY
  rescue
    DEFAULT_REFRESH_DELAY
  end

  def post!(result)
    refresh_at = self.find_refresh_delay&.since
    self.update! pending: false, refresh_at: refresh_at, result: result
  end

  private

  def self.key(service, host, args)
    { service: service, host: host, args: args }
  end
end
