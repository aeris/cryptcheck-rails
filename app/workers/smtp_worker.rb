class SMTPWorker < CheckWorker
	sidekiq_options retry: false

	protected
	def analyze(host)
		CryptCheck::Tls::Smtp.analyze host
	end

	def type
		:smtp
	end
end
