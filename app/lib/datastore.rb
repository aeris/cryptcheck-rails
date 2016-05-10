class Datastore
	@@index = Stretcher::Server.new(ENV['ES_URL']).index :cryptcheck
	@@index.create unless @@index.exists?

	def self.host(type, host, port)
		key = self.key host, port
		result = @@index.type(type).get key
		result.date = Time.parse result.date
		result
	rescue Stretcher::RequestError::NotFound
	end

	def self.pending(type, host, port)
		self.post type, host, port, { pending: true, date: DateTime.now }
	end

	def self.post(type, host, port, data)
		key = self.key host, port
		@@index.type(type).put key, data
	end

	private
	def self.key(host, port)
		host = "#{host}:#{port}" if port
		host
	end
end
