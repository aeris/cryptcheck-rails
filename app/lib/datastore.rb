class Datastore
	@@client = Mongo::Client.new ENV['MONGO_URL']

	def self.host(type, host, port)
		key = self.key host, port
		@@client[type].find(key).first
#		result = @@index.type(type).get key
#		result.date = Time.parse result.date
#		result
	end

	def self.pending(type, host, port)
		self.post type, host, port, { pending: true, date: DateTime.now }
	end

	def self.post(type, host, port, data)
		# entry = self.host type, host, port
		# entry.delete if entry
		#
		key = self.key host, port
		data = data.merge key
		@@client[type].update_one key, data, {upsert: true}
	end

	private
	def self.key(host, port)
		{ host: host, port: port }
	end
end
