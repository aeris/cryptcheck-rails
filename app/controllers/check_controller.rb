class CheckController < ApplicationController
	before_action :check_host, except: %i(index)
	helper_method :tls_type, :type

	def show
		enqueue_host unless @analysis
		@host   = SimpleIDN.to_unicode @host
		respond_to do |format|
			format.html do
				return render :processing if @analysis.pending
				@result = @analysis.result.collect { |r| RecursiveOpenStruct.new r, recurse_over_arrays: true }
			end
			format.json { render json: @analysis }
		end
	end

	def refresh
		unless @result.pending
			if Rails.env == 'production'
				refresh_allowed = @result.updated_at + Rails.configuration.refresh_delay
				if Time.now < refresh_allowed
					flash[:warning] = "Merci d’attendre au moins #{l refresh_allowed} pour rafraîchir"
					return redirect_to action: :show, id: @host
				end
			end
			enqueue_host
		end
		redirect_to action: :show
	end

	protected
	def default_port
	end

	def enqueue_host
		@analysis = Analysis.pending! self.type, @host, (@port || self.default_port)
		self.worker.perform_async @analysis.host, @analysis.port
	end

	def check_host
		@id = params[:id]

		if @id.end_with? '.json'
			@id            = @id.sub /\.json$/, ''
			request.format = :json
		end

		@host, @port = @id.split ':'
		@host        = SimpleIDN.to_ascii @host.downcase
		if /[^a-zA-Z0-9.-]/ =~ @host
			flash[:danger] = "Hôte #{@host} invalide"
			redirect_to action: :index
			return false
		end
		if @port
			@port = @port.to_i
		else
			@port = self.default_port
		end

		@analysis = Analysis[self.type, @host, @port]
		# file = File.join Rails.root, 'config/host.yml'
		# File.write file, YAML.dump(@result)
		# @result = YAML.load File.read file
	end
end
