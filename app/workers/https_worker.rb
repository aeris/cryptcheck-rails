class HTTPSWorker < CheckWorker
	sidekiq_options retry: false

	protected
	def module
		CryptCheck::Tls::Https
	end

	def type
		:https
	end

	def result(server, _, hash)
		hash[:hsts] = server.hsts
		hash
	end
end
