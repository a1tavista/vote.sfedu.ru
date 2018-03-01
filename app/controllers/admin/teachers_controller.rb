class Admin::TeachersController < Admin::BaseController
  load_and_authorize_resource

  def index
    @q = Teacher.ransack(params[:q])
    @teachers = paginate_entries(@q.result).order(id: :asc)
  end

  def show
    @results = Stage.all.map { |stage| Teacher::Results.new(@teacher, stage) }
  end
end
