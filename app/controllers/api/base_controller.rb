require "application_responder"

class API::BaseController < ActionController::API
  include ActionView::Rendering
  include CanCan::ControllerAdditions
  self.responder = ApplicationResponder

  before_action :verify_requested_format!

  respond_to :json
end

