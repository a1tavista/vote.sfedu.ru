module Api
  class BaseController < ActionController::API
    include ActionView::Rendering
    include CanCan::ControllerAdditions
    include Devise::Controllers::Helpers

    before_action :verify_requested_format!
    before_action :authenticate_user!

    respond_to :json

    def current_kind
      @current_kind ||= current_user&.kind
    end

    def respond_with_errors(errors)
      render status: :unprocessable_entity, json: errors
    end
  end
end
