class TeachersController < ApplicationController
  before_action :authenticate_user!

  def index
    Teachers::AsStudent::FetchFromDataSource.run!(student: current_kind) if current_kind.teachers_load_required?
    @evaluated = current_kind.evaluated_teachers(Stage.current)
    @available = current_kind.available_teachers(Stage.current)
  end
end
