class SMTPWorker < CheckWorker
	sidekiq_options retry: false

	protected
	def server
		CryptCheck::Tls::Smtp::Server
	end
	def grade
		CryptCheck::Tls::Smtp::Grade
	end

	def type
		:smtp
	end
end
