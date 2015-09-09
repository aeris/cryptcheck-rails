class HTTPSWorker < CheckWorker
	sidekiq_options retry: false

	protected
	def server
		CryptCheck::Tls::Https::Server
	end
	def grade
		CryptCheck::Tls::Https::Grade
	end

	def type
		:https
	end

	def result(server, _, hash)
		hash[:hsts] = server.hsts
		hash
	end
end
