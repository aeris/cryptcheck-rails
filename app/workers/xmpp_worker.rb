class XMPPWorker < CheckWorker
	sidekiq_options retry: false

	protected
	def analyze(host, type)
		CryptCheck::Tls::Xmpp.analyze host, type
	end

	def type
		:xmpp
	end
end
