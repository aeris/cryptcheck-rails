class TLSWorker < CheckWorker
	sidekiq_options retry: false

	protected
	def analyze(host, port)
		CryptCheck::Tls.analyze host, port
	end

	def type
		:tls
	end
end
