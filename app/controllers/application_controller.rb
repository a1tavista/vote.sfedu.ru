class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :update_sanitized_params, if: :devise_controller?

  def update_sanitized_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:identity_url, :identity_name])
  end
end
