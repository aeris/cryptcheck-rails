class XMPPWorker < CheckWorker
	sidekiq_options retry: false

	protected
	def analyze(host)
		CryptCheck::Tls::Xmpp.analyze host
	end

	def type
		:xmpp
	end
end
