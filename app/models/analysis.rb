class Analysis < ApplicationRecord
	enum service: %i[https smtp xmpp tls ssh].collect { |e| [e, e.to_s] }.to_h
	validates :service, presence: true
	validates :host, presence: true

	def self.[](service, host, port)
		key = self.key service, host, port
		self.find_by key
	end

	def self.pending!(service, host, port)
		key      = self.key service, host, port
		analysis = self.find_or_create_by! key
		analysis.pending!
	end

	def pending!
		self.update! pending: true
		self
	end

	def self.post!(service, host, port, result)
		analysis = self[service, host, port]
		analysis.post! result
	end

	def post!(result)
		self.update! pending: false, result: result
	end

	private

	def self.key(service, host, port)
		{ service: service, host: host, port: port }
	end
end
