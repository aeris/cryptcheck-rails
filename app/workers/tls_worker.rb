class TLSWorker < CheckWorker
	sidekiq_options retry: false

	protected
	def server
		CryptCheck::Tls::TcpServer
	end
	def grade
		CryptCheck::Tls::Grade
	end

	def type
		:tls
	end
end
