module Admin
  class BaseController < ApplicationController
    layout 'admin'
    prepend_view_path 'app/views/admin'

    def index; end

    private

    def current_ability
      @current_ability ||= AdminAbility.new(current_user)
    end
  end
end
