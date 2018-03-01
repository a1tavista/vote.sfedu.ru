module Admin
  class BaseController < ApplicationController
    layout 'admin'
    prepend_view_path 'app/views/admin'

    def index
      authorize!(:index, :admin)
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
