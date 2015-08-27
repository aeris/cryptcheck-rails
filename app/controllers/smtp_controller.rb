class SmtpController < CheckController
	protected
	def type
		:smtp
	end

	def worker
		SMTPWorker
	end

	def tls_type
		'STARTTLS'
	end
end
