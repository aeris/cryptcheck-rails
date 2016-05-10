class SMTPWorker < CheckWorker
	sidekiq_options retry: false

	protected
	def analyze(host)
		CryptCheck::Tls::Smtp.analyze_domain host
	end

	def type
		:smtp
	end
end
