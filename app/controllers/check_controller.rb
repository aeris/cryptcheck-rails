class CheckController < ApplicationController
	before_action :check_host, except: %i(index)
	helper_method :tls_type, :type

	def show
		enqueue_host unless @result
		@host = SimpleIDN.to_unicode @host
		return render :processing if @result.pending
		return render :no_tls if @result.no_tls
	end

	def refresh
		unless @result.pending
			refresh_allowed = @result.date + Rails.configuration.refresh_delay
			if Time.now < refresh_allowed
				flash[:warning] = "Merci d’attendre au moins #{l refresh_allowed} pour rafraîchir"
				return redirect_to action: :show, id: @host
			end
			enqueue_host
		end
		redirect_to action: :show
	end

	protected
	def enqueue_host
		Datastore.pending self.type, @id, @port
		self.worker.perform_async *(@port.blank? ? [@host] : [@host, @port])
		@result = OpenStruct.new pending: true , date: Time.now
	end

	def check_host
		@id = params[:id]
		@host, @port = @id.split ':'
		@host = SimpleIDN.to_ascii @host.downcase
		if /[^a-zA-Z0-9.-]/.match @host
			flash[:danger] = "Hôte #{@host} invalide"
			redirect_to action: :index
			return false
		end
		@result = Datastore.host self.type, @host, @port
	end
end
