class SMTPWorker < CheckWorker
	sidekiq_options retry: false

	protected
	def module
		CryptCheck::Tls::Smtp
	end

	def type
		:smtp
	end
end
