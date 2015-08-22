class Datastore
	@@index = Stretcher::Server.new(ENV['ES_URL']).index :cryptcheck
	@@index.create unless @@index.exists?

	def self.host(type, name)
		result = @@index.type(type).get name
		result.date = Time.parse result.date
		result
	rescue Stretcher::RequestError::NotFound
	end

	def self.pending(type, name)
		self.post type, name, { pending: true }
	end

	def self.post(type, name, data)
		data[:date] = DateTime.now
		@@index.type(type).put name, data
	end
end
