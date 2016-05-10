class SSHWorker < CheckWorker
	sidekiq_options retry: false

	protected
	def analyze(host, port=22)
		CryptCheck::Ssh.analyze host, port
	end

	def type
		:ssh
	end

	def to_json(server)
		{
				kex:         server.kex,
				encryption:  server.encryption,
				hmac:        server.hmac,
				compression: server.compression,
				key_:         server.key
		}
	end

	def grade_to_json(grade)
		nil
	end
end
