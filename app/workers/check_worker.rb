class CheckWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def key_to_json(key)
		key.nil? ? nil : { type: key.type, size: key.size, rsa_size: key.rsa_equivalent_size }
	end

	def perform(host, port=nil)
		host   = SimpleIDN.to_ascii host.downcase
		hosts  = self.analyze *(port ? [host, port] : [host])
		hosts  = hosts.collect do |host, result|
			name, ip, p = host
			host           = { name: name, ip: ip, port: p }

			if result.is_a? CryptCheck::AnalysisFailure
				next {
						host:  host,
						error: result.to_s
				}
			end

			grade  = result
			server = grade.server
			{
					host:      host,
					handshake: to_json(server),
					grade: grade_to_json(grade)
			}
		end
		result = { date: DateTime.now, hosts: hosts }
		Datastore.post self.type, host, port, result
	end

	protected
	def to_json(server)
		{
				key:       key_to_json(server.key),
				dh:        server.dh.collect { |k| key_to_json k },
				protocols: server.supported_protocols,
				ciphers:   server.supported_ciphers.collect { |c| { protocol: c.protocol, name: c.name, size: c.size, dh: key_to_json(c.dh) } },

		}
	end

	private
	def grade_to_json(grade)
		{
				rank:    grade.grade,
				details: {
						score:            grade.score,
						protocol:         grade.protocol_score,
						key_exchange:     grade.key_exchange_score,
						cipher_strengths: grade.cipher_strengths_score
				},
				error:   grade.error,
				danger:  grade.danger,
				warning: grade.warning,
				success: grade.success
		}
	end
end
