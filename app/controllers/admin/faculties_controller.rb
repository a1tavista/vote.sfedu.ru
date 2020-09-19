class Admin::FacultiesController < Admin::BaseController
  load_and_authorize_resource

  def index
    @faculties = paginate_entries(@faculties).order(name: :asc)
  end

  def show
  end
end
