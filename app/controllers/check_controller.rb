class CheckController < ApplicationController
  before_action :check_host, except: %i[index]
  before_action :exclude_robots_indexing
  helper_method :tls_type, :type

  def show
    enqueue_host unless @analysis
    @host = SimpleIDN.to_unicode @host
    respond_to do |format|
      format.html do
        return render :processing if @analysis.pending
        @result = @analysis.result.collect { |r| RecursiveOpenStruct.new r, recurse_over_arrays: true }
      end
      format.json { render json: @analysis }
    end
  end

  def refresh
    unless @analysis.pending
      if Rails.env == 'production'
        refresh_allowed = @analysis.updated_at + Rails.configuration.refresh_delay
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

  def exclude_robots_indexing
    response.set_header 'X-Robots-Tag',
                        %i[none noarchive nosnippet notranslate noimageindex].join(',')
  end

  def default_args
  end

  def enqueue_host
    @analysis = Analysis.pending! self.type, @host, @args
    CheckWorkflow.start! self.type.to_s, @analysis.host, *@analysis.args
  end

  def check_host
    @id = params[:id]

    if @id.end_with? '.json'
      @id            = @id.sub /\.json$/, ''
      request.format = :json
    end

    @host, @args = @id.split ':'
    @host        = SimpleIDN.to_ascii @host.downcase
    if /[^a-zA-Z0-9.-]/ =~ @host
      flash[:danger] = "Hôte #{@host} invalide"
      redirect_to action: :index
      return false
    end
    @args        ||= default_args

    @analysis = Analysis[self.type, @host, @args]
  end
end
