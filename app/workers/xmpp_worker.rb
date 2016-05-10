class XMPPWorker < CheckWorker
	sidekiq_options retry: false

	protected
	def analyze(host)
		CryptCheck::Tls::Xmpp.analyze_domain host
	end

	def type
		:xmpp
	end

	def to_json(server)
		result = super
		result[:required] = server.required?
		result
	end
end
