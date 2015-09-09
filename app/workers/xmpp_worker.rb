class XMPPWorker < CheckWorker
	sidekiq_options retry: false

	protected
	def server
		CryptCheck::Tls::Xmpp::Server
	end
	def grade
		CryptCheck::Tls::Xmpp::Grade
	end

	def type
		:xmpp
	end
end
