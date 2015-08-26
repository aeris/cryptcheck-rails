class XmppController < CheckController
	protected
	def type
		:xmpp
	end

	def worker
		XMPPWorker
	end
end
