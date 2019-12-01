if defined? BetterErrors
  class BetterErrors::Middleware
    def protected_app_call(env)
      @app.call env
    rescue Exception => ex
      @error_page = @handler.new ex, env
      log_exception ex
      show_error_page(env, ex)
    end

    def log_exception(exception)
      Raven.capture_exception exception if defined? Raven
      return unless BetterErrors.logger

      message = "\n#{@error_page.exception_type} - #{@error_page.exception_message}:\n"
      message += backtrace_frames.map { |frame| "  #{frame}\n" }.join

      BetterErrors.logger.fatal message
    end
  end
end
