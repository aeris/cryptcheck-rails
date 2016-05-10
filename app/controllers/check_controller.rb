class CheckController < ApplicationController
	before_action :check_host, except: %i(index)
	helper_method :tls_type, :type

	def show
		enqueue_host unless @result
		@host = SimpleIDN.to_unicode @host
		respond_to do |format|
			format.html do
				return render :processing if @result.pending
			end
			format.json do
				render json: case
					when @result.pending then :pending
					else @result
				end
			end
		end
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
		Datastore.pending self.type, @host, @port
		self.worker.perform_async *(@port.blank? ? [@host] : [@host, @port])
		@result = OpenStruct.new pending: true , date: Time.now
	end

	def check_host
		@id = params[:id]

		if @id.end_with? '.json'
			@id = @id.sub /\.json$/, ''
			request.format = :json
		end

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
