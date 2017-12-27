class ApplicationController < ActionController::Base
  respond_to :html

  protect_from_forgery with: :exception
  before_action :update_sanitized_params, if: :devise_controller?
  before_action :set_raven_context

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:identity_url, :identity_name])
  end

  def current_kind
    current_user&.kind
  end

  rescue_from CanCan::AccessDenied do |exception|
    Raven.capture_exception(exception)
    render 'errors/access_denied', layout: 'application', locals: { message: exception.message }
  end

  private

  def set_raven_context
    Raven.user_context(id: current_user&.id, external_id: current_kind&.external_id)
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
