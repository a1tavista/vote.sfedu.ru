class Admin::TeachersController < Admin::BaseController
  load_and_authorize_resource

  def index
    @teachers = paginate_entries(@teachers).order(id: :asc)
  end

  def show
    @results = Stage.all.map { |stage| Teacher::Results.new(@teacher, stage) }
  end
end
