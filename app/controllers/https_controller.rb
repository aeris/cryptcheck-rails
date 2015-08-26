class HttpsController < CheckController
	protected
	def type
		:https
	end

	def worker
		HTTPSWorker
	end
end
