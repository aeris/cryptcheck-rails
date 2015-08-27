class SshController < ApplicationController
	before_action :check_host, except: %i(index)

	def check_host
		@host, @port = params[:id].split ':'
		@idn         = SimpleIDN.to_ascii @host
		if /[^a-zA-Z0-9.-]/.match @idn
			flash[:danger] = "Hôte #{@host} invalide"
			redirect_to :index
			return false
		end
		@host   = "#{@idn}:#{@port}"
		@result = Datastore.host :ssh, @host
	end

	def index
	end

	def show
		enqueue_host unless @result
		return render :processing if @result.pending
		return render :no_ssh if @result.no_ssh
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
		Datastore.pending :ssh, @host
		SSHWorker.perform_async @idn, @port
		@result = OpenStruct.new pending: true, date: Time.now
	end
end
