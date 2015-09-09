class CheckController < ApplicationController
	before_action :check_host, except: %i(index)
	helper_method :tls_type, :type

	def index
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
				return redirect_to action: :show, id: @host
			end
			enqueue_host
		end
		redirect_to action: :show
	end

	protected
	def enqueue_host
		Datastore.pending self.type, @host
		self.worker.perform_async *(@port ? [@idn, @port] : [@idn])
		@result = OpenStruct.new pending: true , date: Time.now
	end

	def check_host
		@host, @port = params[:id].split ':'
		@idn         = SimpleIDN.to_ascii @host
		if /[^a-zA-Z0-9.-]/.match @idn
			flash[:danger] = "Hôte #{@host} invalide"
			redirect_to action: :index
			return false
		end
		@host   = "#{@idn}:#{@port}" if @port
		@result = Datastore.host self.type, @host
	end
end
