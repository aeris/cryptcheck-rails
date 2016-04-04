class SMTPWorker < CheckWorker
	sidekiq_options retry: false

	protected
	def analyze(host, port=25)
		CryptCheck::Tls::Smtp.analyze host, port
	end

	def type
		:smtp
	end
end
