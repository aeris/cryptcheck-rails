class CheckWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def key_to_json(key)
		key.nil? ? nil : { type: key.type, size: key.size }
	end

	def perform(host, port=nil)
		host          = SimpleIDN.to_ascii host.downcase
		result        = self.analyze *(port ? [host, port] : [host])
		result        = result.to_h
		result[:date] = DateTime.now
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
				rank: grade.grade,
		}
	end
end
