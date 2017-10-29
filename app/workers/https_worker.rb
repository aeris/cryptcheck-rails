class HTTPSWorker < CheckWorker
	sidekiq_options retry: false

	protected
	def analyze(host, port=443)
		CryptCheck::Tls::Https.analyze host, port
	end

	def type
		:https
	end
end
