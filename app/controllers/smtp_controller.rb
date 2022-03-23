class SmtpController < CheckController
	protected
	def type
		:smtp
	end

	def tls_type
		'STARTTLS'
	end
end
