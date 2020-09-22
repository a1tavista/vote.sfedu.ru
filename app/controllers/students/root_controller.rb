module Students
  class RootController < ApplicationController
    def show
      render layout: 'student_account'
    end
  end
end
