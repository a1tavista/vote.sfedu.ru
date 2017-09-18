class TeachersController < ApplicationController
  before_action :authenticate_user!

  def index
    current_user.kind.load_teachers! if current_user.kind.teachers_load_required?
    @evaluated = current_user.kind.evaluated_teachers(Stage.current)
    @available = current_user.kind.available_teachers(Stage.current)
  end
end
