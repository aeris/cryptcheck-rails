class Analysis < ApplicationRecord
	enum service: %i[https smtp xmpp tls ssh].collect { |e| [e, e.to_s] }.to_h
	validates :service, presence: true
	validates :host, presence: true

	def self.[](service, host, args)
		key = self.key service, host, args
		self.find_by key
	end

	def self.pending!(service, host, args)
		key      = self.key service, host, args
		analysis = self.find_or_create_by! key
		analysis.pending!
	end

	def pending!
		self.update! pending: true
		self
	end

	def self.post!(service, host, args, result)
		analysis = self[service, host, args]
		analysis.post! result
	end

	def post!(result)
		self.update! pending: false, result: result
	end

	private

	def self.key(service, host, args)
		{ service: service, host: host, args: args }
	end
end
