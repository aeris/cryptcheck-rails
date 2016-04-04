class HTTPSWorker < CheckWorker
	sidekiq_options retry: false

	protected
	def analyze(host, port=443)
		CryptCheck::Tls::Https.analyze host, port
	end

	def type
		:https
	end

	def result(server, _, hash)
		hash[:hsts] = server.hsts
		hash
	end
end
