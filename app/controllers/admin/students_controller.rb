class Admin::StudentsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @students = paginate_entries(@students).order(id: :asc)
  end

  def show; end
end
