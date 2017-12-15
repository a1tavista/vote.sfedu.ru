class API::BaseController < ActionController::API
  include ActionView::Rendering
  include CanCan::ControllerAdditions

  before_action :verify_requested_format!

  respond_to :json
end

