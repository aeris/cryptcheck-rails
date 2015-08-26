class CheckController < ApplicationController
	before_action :check_host

	def check_host
		@host = params[:id]
		@idn  = SimpleIDN.to_ascii @host
		if /[^a-zA-Z0-9.-]/.match @idn
			flash[:danger] = "Hôte #{@host} invalide"
			redirect_to :root
			return false
		end
		@result = Datastore.host self.type, @idn
	end

	def show
		enqueue_host unless @result
		return render :processing if @result.pending
		return render :no_tls if @result.no_tls
	end

	def refresh
		unless @result.pending
			refresh_allowed = @result.date + Rails.configuration.refresh_delay
			if Time.now < refresh_allowed
				flash[:warning] = "Merci d’attendre au moins #{l refresh_allowed} pour rafraîchir"
				return redirect_to result_path @host
			end
			enqueue_host
		end
		redirect_to action: :show
	end

	protected
	def enqueue_host
		Datastore.pending self.type, @host
		self.worker.perform_async @idn
		@result = OpenStruct.new pending: true , date: Time.now
	end
end
