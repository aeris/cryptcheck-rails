class CheckWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(host, port)
		# analysis = Analysis.pending self.type, host, port
		host   = SimpleIDN.to_ascii host.downcase
		result = self.analyze host, port
		Analysis.post! self.type, host, port, result
	end
end
