module Admin
  class BaseController < ApplicationController
    layout 'admin'
    prepend_view_path 'app/views/admin'

    load_and_authorize_resource class: false

    def index; end

    def dev_console
      console
      render :index
    end

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_path
    end

    protected

    def paginate_entries(entry)
      entry.page(params[:page]).per(20)
    end

    private

    def current_ability
      @current_ability ||= AdminAbility.new(current_user)
    end
  end
end
