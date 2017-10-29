class Analysis
	include Mongoid::Document
	include Mongoid::Timestamps

	field :type, type: Symbol
	field :host, type: String
	field :port, type: Numeric
	field :pending, type: Boolean
	field :date, type: Time
	field :result, type: Array

	validates_presence_of :type
	validates_presence_of :host
	validates_presence_of :port
	validates_uniqueness_of :type, scope: %i[host port]

	index type: 1
	index({ type: 1, host: 1, port: 1 }, { unique: true })

	def self.[](type, host, port)
		key = self.key type, host, port
		self.where(key).first
	end

	def self.pending(type, host, port)
		analysis = self[type, host, port]
		if analysis
			analysis.remove_attribute :result
			analysis.update_attributes pending: true, date: Time.now
			analysis
		else
			self.create! type: type, host: host, port: port, pending: true, date: Time.now
		end
	end

	def self.result(type, host, port, result)
		analysis = self[type, host, port]
		if analysis
			analysis.remove_attribute :pending
			analysis.update_attributes result: result, date: Time.now
			analysis
		else
			self.create! type: type, host: host, port: port, result: result, date: Time.now
		end
	end

	def publish(result)
		self.remove_attribute :pending
		self.update_attribute :result, result
	end

	private
	def self.key(type, host, port)
		{ type: type, host: host, port: port }
	end
end
