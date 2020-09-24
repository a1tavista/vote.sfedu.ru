module Students
  class RootController < ApplicationController
    before_action :authenticate_user!

    def show
      render layout: 'student_account'
    end
  end
end
