class Admin::StudentsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @q = Student.ransack(params[:q])
    @students = paginate_entries(@q.result).order(id: :asc)
  end

  def show
  end
end
