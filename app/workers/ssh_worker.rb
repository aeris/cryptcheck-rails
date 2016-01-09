class SSHWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(host, port=nil)
		host    = SimpleIDN.to_ascii host.downcase
		result = begin
			server = CryptCheck::Ssh::Server.new *(port ? [host, port] : [host])
			{
					kex:         server.kex,
					encryption:  server.encryption,
					hmac:        server.hmac,
					compression: server.compression,
					key:         server.key
			}
		rescue CryptCheck::Ssh::Server::SshNotAvailableException
			{ no_tls: true }
		end
		Datastore.post :ssh, "#{host}:#{port}", result
	end
end
