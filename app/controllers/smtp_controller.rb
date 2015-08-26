class SmtpController < CheckController
	protected
	def type
		:smtp
	end

	def worker
		SMTPWorker
	end
end
