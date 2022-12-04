class ApplicationController < ActionController::Base
  include ApplicationHelper

  #開発時は上段の記述を使用
  unless Rails.env.production?
  #unless Rails.env.development?
    rescue_from Exception,                      with: :render_500
    rescue_from ActiveRecord::RecordNotFound,   with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  private

  def render_404
    render 'error/404', status: :not_found
  end

  def render_500
    render 'error/500', status: :internal_server_error
  end
end
