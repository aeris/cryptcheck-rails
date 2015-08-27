class HttpsController < CheckController
	protected
	def type
		:https
	end

	def worker
		HTTPSWorker
	end

	def tls_type
		'HTTPS'
	end
end
