class Datastore
	@@index = Stretcher::Server.new(ENV['ES_URL']).index :cryptcheck
	@@index.create unless @@index.exists?

	def self.host(type, host, port)
		result = @@index.type(type).get self.key(host, port)
		result.date = Time.parse result.date
		result
	rescue Stretcher::RequestError::NotFound
	end

	def self.pending(type, host, port)
		self.post type, host, port, { pending: true }
	end

	def self.post(type, host, port, data)
		data[:date] = DateTime.now
		@@index.type(type).put self.key(host, port), data
	end

	private
	def self.key(host, port)
		host = "#{host}:#{port}" if port
		host
	end
end
