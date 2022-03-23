require 'simpleidn'

class CheckJob
  include Sidekiq::Workflow::Worker
  sidekiq_options queue: :tls_1_0, retry: false

  def perform(type, host, *args, **_)
    host   = SimpleIDN.to_ascii host.downcase
    result = self.analyze type, host, *args
    args   = nil if args.empty?
    set_payload({ type: type, host: host, args: args, result: result })
  end

  def analyze(type, *args)
    case type.to_sym
    when :https
      CryptCheck::Tls::Https.analyze *args
    when :smtp
      CryptCheck::Tls::Smtp.analyze *args
    when :xmpp
      CryptCheck::Tls::Xmpp.analyze *args
    when :tls
      CryptCheck::Tls.analyze *args
    when :ssh
      CryptCheck::Ssh.analyze *args
    else
      raise "Unsupported analysis #{type}"
    end
  end
end
