class ApplicationController < ActionController::Base
  protect_from_forgery
  
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :render_500
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActionController::UnknownController, with: :render_404
    rescue_from AbstractController::ActionNotFound, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  end

  private
  def render_404(exception)
    log_error(exception)
    @exception = exception
    @not_found_path = exception.message
    render nothing: true, status: 404 and return false if request.xhr?
    render template: 'errors/error_404', layout: 'layouts/application', status: 404
  end

  def render_500(exception)
    log_error(exception)
    @exception = exception
    @error = exception
    render nothing: true, status: 500 and return false if request.xhr?
    render template: 'errors/error_500', layout: 'layouts/application', status: 500
  end
  
  def log_error(e)
    Rails.logger.error(e.inspect)
    Rails.logger.error(e.message)
    Rails.logger.error(e.backtrace.join("\n"))
  end
end
