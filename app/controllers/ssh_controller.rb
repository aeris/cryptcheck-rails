class SshController < CheckController
	protected
	def type
		:ssh
	end

	def worker
		SSHWorker
	end

	def tls_type
		'SSH'
	end

	def default_port
		22
	end
end
