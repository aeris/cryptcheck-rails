class XMPPWorker < CheckWorker
	sidekiq_options retry: false

	protected
	def module
		CryptCheck::Tls::Xmpp
	end

	def type
		:xmpp
	end
end
