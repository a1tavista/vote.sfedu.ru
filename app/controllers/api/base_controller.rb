class Api::BaseController < ActionController::API
  include ActionView::Rendering
  include CanCan::ControllerAdditions

  before_action :verify_requested_format!

  respond_to :json

  def current_kind
    # TODO: Retrieve student entity from current_user
  end

  def respond_with_errors(errors)
    render status: :unprocessable_entity, json: errors
  end
end
